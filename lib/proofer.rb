require 'html/proofer'

class HtmlProofer < Middleman::Extension
  def initialize(app, options={}, &block)
    super
    app.after_build do
      HTML::Proofer.new('./build', {
        :verbose          => true,
        :alt_ignore       => [/.*/],
        :href_ignore      => ['#', '/blog/feed.xml'],
        :disable_external => true,
      }).run
    end
  end
end

::Middleman::Extensions.register :html_proofer, HtmlProofer
