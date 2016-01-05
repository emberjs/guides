class SourceFileFinder
  ALLOWED_FILE_EXTENSIONS = [".md"]

  attr_reader :files

  def self.all_text_files
    new.find_in_directory("./source").files
  end

  def initialize
    @files = []
  end

  def find_in_directory(dir)
    Dir["#{dir}/*"].each do |file|
      if File.directory?(file)
        find_in_directory(file)
      elsif ALLOWED_FILE_EXTENSIONS.include?(File.extname(file))
        @files.push(file)
      end
    end

    self
  end
end
