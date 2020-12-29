require_relative "./base_command_processor"
require_relative "../models/list"

module Oracle
  module CommandProcessors
    class DisplayCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        puts "DisplayCommandProcessor validation result: #{validation_result}"
        if validation_result[:valid]

          if command.instructions.size == 1
            puts "Displaying all lists for server"
            result = display_server_lists
            return result if !result[:success]
          else
            puts "Displaying an individual list"
            result = display_list
            return result if !result[:success]
          end

        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        puts "DisplayCommandProcessor returning result: #{result}"
        return result
      end

      private

      def display_list
        result = {success: true, error_message: nil}
        list = find_list
        if !list.present?
          result[:success] = false
          result[:error_message] = nil
          return result
        end
        print_list(list)
        return result
      end

      def display_server_lists
        result = {success: true, error_message: nil}
        lists = server_lists
        if !lists.present?
          result[:success] = false
          result[:error_message] = nil
          return result
        end
        print_server_lists(lists)
        return result
      end

      def print_server_lists(lists)
        command.event << "Oracle Lists"
        command.event << "====================="
        lists.each do |list|
          command.event << list.name
        end
      end
    end
  end
end
