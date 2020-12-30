require_relative "./list"

module Oracle
  module Models
    class Server

      def self.bot_joined_server(event)
        OracleLogger.log.info("Server: bot just joined server: '#{event.server.name}' (ID: #{event.server.id}), owned by '#{event.server.owner.distinct}' the server count is now #{event.bot.servers.count}")
      end

      def self.bot_left_server(event)
        OracleLogger.log.info("Server: bot just left server: #{event.server}, the server count is now #{event.bot.servers.count}")
      end
    end
  end
end
