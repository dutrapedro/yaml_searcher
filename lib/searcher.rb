require 'rake'
require 'byebug'

class Searcher
  attr_accessor :file_path, :pattern

  def initialize(path:, pattern:)
    @file_path = path
    @pattern = pattern
  end

  def search
    paths = FileList.new(file_path)
    YamlSearcher.logger.info("Searching #{paths.size} files...")
  
    paths.map do |path|
      lines_matching_pattern(path).map do |line|
        { key: complete_key(line), line_number: line[:line_number], value: line[:content].strip }
      end
    end
  end

  def lines_matching_pattern(path)
    File.open(path, 'r') do |file|
      file.map { |f| { content: f, line_number: $. } if f.match?(pattern) }.compact
    end
  end

  def complete_key(line)
    file_content = File.readlines(file_path)[1..line[:line_number]-1].reverse
    key = []
    (line[:content][/^\s+/].size .. 0).step(-2).each { |size| key << file_content.find { |l| (l[/^\s+/]&.size || 0) == size } }

    key.map{ |k| line_key(k).strip }.reverse.join('.')
  end

  def line_key(line)
    line[/^[^:]+/]
  end

  def line_content(line)
    line[/\:(.*)/]
  end
end