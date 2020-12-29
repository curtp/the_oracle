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
        result = Oracle::Validators::CommandValidator.validate(command)
      end

      def find_list
        begin
          Oracle::Models::List.where(server_id: command.event.server.id, name: command.list_name).first
        rescue Aws::DynamoDB::Errors::ResourceNotFoundException => e
        end
      end

      def new_list
        Oracle::Models::List.new(server_id: command.event.server.id, name: command.list_name)
      end

      def server_lists
        begin
          Oracle::Models::List.where(server_id: command.event.server.id).all
        rescue Aws::DynamoDB::Errors::ResourceNotFoundException => e
        end
      end
    end
  end
end
