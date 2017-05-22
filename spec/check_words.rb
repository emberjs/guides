require 'pathname'

def check_words
  spelling_exceptions_file = File.open('../data/spelling-exceptions.txt')
  spelling_exceptions_file.each do |word|
    Dir[File.expand_path('../source/**/*', __dir__)].select{|f| File.file?(f) }.each do |filepath|
      if File.foreach(filepath).detect { |line| line.include?(word.strip) } 
        puts "TRUE, #{word.strip} is in #{filepath}."
        break
      else 
        puts "FALSE, #{word.strip} is NOT in path #{filepath}."
      end
    end 
  end 
end 


check_words