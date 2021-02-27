# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'
require "active_record"
require "yaml"

# Load up classes which have early dependencies first
require_relative './oracle/command_processors/base_command_processor'
require_relative './oracle/models/base_command'
require_relative './oracle/models/base_list_management_command'

# Load non-Discordrb modules
Dir["#{File.dirname(__FILE__)}/oracle/**/*.rb"].each { |f| load(f) }

# Setup the logger
OracleLogger.log_level = Logger::DEBUG
OracleLogger.log_destination = Oracle.config[:log_file]

# Connect to the database and run any pending migrations
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: Oracle.config[:database_file])
Oracle::Database::Migration.migrate(:up)

# Establish the bot and connect
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

# When the bot is ready, set the status so people know how to interact with it
bot.ready do |event|
  OracleLogger.log.debug {"Ready event"} 
  bot.update_status("online", "!oracle", nil, since = 0, afk = false, activity_type = 2)
end

# Startup the bot
bot.run
