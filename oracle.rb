require 'dynamoid'
require 'discordrb'
require 'dotenv/load'

# Configure DB access - This needs to be moved into a configuration file somewhere
Dynamoid.configure do |config|
  # config.namespace = "dynamoid_development"
  config.namespace = ENV["DB_NAMESPACE"]
#  config.endpoint = "http://dynamodb-local:8000"
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

# Move the token into ENV files
# bot = Discordrb::Commands::CommandBot.new(token: "NzkzMTU1ODQ5NzczNzc2OTA4.X-oJ8g.WFQe0Bi3IbNd9jdpqfPQmOWKKrg", prefix: "!")
bot = Discordrb::Commands::CommandBot.new(token: ENV["BOT_TOKEN"], prefix: "!")

# Invite URL
# https://discord.com/api/oauth2/authorize?client_id=793155849773776908&permissions=3072&scope=bot

# Create the command for the bot and process the events
bot.command(:oracle, description: "Master command for communicating with the Oracle") do |event|
  Oracle::CommandProcessors::OracleCommandProcessor.execute(Oracle::Models::CommandFactory.create_command_for_event(event))
end

# Startup the bot
bot.run
