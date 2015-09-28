require 'spec_helper'
require 'jshint'
describe "JS Snippets" do
  before(:all) do
    @linter = Jshint::Lint.new('.jshintrc')
  end

  it 'should have no errors or warnings' do
    key = 'snippet_1'
    js_snippet = <<-snippet
      var test;
    snippet

    @linter.lint(key, js_snippet)
    expect(@linter.errors[key]).to eq []
  end
end
