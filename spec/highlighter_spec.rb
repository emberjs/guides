require 'middleman'
require 'highlighter'
describe Highlighter::Helpers do
  before do
    class HelperTester
      include Highlighter::Helpers
    end
  end

  after do
    # Remove our testing class
    Object.send :remove_const, :HelperTester
  end

  describe '#_detect_language_filename_and_changes' do
    it 'returns bare languages and does not return a filename' do
      language, filename, changes = HelperTester.new._detect_language_filename_and_changes('javascript')
      expect(language).to eq 'javascript'
      expect(filename).to be_nil
      expect(changes).to eq []

      language, filename, changes = HelperTester.new._detect_language_filename_and_changes('handlebars')
      expect(language).to eq 'handlebars'
      expect(filename).to be_nil
      expect(changes).to eq []
    end

    it 'returns the detected language and the filename from a filename' do
      language, filename, changes = HelperTester.new._detect_language_filename_and_changes('app/components/my-component.js')
      expect(language).to eq 'javascript'
      expect(filename).to eq 'app/components/my-component.js'
      expect(changes).to eq []

      language, filename, changes = HelperTester.new._detect_language_filename_and_changes('app/templates/application.hbs')
      expect(language).to eq 'handlebars'
      expect(filename).to eq 'app/templates/application.hbs'
      expect(changes).to eq []

      language, filename, changes = HelperTester.new._detect_language_filename_and_changes('app/index.html')
      expect(language).to eq 'html'
      expect(filename).to eq 'app/index.html'
      expect(changes).to eq []

      language, filename, changes = HelperTester.new._detect_language_filename_and_changes('app/styles/app.css')
      expect(language).to eq 'css'
      expect(filename).to eq 'app/styles/app.css'
      expect(changes).to eq []

      language, filename, changes = HelperTester.new._detect_language_filename_and_changes('bower.json')
      expect(language).to eq 'json'
      expect(filename).to eq 'bower.json'
      expect(changes).to eq []
    end

    it 'returns detected code changes' do
      _, _, changes = HelperTester.new._detect_language_filename_and_changes('app/components/my-component.js{1,+3,4,-5,+6,-7}')

      expect(changes).to eq [
        [1, nil],
        [3, 'added'],
        [4, nil],
        [5, 'removed'],
        [6, 'added'],
        [7, 'removed'],
      ]

      _, _, changes = HelperTester.new._detect_language_filename_and_changes('javascript{+2,3,-5}')

      expect(changes).to eq [
        [2, 'added'],
        [3, nil],
        [5, 'removed']
      ]
    end
  end

  describe '#_highlight' do
    it 'raises appropriate error in case language is nil' do
      code = 'var blah = Ember.Object.create()'

      expect {
        HelperTester.new._highlight(code, nil)
      }.to raise_error(Highlighter::MissingLanguageError)
    end

    it 'returns a code block without a filename in the table when using a bare language fence' do
      code_block = HelperTester.new._highlight('var blah = Ember.Object.create()', 'javascript')
      expect(code_block).to eq <<-OUTPUT.sub(/\n$/, '')
<div class="highlight javascript "><div class="ribbon"></div><div class="scroller"><table class="CodeRay"><tr>
  <td class="line-numbers"><pre>1
</pre></td>
  <td class="code"><pre><span class="keyword">var</span> blah = Ember.Object.create()</pre></td>
</tr></table>
</div></div>
OUTPUT
    end

    it 'returns a code block with a filename in the table when using a filename fence' do
      code_block = HelperTester.new._highlight('export default Ember.Component.extend()', 'app/components/my-foo.js')
      expect(code_block).to eq <<-OUTPUT.sub(/\n$/, '')
<div class="highlight javascript "><div class="ribbon"></div><div class="scroller"><table class="CodeRay">
  <thead>
    <tr>
      <td colspan="2">app/components/my-foo.js</td>
    </tr>
  </thead>
<tr>
  <td class="line-numbers"><pre>1
</pre></td>
  <td class="code"><pre><span class="reserved">export</span> <span class="keyword">default</span> Ember.Component.extend()</pre></td>
</tr></table>
</div></div>
OUTPUT
    end

    it 'returns a code block with a filename in the table when using a filename fence with highlighting' do
      code_block = HelperTester.new._highlight("export default Ember.Component.extend()\nvar added;\nvar removed;",
                                               'app/components/my-foo.js{1,+2,-3}')
      expect(code_block).to eq <<-OUTPUT.sub(/\n$/, '')
<div class="highlight javascript "><div class="ribbon"></div><div class="scroller"><?xml version="1.0"?>
<table class="CodeRay">
  <thead>
    <tr>
      <td colspan="2">app/components/my-foo.js</td>
    </tr>
  </thead>
<tr>
  <td class="line-numbers"><pre><span class="highlight-line ">1</span>
<span class="highlight-line added">2</span>
<span class="highlight-line removed">3</span></pre></td>
  <td class="code"><pre><span class="highlight-line "><span class="reserved">export</span> <span class="keyword">default</span> Ember.Component.extend()</span>
<span class="highlight-line added"><span class="keyword">var</span> added;</span>
<span class="highlight-line removed"><span class="keyword">var</span> removed;</span></pre></td>
</tr></table>
</div></div>
OUTPUT
    end

    it 'returns a code block with a filename in the table when using a filename fence with highlighting' do
      code_block = HelperTester.new._highlight("export default Ember.Component.extend()\nvar added;\nvar removed;",
                                               'javascript{1,+2,-3}')
      expect(code_block).to eq <<-OUTPUT.sub(/\n$/, '')
<div class="highlight javascript "><div class="ribbon"></div><div class="scroller"><?xml version="1.0"?>
<table class="CodeRay">
  <tr>
  <td class="line-numbers"><pre><span class="highlight-line ">1</span>
<span class="highlight-line added">2</span>
<span class="highlight-line removed">3</span></pre></td>
  <td class="code"><pre><span class="highlight-line "><span class="reserved">export</span> <span class="keyword">default</span> Ember.Component.extend()</span>
<span class="highlight-line added"><span class="keyword">var</span> added;</span>
<span class="highlight-line removed"><span class="keyword">var</span> removed;</span></pre></td>
</tr>
</table>
</div></div>
OUTPUT
    end
  end
end
