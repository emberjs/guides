documentation_files = Dir.glob('./source/**/*.md')
spelling_exceptions = File.read("./data/spelling-exceptions.txt").split("\n")

corpus = documentation_files.reduce { |c, f| c << File.read(f) }.downcase

describe "Spelling Exceptions" do

  it "should only include words actually found in the guides" do
    spelling_exceptions.each do |word|
      expect(corpus.scan(word.downcase)).not_to be_empty,
      %Q{
         "#{word}" was included in the list of spelling exceptions, but was not found in the guides.
      }.strip
    end
  end

end
