require 'logger'

class OracleLogger

  def self.log_destination=(destination)
    @destination = destination
  end

  def self.log_level=(log_level)
    @log_level = log_level
  end

  def self.log
    if @logger.nil?
      if @destination.nil?
        @destination = STDOUT
      end

      if @log_level.nil?
        @log_level = Logger::DEBUG
      end

      @logger = Logger.new @destination
      @logger.level = @log_level
    end
    @logger
  end
end
