module Oracle
  module CommandProcessors
    class DisplayCommandProcessor < BaseCommandProcessor

      def child_process(result)

        if command.instructions.size == 1
          result = display_server_lists
        else
          self.list = find_list
          if self.list.present?
            print_list(list)
          else
            result[:success] = false
            result[:error_message] = "No list found."
          end
        end

        OracleLogger.log.debug {"DisplayCommandProcessor.process: returning result: #{result}"}
      end

      private

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
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = "Oracle Lists"
            embed.colour = rand(0..0xfffff)
            msg = ""
            pad = lists.maximum(:number).to_s.length
            lists.each do |list|
              msg = msg << "#{list.number.to_s.rjust(pad, "0")} :: #{list.name}\n"
            end
            embed.description = msg
          end
        else
          command.event << "```"
          command.event << "Oracle Lists"
          command.event << "====================="
          pad = lists.maximum(:number).to_s.length
          lists.each do |list|
            command.event << "#{list.number.to_s.rjust(pad)} :: #{list.name}"
          end
          command.event << "```"
        end
      end
    end
  end
end
