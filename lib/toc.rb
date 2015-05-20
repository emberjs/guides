require 'redcarpet'
require 'pry'

module TOC
  class << self
    def registered(app)
      app.helpers Helpers
    end
    alias :included :registered
  end

  module TableOfContents
    extend self

    def anchorify(text)
      text.gsub(/&#?\w+;/, '-').gsub(/\W+/, '-').gsub(/^-|-$/, '').downcase
    end
  end

  module Helpers
    def toc_for(guides)
      buffer = "<ol id='toc-list'>"
      # indentation below is to aid in understanding the HTML structure
        guides.each do |guide|
          next if guide.chapters.any? do |entry|
            entry[:skip_sidebar]
          end

          slugs = request.path.split('/')

          requested_guide_url = slugs[0]
          current = (guide.url == requested_guide_url)

          middleman_base_url = "/#{guide.url}/#{guide.chapters[0].url}"
          middleman_url = middleman_base_url + ".html"

          file = "source" + middleman_base_url + ".md"
          raise "#{file} does not exist but is referenced in data/guides.yml. " unless File.exist?(file)

          buffer << "<li class='level-1 #{current ? 'selected' : ''}'>"
            buffer << link_to(guide.title, middleman_url)
            buffer << "<ol class='#{(current ? 'selected' : '')}'>"
              guide.chapters.each do |chapter|
                next if chapter[:skip_sidebar_item]
                url = "#{guide.url}/#{chapter.url}.html"

                sub_current = (url == current_page.path)

                middleman_url = "/" + url

                buffer << "<li class='level-3 #{sub_current ? ' sub-selected' : ''}'>"
                  buffer << link_to(chapter.title, middleman_url)
                buffer << "</li>"
              end
            buffer << "</ol>"
          buffer << "</li>"
        end

      buffer << "</ol>"
      buffer
    end

    def page_title
      if current_guide && current_chapter
        "#{current_guide.title}: #{current_chapter.title}"
      elsif current_guide
        current_guide.title
      else
        "Guides"
      end
    end

    def guide_name
      current_guide.title if current_guide
    end

    def chapter_name
      if current_chapter
        current_chapter.title
      else
        ""
      end
    end

    def chapter_heading
      name = chapter_name.strip
      return if name.blank?

      %Q{
        <h1>
          #{name}
          <a href="#{chapter_github_source_url}" target="_blank" class="edit-page icon-pencil">Edit Page</a>
        </h1>
      }
    end

    def chapter_github_source_url
      "https://github.com/emberjs/guides/edit/master/source/#{current_page.path.gsub('.html', '.md')}"
    end

    def current_guide
      return @current_guide if @current_guide

      path = current_page.path.gsub('.html', '')
      guide_path = path.split("/")[0]

      @current_guide = data.guides.find do |guide|
        guide.url == guide_path
      end
    end

    def current_guide_index
      data.guides.find_index(current_guide)
    end

    def current_chapter
      return unless current_guide

      return @current_chapter if @current_chapter
      path = current_page.path.gsub('.html', '')
      chapter_path = path.split('/')[1..-1].join('/')

      @current_chapter = current_guide.chapters.find do |chapter|
        chapter.url == chapter_path
      end
    end

    def current_chapter_index
      return unless current_guide
      current_guide.chapters.find_index(current_chapter)
   end

    def chapter_links
      %Q{
      <footer>
        #{previous_chapter_link} #{next_chapter_link}
      </footer>
      }
    end

    def previous_chapter_link
      options = {:class => 'previous-guide'}

      if previous_chapter
        url = "/#{current_guide.url}/#{previous_chapter.url}.html"
        title = " \u2190 #{previous_chapter.title}"

        link_to(title, url, options)
      elsif whats_before = previous_guide
        previous_chapter = whats_before.chapters.last

        is_root = previous_chapter.url.empty?

        url = is_root ? "/#{previous_guide.url}.html" : "/#{previous_guide.url}/#{previous_chapter.url}.html"

        title = " \u2190 #{previous_chapter.title}"

        link_to(title, url, options)
      else
        ''
      end
    end

    def next_chapter_link
      options = {:class => 'next-guide'}

      if next_chapter
        url = "/#{current_guide.url}/#{next_chapter.url}.html"
        title = "#{next_chapter.title} \u2192"

        link_to(title, url, options)
      elsif whats_next = next_guide
        next_chapter = whats_next.chapters.first
        title = "We're done with #{current_guide.title}. Next up: #{next_guide.title} - #{next_chapter.title} \u2192"
        url = "/#{next_guide.url}/#{next_chapter.url}.html"

        link_to(title, url, options)
      else
        ''
      end
    end

    def previous_chapter
      return unless current_guide

      current_chapter_index = current_guide.chapters.find_index(current_chapter)

      return unless current_chapter_index

      previous_chapter_index = current_chapter_index - 1

      if current_chapter_index > 0
        current_guide.chapters[previous_chapter_index]
      else
        nil
      end
    end

    def next_chapter
      return unless current_guide

      current_chapter_index = current_guide.chapters.find_index(current_chapter)
      return unless current_chapter_index

      next_chapter_index = current_chapter_index + 1

      if current_chapter_index < current_guide.chapters.length
        current_guide.chapters[next_chapter_index]
      else
        nil
      end
    end

    def previous_guide
      return unless current_guide

      current_guide_index = data.guides.find_index(current_guide)
      return unless current_guide_index

      previous_guide_index = current_guide_index - 1

      if previous_guide_index >= 0
        data.guides[previous_guide_index]
      else
        nil
      end
    end

    def next_guide
      return unless current_guide

      current_guide_index = data.guides.find_index(current_guide)
      return unless current_guide_index

      next_guide_index = current_guide_index + 1

      if current_guide_index < data.guides.length
        data.guides[next_guide_index]
      else
        nil
      end
    end

  end
end

::Middleman::Extensions.register(:toc, TOC)
