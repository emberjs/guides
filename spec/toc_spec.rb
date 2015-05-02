require "spec_helper"
require "hashie"

describe TOC::Helpers do
  let(:helper)                 { HelperTester.new }
  let(:basic_chapter_title)    { "What even is middleman?" }
  let(:basic_guide_title)      { "Middleman Basics" }
  let(:basics_page)            { double(path: "middleman-basics/index.html") }
  let(:toc)                    { helper.toc_for(helper.data.guides) }

  before(:each) do
    class HelperTester
      include TOC::Helpers
    end

    data_yml = %Q{
guides:
  - title: "Middleman Basics"
    url: "middleman-basics"
    chapters:
      - title: "What even is middleman?"
        url: "index"
      - title: "Nobody really cares about this"
        url: "meh"
        skip_sidebar_item: true
  - title: "Secret stuff"
    url: "secret"
    chapters:
      - title: "Don't tell anybody"
        url: ""
        skip_sidebar: true
    }

    data = Hashie::Mash.new(YAML.load(data_yml))
    testing_page = double(path: "custom-extensions/testing-custom-extensions.html")

    allow(helper).to receive(:data).and_return(data)
    allow(helper).to receive(:current_page).and_return(testing_page)
    allow(helper).to receive(:link_to).and_wrap_original do |_, title, url|
      %Q{<a href="#{url}">#{title}</a>}
    end
  end

  after do
    # Remove our testing class
    Object.send :remove_const, :HelperTester
  end

  describe "#toc_for" do
    before(:each) do
      building_page = double(path: "custom-extensions/building-custom-extensions.html")
      allow(helper).to receive(:request).and_return(building_page)
      allow(File).to receive(:exist?).and_return(true)
    end

    it "raises an exception if a file doesn't exist" do
      allow(File).to receive(:exist?).and_return(false)
      expect { toc }.to raise_error(RuntimeError,
        "source/middleman-basics/index.md does not exist. Please fix guides.yml.")
    end

    it "includes guide titles" do
      expect(toc).to include("What even is middleman?")
    end

    it "does not includes guide titles that are marked to skip sidebar" do
      expect(toc).not_to include("Secret stuff")
    end

    it "does not includes chapter titles that are marked to skip sidebar" do
      expect(toc).not_to include("Nobody really cares about this")
    end

    it "includes guide urls" do
      expect(toc).to include("middleman-basics")
    end

    it "does not include guide urls for guides that are marked to skip sidebar" do
      expect(toc).not_to include("secret")
    end

    it "includes chapter urls except for chapter that are marked to skip sidbar" do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Advanced Concepts"
        url: "index"
      - title: "Middleman Architecture"
        url: "middleman-architecture"
        skip_sidebar_item: true
      - title: "Contributing to Middleman"
        url: "contributing-to-middleman"
      }

      data = Hashie::Mash.new(YAML.load(data_yml))
      toc = helper.toc_for(data.guides)
      advanced_index_page = double(path: "advanced-middleman/index.html")
      allow(helper).to receive(:request).and_return(advanced_index_page)

      expect(toc).to include(advanced_index_page.path)
      expect(toc).to include("contributing-to-middleman")

      expect(toc).not_to include("middleman-architecture")
    end

    it "contains a link to first chapter as a guide link even if it is marked with :skip_sidebar_item" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
        skip_sidebar_item: true
      }

      data = Hashie::Mash.new(YAML.load(data_yml))
      toc = helper.toc_for(data.guides)
      expectation = %Q{<li class='level-1 '><a href=\"/extending-middleman/index.html\">Extending Middleman</a>}
      expect(toc).to include(expectation)
    end
  end

  describe "#page_title" do
    before(:each) do
      allow(helper).to receive(:current_page).and_return(basics_page)
    end

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
    before(:each) do
      allow(helper).to receive(:current_page).and_return(basics_page)
    end

    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_guide).and_return(nil)

      expect(helper.guide_name).to be_nil
    end

    it "is the current guide's title when current guide is specified" do
      expect(helper.guide_name).to eq(basic_guide_title)
    end
  end

  describe "#chapter_name" do
    before(:each) do
      allow(helper).to receive(:current_page).and_return(basics_page)
    end

    it "is an empty string when current chapter is not specified" do
      allow(helper).to receive(:current_chapter).and_return(nil)

      expect(helper.chapter_name).to eq("")
    end

    it "is current chapter's title when current chapter is specified" do
      expect(helper.chapter_name).to eq(basic_chapter_title)
    end
  end

  describe "#chapter_heading" do
    before(:each) do
      allow(helper).to receive(:current_page).and_return(basics_page)
    end

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
      expect(helper.chapter_github_source_url).to eq("https://github.com/emberjs/guides/edit/master/source/custom-extensions/testing-custom-extensions.md")
    end
  end

  describe "#current_guide" do
    before(:each) do
      allow(helper).to receive(:current_page).and_return(basics_page)
    end

    it "is the current value if present" do
      helper.instance_variable_set(:@current_guide, "some random value")
      expect(helper.current_guide).to eq("some random value")
    end

    it "sets the guide associated with the current page as current guide & returns it" do
      guide = helper.data.guides.first

      expect(helper.instance_variable_get(:@current_guide)).to be_nil
      expect(helper.current_guide).to eq(guide)
      expect(helper.instance_variable_get(:@current_guide)).to eq(guide)
    end
  end

  describe "#current_guide_index" do
    before(:each) do
      data_yml = %Q{
guides:
  - title: "Middleman Basics"
    url: "middleman-basics"
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Advanced Concepts"
        url: "index"
    }
      data = Hashie::Mash.new(YAML.load(data_yml))

      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(basics_page)
    end

    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.current_guide_index).to be_nil
    end

    it "is the index of the current guide when specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/index.html"))

      expect(helper.current_guide_index).to eq(1)
    end
  end

  describe "#current_chapter" do
    before(:each) do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Advanced Concepts"
        url: "index"
      - title: "Middleman Architecture"
        url: "middleman-architecture"
      }
      @data = Hashie::Mash.new(YAML.load(data_yml))
    end

    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.current_chapter).to be_nil
    end

    it "is the current value if present" do
      allow(helper).to receive(:data).and_return(@data)
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/middleman-architecture.html"))
      architecture_chapter = helper.data.guides.first.chapters.last

      helper.instance_variable_set(:@current_chapter, architecture_chapter)

      expect(helper.current_chapter).to eq(architecture_chapter)
    end

    it "sets the chapter associated with the current page as current chapter & returns it" do
      allow(helper).to receive(:data).and_return(@data)
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/middleman-architecture.html"))
      architecture_chapter = helper.data.guides.first.chapters.last

      expect(helper.instance_variable_get(:@current_chapter)).to be_nil
      expect(helper.current_chapter).to eq(architecture_chapter)
      expect(helper.instance_variable_get(:@current_chapter)).to eq(architecture_chapter)
    end
  end

  describe "#current_chapter_index" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.current_chapter_index).to be_nil
    end

    it "is nil if the current chapter is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.current_chapter_index).to be_nil
    end

    it "is the index of the current chapter in the current guide if both are specified" do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Advanced Concepts"
        url: "index"
      - title: "Middleman Architecture"
        url: "middleman-architecture"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/middleman-architecture.html"))

      expect(helper.current_chapter_index).to eq(1)
    end
  end

  describe "#chapter_links" do
    it "is markup that consists of previous & next chapter links" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
        skip_sidebar_item: true
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      - title: "Testing Middleman Extensions"
        url: "testing-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/building-middleman-extensions"))

      expect(helper.chapter_links).to include("What are extensions?")
      expect(helper.chapter_links).to include("Testing Middleman Extensions")
    end
  end

  describe "#previous_chapter_link" do
    it "is link to previous chapter in current guide if previous chapter is specified" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/building-middleman-extensions"))

      expect(helper.previous_chapter_link).to include("What are extensions?")
      expect(helper.previous_chapter_link).to include("index")
    end

    it "is link to last chapter in previous guide if current chapter is first chapter in previous guide" do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Middleman Architecture"
        url: "middleman-architecture"
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/building-middleman-extensions"))

      expect(helper.previous_chapter_link).to include("Middleman Architecture")
    end
  end

  describe "#next_chapter_link" do
    it "is link to next chapter in current guide if next chapter is specified" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/index"))

      expect(helper.next_chapter_link).to include("Building Middleman Extensions")
    end

    it "is link to the first chapter in next guide if next chapter is not specified" do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Middleman Architecture"
        url: "middleman-architecture"
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/middleman-architecture"))

      expectation = "We're done with Advanced Middleman. Next up: Extending Middleman - Building Middleman Extensions"
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
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Middleman Architecture"
        url: "middleman-architecture"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/middleman-architecture"))

      expect(helper.previous_chapter).to be_nil
    end

    it "is the previous chapter when current guide & current chapter are specified & there is a chapter before that" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/building-middleman-extensions"))
      extensions_chapter = helper.data.guides.first.chapters.first

      expect(helper.previous_chapter).to eq(extensions_chapter)
    end
  end

  describe "#next_chapter" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.next_chapter).to be_nil
    end

    it "is nil if current chapter index is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.next_chapter).to be_nil
    end

    it "is nil if current chapter is the last chapter in the guide" do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Middleman Architecture"
        url: "middleman-architecture"
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/middleman-architecture"))

      expect(helper.next_chapter).to be_nil
    end

    it "is the next chapter when current guide has a next chapter" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/index"))
      building_chapter = helper.data.guides.first.chapters.last

      expect(helper.next_chapter).to eq(building_chapter)
    end
  end

  describe "#previous_guide" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.previous_guide).to be_nil
    end

    it "is nil if current guide index is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.previous_guide).to be_nil
    end

    it "is nil if current guide is the first guide" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/index"))

      expect(helper.previous_guide).to be_nil
    end

    it "is the previous guide when current guide is specified & there is a guide before that" do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Middleman Architecture"
        url: "middleman-architecture"
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/building-middleman-extensions"))
      first_guide = helper.data.guides.first

      expect(helper.previous_guide).to eq(first_guide)
    end
  end

  describe "#next_guide" do
    it "is nil if current guide is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.next_guide).to be_nil
    end

    it "is nil if current guide index is not specified" do
      allow(helper).to receive(:current_page).and_return(double(path: "some/nonexistent/path.html"))

      expect(helper.next_guide).to be_nil
    end

    it "is nil if current guide is the last guide" do
      data_yml = %Q{
guides:
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "What are extensions?"
        url: "index"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "extending-middleman/index"))

      expect(helper.next_guide).to be_nil
    end

    it "is the next guide when current guide is specified & next guide exists" do
      data_yml = %Q{
guides:
  - title: "Advanced Middleman"
    url: "advanced-middleman"
    chapters:
      - title: "Middleman Architecture"
        url: "middleman-architecture"
  - title: "Extending Middleman"
    url: "extending-middleman"
    chapters:
      - title: "Building Middleman Extensions"
        url: "building-middleman-extensions"
      }
      data = Hashie::Mash.new(YAML.load(data_yml))
      allow(helper).to receive(:data).and_return(data)
      allow(helper).to receive(:current_page).and_return(double(path: "advanced-middleman/middleman-architecture"))
      next_guide = helper.data.guides.last
      expect(helper.next_guide).to eq(next_guide)
    end
  end

end
