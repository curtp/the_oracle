require_relative "./base_command_processor"
require_relative "../models/list"

module Oracle
  module CommandProcessors
    class RemoveCommandProcessor < BaseCommandProcessor
      include EasyLogging

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        logger.debug {"process: validation result: #{validation_result}"}
        if validation_result[:valid]
          list = find_list
          if !list.present?
            result[:success] = false
            result[:error_message] = "List not found"
            return result
          end

          if command.instructions.size == 2
            remove_entire_list(list)
            command.event << "Removed list #{list.name} from the Oracle"
          elsif command.instructions.size == 4
            remove_entry_from_list(list)
            command.event << "Removed #{command.entry} from the list #{command.list_name}"
            print_list(list)
          end

        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        logger.debug {"process: returning result: #{result}"}
        return result
      end

      private

      def remove_entire_list(list)
        Oracle::Models::List.where(id: list.id).destroy_all
      end

      def remove_entry_from_list(list)
        list.remove_entry(command.entry)
        list.save
      end

    end
  end
end
