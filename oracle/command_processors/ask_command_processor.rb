require_relative "./base_command_processor"
require_relative "../models/list"

module Oracle
  module CommandProcessors
    class AskCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        puts "AskCommandProcessor validation result: #{validation_result}"
        if validation_result[:valid]
          list = find_list
          if !list.present?
            result[:success] = false
            result[:error_message] = "List not found"
            return result
          end

          if list.entries.empty?
            result[:success] = false
            result[:error_message] = "There are no answers in the list."
            return result
          end

          if command.question.present?
            ask_with_question(list)
          else
            ask_without_question(list)
          end

        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        puts "RemoveCommandProcessor returning result: #{result}"
        return result
      end

      private

      def ask_with_question(list)
        answer = list.entries.sample
        command.event << "You asked: '#{command.question}'. The answer is: '#{answer}'"
      end

      def ask_without_question(list)
        command.event << "The asnwer is: '#{list.entries.sample}'"
      end

    end
  end
end
