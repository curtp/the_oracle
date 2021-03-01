module Oracle
  module CommandProcessors
    class AskCommandProcessor < BaseCommandProcessor

      def child_process(result)

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

        OracleLogger.log.debug {"AskCommandProcessor.process: returning result: #{result}"}
        return result
      end

      private

      def ask_with_question(list)
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = select_title
            embed.colour = rand(0..0xfffff)
            embed.description = "**#{command.event.user.mention} asked:** '#{command.question}'.\r\n**The answer is:** '#{list.select_answer}'"
          end
        else
          command.event << "#{command.event.user.mention} asked: '#{command.question}'. The answer is: '#{list.select_answer}'"
        end
      end

      def ask_without_question(list)
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = select_title
            embed.colour = rand(0..0xfffff)
            embed.description = "**#{command.event.user.mention}, the answer is:** '#{list.select_answer}'"
          end
        else
          command.event << "#{command.event.user.mention}, the answer is: '#{list.select_answer}'"
        end
      end

      def remove_question
        return if !has_manage_messages_permission?
        command.event.message.delete
      end

      def select_title
        Oracle.config[:answer_title].sample
      end

    end
  end
end
