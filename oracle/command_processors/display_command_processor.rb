require_relative "./base_command_processor"
require_relative "../models/list"

module Oracle
  module CommandProcessors
    class DisplayCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        OracleLogger.log.debug {"DisplayCommandProcessor.process: validation result: #{validation_result}"}
        if validation_result[:valid]

          if command.instructions.size == 1
            result = display_server_lists
            return result if !result[:success]
          else
            result = display_list
            return result if !result[:success]
          end

        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        OracleLogger.log.debug {"DisplayCommandProcessor.process: returning result: #{result}"}
        return result
      end

      private

      def display_list
        result = {success: true, error_message: nil}
        list = find_list
        if !list.present?
          result[:success] = false
          result[:error_message] = "List not found"
          return result
        end
        print_list(list)
        return result
      end

      def display_server_lists
        OracleLogger.log.debug {"DisplayCommandProcessor: displaying server lists"}
        result = {success: true, error_message: nil}
        OracleLogger.log.debug {"DisplayCommandProcessor: retrieving server lists"}
        lists = server_lists
        if !lists.present?
          OracleLogger.log.debug {"DisplayCommandProcessor: no lists... returning an error"}
          result[:success] = false
          result[:error_message] = "No lists found"
          return result
        end
        OracleLogger.log.debug {"DisplayCommandProcessor: got server lists: #{lists.size}"}
        print_server_lists(lists)
        return result
      end

      def print_server_lists(lists)
        command.event << "```"
        command.event << "Oracle Lists"
        command.event << "====================="
        lists.each do |list|
          command.event << "#{list.number} :: #{list.name}"
        end
        command.event << "```"
      end
    end
  end
end
