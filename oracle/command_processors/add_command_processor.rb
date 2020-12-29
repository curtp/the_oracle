require_relative "./base_command_processor"
require_relative "../models/list"

module Oracle
  module CommandProcessors
    class AddCommandProcessor < BaseCommandProcessor
      include EasyLogging

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        logger.debug { "process: validation result: #{validation_result}" }
        if validation_result[:valid]
          list = find_list
          if !list.present?
            list = new_list
          end
          list.add_entry(command.entry)
          list.save

          print_list(list)
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        logger.debug {"process: returning result: #{result}"}
        return result
      end

    end
  end
end
