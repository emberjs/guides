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
    def index_for(guides)
      result = '<ol id="toc-list">'

      guides.each do |guide|
        next if guide.chapters.any? do |entry|
          entry[:skip_sidebar]
        end

        slugs = request.path.split('/')

        requested_guide_url = slugs[0]
        current = (guide.url == requested_guide_name)

        middleman_url = "/#{guide.url}/#{guide.chapters[0].url}.html"

        result << %Q{
          <li class="level-1#{current ? ' selected' : ''}">
            #{link_to(guide.title, middleman_url)}
            <ol#{current ? " class='selected'" : ''}>
        }

        guide.chapters.each do |chapter|
          next if chapter[:skip_sidebar_item]

          url = "#{guide.url}/#{chapter.url}.html"

          sub_current = (url == current_page.path)

          middleman_url = "/" + url
          result << %Q{
            <li class="level-3#{sub_current ? ' sub-selected' : ''}">
              #{link_to(chapter.title, middleman_url)}
            </li>
          }
        end
        result << '</ol></li>'
      end

      result << '</ol>'

      result
    end

    def chapter_name
      if current_guide
        return current_guide.title
      else
        return ""
      end
    end

    def section_name
      current_section[0] if current_section
    end

    def chapter_heading
      name = chapter_name.strip
      return if name.blank?

      %Q{
        <h1>#{name}
          <a href="#{chapter_github_source_url}" target="_blank" class="edit-page icon-pencil">Edit Page</a>
        </h1>
      }
    end

    def section_slug
      request.path.split('/')[1]
    end

    def guide_slug
      request.path.split('/')[1..-2].join('/')
    end

    def chapter_github_source_url
      base_guide_url = "https://github.com/emberjs/website/tree/master/source/guides"
      if section_slug == guide_slug
        return "#{base_guide_url}/#{current_guide['url']}/index.md"
      else
        return "#{base_guide_url}/#{current_guide['url'].gsub(/.html/, '')}.md"
      end
    end

    def current_section
      # section_prefix = section_slug + "/"
      # data.guides.find do |section, entries|
      #   entries.find do |entry|
      #     url = entry.url
      #     url.starts_with?(section_prefix) || url == section_slug
      #   end
      # end
    end

    def current_guide
      return unless current_section

      if guide_slug == '' && section_slug == 'index.html'
        current_section[1][0]
      else
        current_section[1].find do |guide|
          guide.url == guide_slug
        end
      end
    end

    def chapter_links(current_page)
      # %Q{
      # <footer>
      #   #{previous_chapter_link} #{next_chapter_link}
      # </footer>
      # }
    end

    def previous_chapter_link
      if previous_chapter
        %Q{
          <a class="previous-guide" href="../guides/#{previous_chapter.url}">
            \u2190 #{previous_chapter.title}
          </a>
        }
      elsif whats_before = previous_guide
        previous_chapter = whats_before[1][-1]
        %Q{
          <a class="previous-guide" href="../guides/#{previous_chapter.url}">
             \u2190 #{whats_before[0]}: #{previous_chapter.title}
          </a>
        }
      else
        ''
      end
    end

    def next_chapter_link
      if next_chapter
      %Q{
        <a class="next-guide" href="/guides/#{next_chapter.url}">
          #{next_chapter.title} \u2192
        </a>
      }
      elsif whats_next = next_guide
        next_chapter = whats_next[1][0]
        if section_slug == 'index.html'
          %Q{
            <a class="next-guide" href="../guides/#{next_chapter.url}">
              #{next_chapter.title} \u2192
            </a>
          }
        else
          %Q{
            <a class="next-guide" href="../guides/#{next_chapter.url}">
               We're done with #{current_section[0]}. Next up: #{whats_next[0]} - #{next_chapter.title} \u2192
            </a>
          }
        end
      else
        ''
      end
    end

    def previous_chapter
      return if not current_section

      guides = current_section[1]
      current_index = guides.find_index(current_guide)

      return unless current_index

      if current_index != 0
        guides[current_index-1]
      else
        nil
      end
    end

    def next_chapter
      return if not current_section

      guides = current_section[1]
      current_index = guides.find_index(current_guide)
      return unless current_index

      next_guide_index = current_index + 1

      if current_index < guides.length
        guides[next_guide_index]
      else
        nil
      end
    end

    def next_guide
      return if not current_section
      guide = current_section[0]
      current_guide_index = data.guides.keys.find_index(guide)

      return unless current_guide_index

      next_guide_index = current_guide_index + 1

      if current_guide_index < data.guides.length
        data.guides.entries[next_guide_index]
      else
        nil
      end
    end

    def previous_guide
      return if not current_section
      guide = current_section[0]

      current_guide_index = data.guides.keys.find_index(guide)
      return unless current_guide_index

      previous_guide_index = current_guide_index - 1

      if previous_guide_index >= 0
        data.guides.entries[previous_guide_index]
      else
        nil
      end
    end

    def warning
      return unless current_guide
      return unless current_section
      warning_key = current_guide["warning"]
      warning_key ? WARNINGS[warning_key] : nil
    end


    WARNINGS = {
        "canary"=>  %Q{
          <div class="under_construction_warning">
            <h3>
              <div class="msg">
                WARNING: this guide refers to a feature only available in canary (nightly/unstable) builds of Ember.js.
              </div>
            </h3>
          </div>
        },
        "canary-data"=>  %Q{
          <div class="under_construction_warning">
            <h3>
              <div class="msg">
                WARNING: this guide refers to a feature only available in canary (nightly/unstable) builds of Ember Data.
              </div>
            </h3>
          </div>
        }
    }

  end
end

::Middleman::Extensions.register(:toc, TOC)
