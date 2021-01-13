require_relative './list'
require_relative '../database/seeder'

module Oracle
  module Models
    class Server < ActiveRecord::Base
      has_many :lists, primary_key: :server_id

      # Renumbers all lists for the server
      def renumber_lists
        lists.order("upper(name) asc").each_with_index do |list, ndx|
          list.update(number: ndx+1)
        end
      end

      def self.bot_joined_server(event)
        OracleLogger.log.info("Server: bot just joined server: '#{event.server.name}' (ID: #{event.server.id}), owned by '#{event.server.owner.distinct}' the server count is now #{event.bot.servers.count}")
        # Look for an existing server with the ID of the server in the event.
        # If not there, create a new server record. If it is there, simply
        # wipe out the removed_on and removed_by_user columns so they aren't
        # populated anymore
        server = Server.where(server_id: event.server.id).first
        if server.present?
          OracleLogger.log.info("Server: bot re-joined server, clearing removed columns.")
          server.update(removed_on: nil)
        else
          OracleLogger.log.info("Server: bot joined a new server, creating server record")
          server = Server.create(server_id: event.server.id, server_name: event.server.name,
            added_by_user: event.server.owner.distinct)
          OracleLogger.log.debug {"Server: Seeding lists for the server."}
          seeder = Oracle::Database::Seeder.new
          seeder.seed(event.server.id)
        end
        OracleLogger.log.debug {"Server: server: #{server.inspect}"}
      end

      def self.bot_left_server(event)
        OracleLogger.log.info("Server: bot just left server: #{event.server}, the server count is now #{event.bot.servers.count}")
        server = Server.where(server_id: event.server).first
        if server.present?
          OracleLogger.log.info("Server: stamping server as removed")
          server.update(removed_on: Time.now.utc)
        end
        OracleLogger.log.debug {"Server: server: #{server.inspect}"}
      end
    end
  end
end
