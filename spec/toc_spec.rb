require "spec_helper"
require "hashie"

describe TOC::Helpers do
  let(:helper)                 { HelperTester.new }
  let(:basic_chapter_title)    { "What even is middleman?" }
  let(:basic_guide_title)      { "Middleman Basics" }
  let(:basics_page)            { double(path: "middleman-basics/intro") }

  before(:each) do
    class HelperTester
      include TOC::Helpers
    end

    data_yml = File.read('spec/fixtures/guides.yml')
    data = Hashie::Mash.new(YAML.load(data_yml))

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
      allow(helper).to receive(:request).and_return(basics_page)
      allow(File).to receive(:exist?).and_return(true)
    end

    it "raises an exception if a file doesn't exist" do
      allow(File).to receive(:exist?).and_return(false)
      expect { toc }.to raise_error(RuntimeError,
        /source\/middleman-basics\/intro.md does not exist but is referenced in data\/guides.yml./)
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
      expect(toc).to include("extending-middleman")
    end

    it "adds the toc-level-0 class to the outermost <ol>" do
      expect(toc).to include("<ol class='toc-level-0 selected'><li class='toc-level-0 selected'>")
    end

    it "adds the toc-level-0 class to the outermost <li>s" do
      expect(toc).to include("<li class='toc-level-0 selected'><a href=\"/middleman-basics\">")
    end

    it "adds the toc-level-1 class to the inner <ol>s" do
      expect(toc).to include("<ol class='toc-level-1 selected'><li class='toc-level-1")
    end

    it "adds the toc-level-1 class to the inner <li>s" do
      expect(toc).to include("<li class='toc-level-1 selected'><a href=\"/middleman-basics/intro\">")
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

  describe "#page_title" do
    it "is generic when current guide is not specified" do
      allow(helper).to receive(:current_guide).and_return(nil)

      expect(helper.page_title).to eq("Guides")
    end

    it "is current guide's title when current chapter is not specified" do
      allow(helper).to receive(:current_chapter).and_return(nil)

      expect(helper.page_title).to eq("Middleman Basics")
    end

    it "is a combination of current guide & chapter titles when both are specified" do
      expect(helper.page_title).to eq("#{basic_guide_title}: #{basic_chapter_title}")
    end
  end

  describe "#guide_name" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_guide).and_return(nil)

      expect(helper.guide_name).to be_nil
    end

    it "is the current guide's title when current guide is specified" do
      expect(helper.guide_name).to eq(basic_guide_title)
    end
  end

  describe "#chapter_name" do
    it "is an empty string when current chapter is not specified" do
      allow(helper).to receive(:current_chapter).and_return(nil)

      expect(helper.chapter_name).to eq("")
    end

    it "is current chapter's title when current chapter is specified" do
      expect(helper.chapter_name).to eq(basic_chapter_title)
    end
  end

  describe "#chapter_heading" do
    it "is nil if chapter name is blank" do
      allow(helper).to receive(:chapter_name).and_return("")

      expect(helper.chapter_heading).to be_nil
    end

    it "is header markup with name & source URL when chapter name is specified" do
      expect(helper.chapter_heading).to include(basic_chapter_title)
      expect(helper.chapter_heading).to include("https://github.com/emberjs/guides/edit")
    end
  end

  describe "#chapter_github_source_url" do
    it "is the github URL to the source file for current page" do
      expect(helper.chapter_github_source_url).to eq("https://github.com/emberjs/guides/edit/master/source/middleman-basics/intro.md")
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
      expect(helper.previous_chapter_link).to include("middleman-basics/intro")
    end

    it "is link to last chapter in previous guide if current chapter is first chapter in previous guide" do
      allow(helper).to receive(:current_page).and_return(double(path: "secret"))

      expect(helper.previous_chapter_link).to include("Nobody really cares about this")
    end
  end

  describe "#next_chapter_link" do
    it "is link to next chapter in current guide if next chapter is specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/intro"))

      expect(helper.next_chapter_link).to include("Nobody really cares about this")
    end

    it "is link to the first chapter in next guide if next chapter is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/meh"))

      expectation = "We're done with Middleman Basics. Next up: Secret stuff - Don't tell anybody"
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
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/intro"))

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
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/intro"))
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
      allow(helper).to receive(:current_page).and_return(double(path: "middleman-basics/intro"))

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
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/intro"))

      expect(helper.next_guide).to be_nil
    end

    it "is the next guide when current guide is specified & next guide exists" do
      allow(helper).to receive(:current_page).and_return(double(path: "secret"))
      next_guide = helper.data.pages.last
      expect(helper.next_guide).to eq(next_guide)
    end
  end

end
