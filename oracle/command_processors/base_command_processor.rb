require_relative "../validators/command_validator"
module Oracle
  module CommandProcessors
    class BaseCommandProcessor

      attr_accessor :command

      def initialize(command)
        self.command = command
      end

      def print_list(list)
        command.event << "List: #{list.name}"
        command.event << "====================="
        list.entries.each do |entry|
          command.event << entry
        end
      end

      protected

      def validate_command
        Oracle::Validators::CommandValidator.validate(command)
      end

      def find_list
        begin
          Oracle::Models::List.where(["server_id == ? and name collate nocase == ?",
            command.event.server.id, command.list_name.strip]).first
        rescue Exception => e
          OracleLogger.log.error("BaseCommandProcessor: Issue loading list: #{e}")
          OracleLogger.log.error(e.backtrace.join("\n"))
        end
      end

      def new_list
        begin
          Oracle::Models::List.new(server_id: command.event.server.id,
            name: command.list_name.strip)
        rescue Exception => e
          OracleLogger.log.error("BaseCommandProcessor: Issue Creating list: #{e}")
          OracleLogger.log.error(e.backtrace.join("\n"))
        end
      end

      def server_lists
        begin
          Oracle::Models::List.where(server_id: command.event.server.id).order(:name).all
        rescue Exception => e
          OracleLogger.log.error("BaseCommandProcessor: Issue loading sever lists: #{e}")
          OracleLogger.log.error(e.backtrace.join("\n"))
        end
      end
    end
  end
end
