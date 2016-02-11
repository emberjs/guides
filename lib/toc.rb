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
    def toc_for(pages, level=0, base_path="", parent_current=true)
      buffer = "<ol class='toc-level-#{level}#{parent_current ? ' selected' : ''}'>"
      # indentation below is to aid in understanding the HTML structure
        pages.each do |page|
          next if page.skip_toc

          requested_page_url = current_page.path.gsub('.html', '').split('/')[level]
          current = (parent_current && page.url == requested_page_url)

          page_path = base_path + "/" + page.url

          unless page.pages || File.exist?(file = "source" + page_path + ".md")
            raise "#{file} does not exist but is referenced in data/guides.yml."
          end

          buffer << "<li class='toc-level-#{level} #{current ? 'selected' : ''}'>"
            if page.pages
              buffer << link_to(page.title, '#')
              buffer << toc_for(page.pages, level + 1, page_path, current)
            else
              buffer << link_to(page.title, page_path + '.html')
            end
          buffer << "</li>"
        end

      buffer << "</ol>"
      buffer
    end

    def full_page_title
      current_titles.join(": ")
    end

    def page_title
      current_titles.last
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
        title = previous_chapter.title

        link_to(title, url, options)
      elsif whats_before = previous_guide
        previous_chapter = whats_before.pages.last

        is_root = previous_chapter.url.empty?

        url = is_root ? "/#{previous_guide.url}.html" : "/#{previous_guide.url}/#{previous_chapter.url}.html"

        title = previous_chapter.title

        link_to(title, url, options)
      else
        ''
      end
    end

    def next_chapter_link
      options = {:class => 'next-guide'}

      if next_chapter
        url = "/#{current_guide.url}/#{next_chapter.url}.html"
        title = next_chapter.title

        link_to(title, url, options)
      elsif whats_next = next_guide
        next_chapter = whats_next.pages.first
        title = "We've finished covering #{current_guide.title}. Next up: #{next_guide.title} - #{next_chapter.title}"
        url = "/#{next_guide.url}/#{next_chapter.url}.html"

        link_to(title, url, options)
      else
        ''
      end
    end

    def previous_chapter
      return unless current_guide

      current_chapter_index = current_guide.pages.find_index(current_chapter)

      return unless current_chapter_index

      previous_chapter_index = current_chapter_index - 1

      if current_chapter_index > 0
        current_guide.pages[previous_chapter_index]
      else
        nil
      end
    end

    def next_chapter
      return unless current_guide

      current_chapter_index = current_guide.pages.find_index(current_chapter)
      return unless current_chapter_index

      next_chapter_index = current_chapter_index + 1

      if current_chapter_index < current_guide.pages.length
        current_guide.pages[next_chapter_index]
      else
        nil
      end
    end

    def previous_guide
      return unless current_guide

      current_guide_index = data.pages.find_index(current_guide)
      return unless current_guide_index

      previous_guide_index = current_guide_index - 1

      if previous_guide_index >= 0
        data.pages[previous_guide_index]
      else
        nil
      end
    end

    def next_guide
      return unless current_guide

      current_guide_index = data.pages.find_index(current_guide)
      return unless current_guide_index

      next_guide_index = current_guide_index + 1

      if current_guide_index < data.pages.length
        data.pages[next_guide_index]
      else
        nil
      end
    end

private

    def current_titles
      @current_titles ||= current_pages.map(&:title)
    end

    def current_pages
      @current_pages ||= pages_for_slugs(current_slugs)
    end

    def current_slugs
      @current_slugs ||= current_page.path.gsub(".html", "").split("/")
    end

    def pages_for_slugs(slugs, pages=data.pages)
      current_slug = slugs.shift
      page = pages.find { |page| page.url == current_slug }
      remaining_pages = slugs.any? ? pages_for_slugs(slugs, page.pages) : []
      [page] + remaining_pages
    end

    def current_guide
      return @current_guide if @current_guide

      path = current_page.path.gsub('.html', '')
      guide_path = path.split("/")[0]

      @current_guide = data.pages.find do |guide|
        guide.url == guide_path
      end
    end

    def current_guide_index
      data.pages.find_index(current_guide)
    end

    def current_chapter
      return unless current_guide

      return @current_chapter if @current_chapter
      path = current_page.path.gsub('.html', '')
      chapter_path = path.split('/')[1..-1].join('/')

      @current_chapter = current_guide.pages.find do |chapter|
        chapter.url == chapter_path
      end
    end

    def current_chapter_index
      return unless current_guide
      current_guide.chapters.find_index(current_chapter)
    end

  end
end

::Middleman::Extensions.register(:toc, TOC)
