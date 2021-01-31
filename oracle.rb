require 'discordrb'
require 'dotenv/load'
require "active_record"
require "yaml"
require_relative './oracle/lib/oracle_logger'
require_relative './oracle/lib/string'
require_relative './oracle/command_processors/oracle_command_processor'
require_relative "./oracle/models/command_factory"
require_relative "./oracle/models/server"
require_relative "./oracle/database/migration"
require_relative "./oracle/lib/config"

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

#@nicks = {}
#bot.command(:nick, description: "Register a nickname for a channel") do |event|
#  instructions = event.message.content.tokenize.drop(1)
#
#  key = "#{event.user.id}|#{event.channel.id}"
#  @nicks[key] = {nick: instructions[0], channel: event.channel.id}
#
#  OracleLogger.log.info("nicknames: #{@nicks.inspect}")
#end

# This runs when the bot is added to a server.
bot.server_create do |event|
  Oracle::Models::Server.bot_joined_server(event)
end

# This runs when the bot is removed from a server.
bot.server_delete do |event|
  Oracle::Models::Server.bot_left_server(event)
end

#bot.typing do |event|
#  bot_profile = event.bot.profile.on(event.channel.server)
#  if bot_profile.permission?(:manage_nicknames, event.channel)
#    OracleLogger.log.info("have permissions, setting nickname")
#    key = "#{event.user.id}|#{event.channel.id}"
#    OracleLogger.log.info("looking up nick with key: #{key}")
#    OracleLogger.log.info("Nicks: #{@nicks}")
#    users_nick = @nicks[key]
#    OracleLogger.log.info("users nick: #{users_nick}")
#    if !users_nick.blank?
#      OracleLogger.log.info("found nick: #{users_nick}")
#      event.member.set_nick(users_nick[:nick])
#    end
#  else
#    OracleLogger.log.info("no permissions")
#  end
#end

# Startup the bot
bot.run
