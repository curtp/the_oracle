require 'discordrb'
require 'dotenv/load'
require "active_record"
require 'easy_logging'
require_relative './oracle/command_processors/oracle_command_processor'
require_relative "./oracle/models/command_factory"
require_relative "./oracle/models/server"
require_relative "./oracle/database/migration"

# Global pre-configuration for every Logger instance
EasyLogging.log_destination = 'logs/the_oracle.log'
EasyLogging.level = Logger::DEBUG

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'data/server_lists.db')
Oracle::Database::Migration.migrate(:up)

# String tokenizer for parsing the commands
class String
  def tokenize
    self.
      split(/\s(?=(?:[^'"]|'[^']*'|"[^"]*")*$)/).
      select {|s| not s.empty? }.
      map {|s| s.gsub(/(^ +)|( +$)|(^["']+)|(["']+$)/,'')}
  end
end

# Move the token into ENV files
bot = Discordrb::Commands::CommandBot.new(token: ENV["BOT_TOKEN"], prefix: "!")

# Create the command for the bot and process the events
bot.command(:oracle, aliases: [:o], description: "Master command for communicating with the Oracle") do |event|
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
