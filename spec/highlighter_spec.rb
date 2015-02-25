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

  describe '#_detect_language_and_filename' do
    it 'returns bare languages and does not return a filename' do
      language, filename = HelperTester.new._detect_language_and_filename('javascript')
      expect(language).to eq 'javascript'
      expect(filename).to be_nil

      language, filename = HelperTester.new._detect_language_and_filename('handlebars')
      expect(language).to eq 'handlebars'
      expect(filename).to be_nil
    end

    it 'returns the detected language and the filename from a filename' do
      language, filename = HelperTester.new._detect_language_and_filename('app/components/my-component.js')
      expect(language).to eq 'javascript'
      expect(filename).to eq 'app/components/my-component.js'

      language, filename = HelperTester.new._detect_language_and_filename('app/templates/application.hbs')
      expect(language).to eq 'handlebars'
      expect(filename).to eq 'app/templates/application.hbs'

      language, filename = HelperTester.new._detect_language_and_filename('app/index.html')
      expect(language).to eq 'html'
      expect(filename).to eq 'app/index.html'

      language, filename = HelperTester.new._detect_language_and_filename('app/styles/app.css')
      expect(language).to eq 'css'
      expect(filename).to eq 'app/styles/app.css'

      language, filename = HelperTester.new._detect_language_and_filename('bower.json')
      expect(language).to eq 'json'
      expect(filename).to eq 'bower.json'
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
  end
end
