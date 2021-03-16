# frozen_string_literal: true

require 'irb'
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

IRB.start