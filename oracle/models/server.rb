require_relative "./list"

module Oracle
  module Models
    class Server
      include EasyLogging

      def self.bot_joined_server(event)
        logger.info("bot just joined server: `#{event.server.name}` (ID: #{event.server.id}), owned by `#{event.server.owner.distinct}` the server count is now #{event.bot.servers.count}")
      end

      def self.bot_left_server(event)
        # Oracle::Models::List.remove_all_lists_for_server(event.server)
        logger.info("bot just left server: #{event.server}, the server count is now #{event.bot.servers.count}")
      end
    end
  end
end
