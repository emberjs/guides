require "spec_helper"

require_relative "./spelling_exceptions"

describe "Spell checker exceptions" do
  it "ensures each spelling exception is used at least once" do
    unused_exceptions = SpellingExceptions.new.find_unused_exceptions
    expect(unused_exceptions).to be_empty
  end
end
