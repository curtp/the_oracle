module Oracle
  module CommandProcessors
    class FilterCommandProcessor < BaseCommandProcessor

      def child_process(result)

        if command.instructions.size == 2
          display_server_lists_matching(command.name, result)
        else
          display_filters(result)
        end

        OracleLogger.log.debug {"FilterCommandProcessor.process: returning result: #{result}"}
      end

      private

      def display_server_lists_matching(name, result)
        OracleLogger.log.debug {"FilterCommandProcessor: displaying server lists matching #{command.name}"}
        OracleLogger.log.debug {"FilterCommandProcessor: retrieving server lists"}
        lists = server_lists.where(["name like ?", "#{name}%"])
        if !lists.present?
          OracleLogger.log.debug {"FilterCommandProcessor: no lists... returning an error"}
          result[:success] = false
          result[:error_message] = "No lists found"
          return result
        end
        OracleLogger.log.debug {"FilterCommandProcessor: got server lists: #{lists.size}"}
        print_server_lists(lists)
        return result
      end

      def display_filters(result)
        # Get all of the filters for the current list
        filters = Hash.new(0)
        server_lists.each do |list|
          filters[list.name.split(" ").first] += 1
        end

        if filters.empty?
          result[:success] = false
          result[:error_message] = "No filters available"
          return
        end

        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = "Available Filters"
            embed.colour = rand(0..0xfffff)
            msg = ""
            filters.each do |key, value|
              msg = msg << "`#{key} (#{value})`\n"
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
