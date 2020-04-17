require_relative 'yaml_searcher/version'
require_relative 'searcher'
require_relative 'report'
require 'logger'

module YamlSearcher
  class << self
    attr_accessor :logger
  
    def start(path:, search_pattern:)
      start = Time.now
      results = Searcher.new(path: path, pattern: search_pattern).search
      Report.build(results)
      finish = Time.now
      self.logger.info("Done. Took: #{finish - start}")
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.name
      end
    end
  end
end
