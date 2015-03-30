require "coderay"
class EmberEncoder < CodeRay::Encoders::Div
  FILE_EXTENSION = 'ember.html'
  register_for :ember

  DEFAULT_OPTIONS = {
    :tab_width => 8,

    :css   => :class,
    :style => :alpha,
    :wrap  => nil,
    :title => 'CodeRay output',

    :break_lines => false,

    :line_numbers        => nil,
    :line_number_anchors => 'n',
    :line_number_start   => 1,
    :bold_every          => 10,
    :highlight_lines     => nil,

    :hint => false,
  }

  # Copied from CodeRay definition then modified
  module Numbering
    def self.number! output, mode = :table, options = {}
      return self unless mode

      options = DEFAULT_OPTIONS.merge options

      start = options[:line_number_start]
      unless start.is_a? Integer
        raise ArgumentError, "Invalid value %p for :line_number_start; Integer expected." % start
      end

      anchor_prefix = options[:line_number_anchors]
      anchor_prefix = 'line' if anchor_prefix == true
      anchor_prefix = anchor_prefix.to_s[/[\w-]+/] if anchor_prefix
      anchoring =
        if anchor_prefix
          proc do |line|
            line = line.to_s
            anchor = anchor_prefix + line
            "<a href=\"##{anchor}\" name=\"#{anchor}\">#{line}</a>"
          end
        else
          :to_s.to_proc
        end

      bold_every = options[:bold_every]
      highlight_lines = options[:highlight_lines]
      bolding =
        if bold_every == false && highlight_lines == nil
          anchoring
        elsif highlight_lines.is_a? Enumerable
          highlight_lines = highlight_lines.to_set
          proc do |line|
            if highlight_lines.include? line
              "<strong class=\"highlighted\">#{anchoring[line]}</strong>"  # highlighted line numbers in bold
            else
              anchoring[line]
            end
          end
        elsif bold_every.is_a? Integer
          raise ArgumentError, ":bolding can't be 0." if bold_every == 0
          proc do |line|
            if line % bold_every == 0
              "<strong>#{anchoring[line]}</strong>"  # every bold_every-th number in bold
            else
              anchoring[line]
            end
          end
        else
          raise ArgumentError, 'Invalid value %p for :bolding; false or Integer expected.' % bold_every
        end

      if position_of_last_newline = output.rindex(RUBY_VERSION >= '1.9' ? /\n/ : ?\n)
        after_last_newline = output[position_of_last_newline + 1 .. -1]
        ends_with_newline = after_last_newline[/\A(?:<\/span>)*\z/]

        if ends_with_newline
          line_count = output.count("\n")
        else
          line_count = output.count("\n") + 1
        end
      else
        line_count = 1
      end

      case mode
      when :inline
        max_width = (start + line_count).to_s.size
        line_number = start
        output.gsub!(/^.*$\n?/) do |line|
          line_number_text = bolding.call line_number
          indent = ' ' * (max_width - line_number.to_s.size)
          line_number += 1
          "<span class=\"line-numbers\">#{indent}#{line_number_text}</span>#{line}"
        end

      when :table
        line_numbers = (start ... start + line_count).map(&bolding).join("\n")
        line_numbers << "\n"
        # ADDED
        line_numbers = EmberEncoder.highlight_lines(options[:highlights], line_numbers)
        # END ADDED
        # CHANGED
        line_numbers_table_template = CodeRay::Encoders::HTML::Output::TABLE.apply('LINE_NUMBERS', line_numbers)
        # END CHANGED

        output.gsub!(/<\/div>\n/, '</div>')
        output.wrap_in! line_numbers_table_template
        output.wrapped_in = :div

      when :list
        raise NotImplementedError, 'The :list option is no longer available. Use :table.'

      else
        raise ArgumentError, 'Unknown value %p for mode: expected one of %p' %
          [mode, [:table, :inline]]
      end

      output
    end
  end

  # Copied from CodeRay definition then modified
  def finish options
    unless @opened.empty?
      @out << '</span>' while @opened.pop
      @last_opened = nil
    end

    highlight_lines(options)

    if @out.respond_to? :to_str
      # CHANGED
      @out.extend CodeRay::Encoders::HTML::Output
      # END CHANGED
      @out.css = @css
      if options[:line_numbers]
        Numbering.number! @out, options[:line_numbers], options
      end
      @out.wrap! options[:wrap]
      @out.apply_title! options[:title]
    end

    if defined?(@real_out) && @real_out
      @real_out << @out
      @out = @real_out
    end

    # CHANGED
    # We want to skip over the HTML encoder's version, and just call the Encoder's one
    fin = CodeRay::Encoders::Encoder.instance_method(:finish)
    fin.bind(self).call(options)
    # END CHANGED
  end

  # ADDED
  def highlight_lines(options)
    @out = self.class.highlight_lines(options[:highlights], @out)
  end

  def self.highlight_lines(changes, content)
    contents = content.split("\n")

    changes.each do |line_number, state|
      index = line_number - 1
      contents[index] = "<span class=\"highlight-line #{state}\">#{contents[index]}</span>"
    end

    contents.join("\n")
  end
  # END ADDED
end
