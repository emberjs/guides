require "redcarpet"
require "coderay"

module Highlighter
  class MissingLanguageError < StandardError; end
  class << self
    def registered(app)
      app.helpers Helpers
    end
    alias :included :registered
  end

  module Helpers
    def _highlight(string, language, class_name=nil)
      error_message = "Code blocks must be fenced with proper language designated. If you don't know what language to use, specify ```text.\n\n"
      error_message << "Offending Code Block:\n\n#{string}"

      raise MissingLanguageError, error_message if language.nil?

      language, file_name = _detect_language_and_filename(language)

      result = %Q{<div class="highlight #{language} #{class_name}">}
      result += '<div class="ribbon"></div>'
      result += '<div class="scroller">'
      result += _code_table(string, language, file_name)
      result += '</div>'
      result += %Q{</div>}
      result
    end

    def _detect_language_and_filename(language)

      file_name = nil
      bare_language_regex = /\A\w+\z/

      unless language =~ bare_language_regex
        file_name = language

        language = case /\.(\w+)$/.match(language)[1]
                   when 'hbs'
                     'handlebars'
                   when 'js'
                     'javascript'
                   when 'html'
                     'html'
                   when 'css'
                     'css'
                   when 'json'
                     'json'
                   end
      end
      [language, file_name]
    end

    def _code_table(string, language, file_name)
      code = CodeRay.scan(string, language)

      table = code.div css: :class,
        line_numbers: :table,
        line_number_anchors: false

      if file_name.present?

        table = table.sub('<table class="CodeRay">', <<-HEADER)
<table class="CodeRay">
  <thead>
    <tr>
      <td colspan="2">#{file_name}</td>
    </tr>
  </thead>
HEADER
      end

      table
    end

    def highlight(language, class_name, &block)
      concat(_highlight(capture(&block), language, class_name))
    end
  end

  class HighlightedHTML < Redcarpet::Render::HTML
    include Helpers

    def header(text, level)
      "<h#{level} class='anchorable-toc' id='toc_#{TOC::TableOfContents.anchorify(text)}'>#{text}</h#{level}>"
    end

    def block_code(code, language)
      _highlight(code, language)
    end
  end
end

::Middleman::Extensions.register(:highlighter, Highlighter)
