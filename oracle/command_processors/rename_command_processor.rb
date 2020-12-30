require_relative "./base_command_processor"
require_relative "../models/list"

module Oracle
  module CommandProcessors
    class RenameCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        OracleLogger.log.debug { "RemoveCommandProcessor.process: validation result: #{validation_result}" }
        if validation_result[:valid]
          list = find_list
          if !list.present?
            result[:success] = false
            result[:error_message] = "List not found"
            return result
          end

          list.name = command.new_name
          list.save

          command.event << "Renamed #{command.list_name} to #{command.new_name}"
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        OracleLogger.log.debug {"RemoveCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
