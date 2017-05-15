def check_words
  Dir['../source/**/*'].select{|f| File.file?(f) }.each do |filepath|
    spelling_exceptions_file = File.open('../data/spelling-exceptions.txt')
    spelling_exceptions_file.each do |word| 
      if File.foreach(filepath).detect { |line| line.include?(word) } 
        puts "TRUE, #{word} is in #{filepath}."
      else 
        puts "FALSE, #{word} is NOT in path #{filepath}."
      end
    end 
  end
end 

check_words



