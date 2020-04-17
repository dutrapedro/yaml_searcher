require 'csv'
require 'fileutils'

module Report
  class << self
    def build(results)
      YamlSearcher.logger.info("Creating report for #{results.size} file...")
      results.each_with_index do |result, index|
        CSV.open("#{ENV['HOME']}/Documents/yaml_searcher_report_#{index}_#{Time.now.utc.to_i}.csv", 'wb', col_sep: ';') do |csv|
          csv << %w[key line_number value]
          result.each { |line| csv << [ line[:key], line[:line_number], line[:value] ] }
        end
      end
    end

    private

    def create_file(path)
      FileUtils.touch(path)
    end
  end
end