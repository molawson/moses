require 'moses'

module Moses
  class CLI

    def self.run
      config = Moses::Config.new('config/database.yml')

      source = Moses::Database.new(config.source_url)
      dest = Moses::Database.new(config.dest_url)

      progress = nil

      source.transfer_to(dest) do |type, data|
        case type
        when :tables
          puts "Transferring #{data} tables:"
        when :table
          progress = Moses::ProgressBar.new(data.first, data.last, $stdout)
        when :row
          progress.inc(data)
        when :end
          progress.finish
        end
      end
    rescue Interrupt
      puts
      puts "ERROR: Transfer aborted by user"
    end
  end
end
