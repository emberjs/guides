require 'pathname'

# def check_words
#   spelling_exceptions_file = File.open('../data/spelling-exceptions.txt')
#   spelling_exceptions_file.each do |word|
#     Dir[File.expand_path('../source/**/*', __dir__)].select{|f| File.file?(f) }.each do |filepath|
#       if File.foreach(filepath).detect { |line| line.include?(word.strip) } 
#         puts "TRUE, #{word.strip} is in #{filepath}."
#         break
#       else 
#         puts "FALSE, #{word.strip} is NOT in path #{filepath}."
#       end
#     end 
#   end 
# end 


# check_words

def check_words
  spelling_exceptions_file = File.open('../data/spelling-exceptions.txt')
  original_array_of_words = File.readlines(spelling_exceptions_file)
  words_that_are_present_in_source_folder_array = []
  spelling_exceptions_file.each do |word|
    Dir[File.expand_path('../source/**/*', __dir__)].select{|f| File.file?(f) }.each do |filepath|
      if File.foreach(filepath).detect { |line| line.include?(word.strip) } 
        puts "TRUE, #{word.strip} is in #{filepath}."
        words_that_are_present_in_source_folder_array << word 
        break
      end
    end 
  end 
  not_present_in_source_folder_array = (original_array_of_words - words_that_are_present_in_source_folder_array).sort
  not_present_in_source_folder_array.each do |word| 
    puts "FALSE #{word.strip} is NOT in any of the files."
  end
end 

check_words