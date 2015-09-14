require "spec_helper"
require "hashie"

describe TOC::Helpers do
  let(:helper)                 { HelperTester.new }
  let(:basic_chapter_title)    { "What even is middleman?" }
  let(:basic_guide_title)      { "Middleman Basics" }
  let(:basics_page)            { double(path: "middleman-basics/index.html") }

  before(:each) do
    class HelperTester
      include TOC::Helpers
    end

    data_yml = File.read('spec/fixtures/pages.yml')
    data = Hashie::Mash.new(pages: YAML.load(data_yml))

    allow(helper).to receive(:data).and_return(data)
    allow(helper).to receive(:current_page).and_return(basics_page)
    allow(helper).to receive(:link_to).and_wrap_original do |_, title, url|
      %Q{<a href="#{url}">#{title}</a>}
    end
  end

  after do
    # Remove our testing class
    Object.send :remove_const, :HelperTester
  end

  describe "#toc_for" do
    let(:toc) { helper.toc_for(helper.data.pages) }

    before(:each) do
      allow(File).to receive(:exist?).and_return(true)
    end

    it "raises an exception if a file doesn't exist" do
      allow(File).to receive(:exist?).and_return(false)
      expect { toc }.to raise_error(RuntimeError,
        /source\/middleman-basics\/index.md does not exist but is referenced in data\/guides.yml./)
    end

    it "includes guide titles" do
      expect(toc).to include("What even is middleman?")
    end

    it "does not includes guide titles that are marked to skip" do
      expect(toc).not_to include("Secret stuff")
    end

    it "does not includes chapter titles that are marked to skip" do
      expect(toc).not_to include("Nobody really cares about this")
    end

    it "includes guide urls" do
      expect(toc).to include("middleman-basics")
    end

    it "does not include guide urls for guides that are marked to skip" do
      expect(toc).not_to include("secret")
    end

    it "does not include chapter urls that are marked to skip" do
      expect(toc).not_to include("meh")
    end

    it "contains a link to first chapter as a guide link even if a chapter is marked skip" do
      expect(toc).to include("middleman-basics")
    end

    it "links to the innermost page" do
      expect(toc).to include("<a href=\"/middleman-basics/index.html\">")
    end

    it "links to hashes for parents of nested pages" do
      expect(toc).to include("<a href=\"#\">Middleman Basics</a>")
    end

    it "adds the toc-level-0 class to the outermost <ol>" do
      expect(toc).to include("<ol class='toc-level-0 selected'><li class='toc-level-0 selected'>")
    end

    it "adds the toc-level-0 class to the outermost <li>s" do
      expect(toc).to include("<li class='toc-level-0 selected'>")
    end

    it "adds the toc-level-1 class to the inner <ol>s" do
      expect(toc).to include("<ol class='toc-level-1 selected'><li class='toc-level-1")
    end

    it "adds the toc-level-1 class to the inner <li>s" do
      expect(toc).to include("<li class='toc-level-1 selected'><a href=\"/middleman-basics/index.html\">")
    end

    it "adds the selected class to the outermost <li> tag" do
      expect(toc).to include("<li class='toc-level-0 selected'>")
    end

    it "adds the selected class to the <ol> tag of the current page" do
      expect(toc).to include("<ol class='toc-level-1 selected'>")
    end

    it "adds the selected class to the <li> tag of the current page" do
      expect(toc).to include("<li class='toc-level-1 selected'>")
    end
  end

  describe "#full_page_title" do
    it "is the current page's title" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics"))

      expect(helper.full_page_title).to eq("Middleman Basics")
    end

    it "combines the page titles separated by colons" do
      expect(helper.full_page_title).to eq("#{basic_guide_title}: #{basic_chapter_title}")
    end
  end

  describe "#page_title" do
    it "is just the current page's title without parent page's titles" do
      expect(helper.page_title).to eq(basic_chapter_title)
    end
  end

  describe "#chapter_links" do
    it "is markup that consists of previous & next chapter links" do
      allow(helper).to receive(:current_page).and_return(double(path: "secret"))

      expect(helper.chapter_links).to include("What are extensions?")
      expect(helper.chapter_links).to include("Nobody really cares about this")
    end
  end

  describe "#previous_chapter_link" do
    it "is link to previous chapter in current guide if previous chapter is specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/meh"))

      expect(helper.previous_chapter_link).to include("What even is middleman")
      expect(helper.previous_chapter_link).to include("middleman-basics/index")
    end

    it "is link to last chapter in previous guide if current chapter is first chapter in previous guide" do
      allow(helper).to receive(:current_page).and_return(double(path: "secret"))

      expect(helper.previous_chapter_link).to include("Nobody really cares about this")
    end
  end

  describe "#next_chapter_link" do
    it "is link to next chapter in current guide if next chapter is specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/index"))

      expect(helper.next_chapter_link).to include("Nobody really cares about this")
    end

    it "is link to the first chapter in next guide if next chapter is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/meh"))

      expectation = "We've finished covering Middleman Basics. Next up: Secret stuff - Don't tell anybody"
      expect(helper.next_chapter_link).to include(expectation)
    end
  end

  describe "#previous_chapter" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.previous_chapter).to be_nil
    end

    it "is nil if current chapter index is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.previous_chapter).to be_nil
    end

    it "is nil if current chapter is the first chapter in the guide" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/index"))

      expect(helper.previous_chapter).to be_nil
    end

    it "is the previous chapter when current guide & current chapter are specified & there is a chapter before that" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/meh"))
      previous_chapter = helper.data.pages.first.pages.first

      expect(helper.previous_chapter).to eq(previous_chapter)
    end
  end

  describe "#next_chapter" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.next_chapter).to be_nil
    end

    it "is nil if current chapter is the last chapter in the guide" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/meh"))

      expect(helper.next_chapter).to be_nil
    end

    it "is the next chapter when current guide has a next chapter" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/index"))
      next_chapter = helper.data.pages.first.pages.last

      expect(helper.next_chapter).to eq(next_chapter)
    end
  end

  describe "#previous_guide" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.previous_guide).to be_nil
    end

    it "is nil if current guide is the first guide" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/index"))

      expect(helper.previous_guide).to be_nil
    end

    it "is the previous guide when current guide is specified & there is a guide before that" do
      allow(helper).to receive(:current_page).and_return(double(path: "secret"))
      first_guide = helper.data.pages.first

      expect(helper.previous_guide).to eq(first_guide)
    end
  end

  describe "#next_guide" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.next_guide).to be_nil
    end

    it "is nil if current guide is the last guide" do
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/index"))

      expect(helper.next_guide).to be_nil
    end

    it "is the next guide when current guide is specified & next guide exists" do
      allow(helper).to receive(:current_page).and_return(double(path: "secret"))
      next_guide = helper.data.pages.last
      expect(helper.next_guide).to eq(next_guide)
    end
  end

end
