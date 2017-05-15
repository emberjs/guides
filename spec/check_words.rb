def check_words
  arr = File.readlines('data/spelling-exceptions.txt')
  arr.select { |e| e.strip! }

  Dir['source/**/*'].select{|f| File.file?(f) }.each do |filepath|
    arr.each do |word| 
      if File.foreach(filepath).detect { |line| line.include?(word) } 
        puts "TRUE, #{word} is in #{filepath}."
      else 
        puts "FALSE, #{word} is NOT in path #{filepath}."
      end
    end 
  end 
end 

check_words()