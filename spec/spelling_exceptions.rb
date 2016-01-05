require_relative "./source_file_finder"

class SpellingExceptions
  def self.words
    @words ||=
      Set.new(IO.readlines('data/spelling-exceptions.txt').map(&:chomp))
  end

  def initialize
    @found_words = Set.new
  end

  def find_unused_exceptions
    SourceFileFinder.all_text_files.each do |source_file|
      contents = IO.read(source_file)
      words_not_found.each do |not_found_word|
        if contents.downcase.include?(not_found_word.downcase)
          @found_words.add(not_found_word)
        end

        # if we have found all the words, break early
        break if words_not_found.empty?
      end
    end

    words_not_found
  end

  private

  def words_not_found
    self.class.words - @found_words
  end
end
