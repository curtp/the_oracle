require_relative "./base_command_processor"
require_relative "../models/list"

module Oracle
  module CommandProcessors
    class AskCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        OracleLogger.log.debug {"AskCommandProcessor.process: validation result: #{validation_result}"}
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

          remove_question

        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        OracleLogger.log.debug {"AskCommandProcessor.process: returning result: #{result}"}
        return result
      end

      private

      def ask_with_question(list)
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = select_title
            embed.colour = rand(0..0xfffff)
            embed.description = "**#{command.event.user.mention} asked:** '#{command.question}'.\r\n**The answer is:** '#{select_answer(list)}'"
          end
        else
          command.event << "#{command.event.user.mention} asked: '#{command.question}'. The answer is: '#{select_answer(list)}'"
        end
      end

      def ask_without_question(list)
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = select_title
            embed.colour = rand(0..0xfffff)
            embed.description = "**#{command.event.user.mention}, the answer is:** '#{select_answer(list)}'"
          end
        else
          command.event << "#{command.event.user.mention}, the answer is: '#{select_answer(list)}'"
        end
      end

      def remove_question
        return if !has_manage_messages_permission?
        command.event.message.delete
      end

      def select_answer(list)
        list.entries.shuffle.sample
      end

      def select_title
        Oracle.config[:answer_title].sample
      end

      def has_embed_permission?
        return get_bot_profile.permission?(:embed_links, command.event.channel)
      end

      def has_manage_messages_permission?
        return get_bot_profile.permission?(:manage_messages, command.event.channel)
      end

      def get_bot_profile
        bot_profile = command.event.bot.profile.on(command.event.server)
      end
    end
  end
end
