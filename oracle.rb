require 'dynamoid'
require 'discordrb'
require 'dotenv/load'
require 'easy_logging'

# Global pre-configuration for every Logger instance
EasyLogging.log_destination = 'logs/the_oracle.log'
EasyLogging.level = Logger::DEBUG

# Configure DB access - This needs to be moved into a configuration file somewhere
Dynamoid.configure do |config|
  config.namespace = ENV["DB_NAMESPACE"]
  config.endpoint = ENV["DB_ENDPOINT"]
end
Dynamoid.config.logger.level = :debug

# This is here to wipe out the DB tables when major changes are needed. this
# is only used during development. Once the DB schema settles down, this clan
# be removed or moved into a utils folder
if false == true
  Dynamoid.adapter.list_tables.each do |table|
    # Only delete tables in our namespace
    if table =~ /^#{Dynamoid::Config.namespace}/
      Dynamoid.adapter.delete_table(table)
    end
  end
  Dynamoid.adapter.tables.clear
  # Recreate all tables to avoid unexpected errors
  Dynamoid.included_models.each { |m| m.create_table(sync: true) }
end

# String tokenizer for parsing the commands
class String
  def tokenize
    self.
      split(/\s(?=(?:[^'"]|'[^']*'|"[^"]*")*$)/).
      select {|s| not s.empty? }.
      map {|s| s.gsub(/(^ +)|( +$)|(^["']+)|(["']+$)/,'')}
  end
end

require_relative './oracle/command_processors/oracle_command_processor'
require_relative "./oracle/models/command_factory"
require_relative "./oracle/models/server"

# Move the token into ENV files
bot = Discordrb::Commands::CommandBot.new(token: ENV["BOT_TOKEN"], prefix: "!")

# Create the command for the bot and process the events
bot.command(:oracle, description: "Master command for communicating with the Oracle") do |event|
  Oracle::CommandProcessors::OracleCommandProcessor.execute(Oracle::Models::CommandFactory.create_command_for_event(event))
end

# This runs when the bot is added to a server.
bot.server_create do |event|
  Oracle::Models::Server.bot_joined_server(event)
end

# This runs when the bot is removed from a server.
bot.server_delete do |event|
  Oracle::Models::Server.bot_left_server(event)
end

# Startup the bot
bot.run
