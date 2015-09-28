require 'spec_helper'
require 'jshint'
require 'jshint/reporters'

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
    error_count = @linter.errors.map{|k,v| v.count}.inject(0, :+)

    if error_count > 0
      reporter = Jshint::Reporters::Default.new(@linter.errors)
      puts "\n\n#{reporter.report}\n\n"
    end

    expect(error_count).to eq 0
  end
end
