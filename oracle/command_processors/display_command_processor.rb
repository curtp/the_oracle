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
    end
  end
end
