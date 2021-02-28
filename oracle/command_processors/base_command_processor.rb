module Oracle
  module CommandProcessors
    class BaseCommandProcessor

      attr_accessor :command
      attr_accessor :list, :server

      def initialize(command)
        self.command = command
      end

      def process
        result = {success: true, error_message: nil}

        # Make sure the command is valid before continuing
        validation_result = validate_command
        if !validation_result[:valid]
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
          OracleLogger.log.debug {"BaseCommandProcessor.process: validation failed returning result: #{result}"}
          return result
        end

        # If the command requires the list object, then look for it
        if command.list_required?
          # Retrieve the list. 
          self.list = find_list
          if !list.present?
            result[:success] = false
            result[:error_message] = "No list found."
            OracleLogger.log.debug {"BaseCommandProcessor.process: list not found: #{result}"}
            return result
          end
        end

        if command.server_required?
          self.server = Oracle::Models::Server.where(server_id: command.event.server.id).first
          if !server.present?
            result[:success] = false
            result[:error_message] = "Server not found."
            OracleLogger.log.debug {"BaseCommandProcessor.process: server not found: #{result}"}
            return result
          end
        end

        # Execute the command specific logic in the child class
        child_process(result)

        # If everything worked and the command should display the list, display it
        if result[:success] && command.display_list?
          print_list(list)
        end

        return result
      end

      protected

      def print_list(list)
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = "#{list.number} :: #{list.name}"
            embed.colour = rand(0..0xfffff)
            msg = ""
            list.entries.sort.each do |entry|
              msg = msg << "#{entry}\n"
            end
            embed.description = msg
          end
        else
          header = "#{list.number} :: #{list.name}"
          length = header.size
          command.event << "```"
          command.event << "#{list.number} :: #{list.name}"
          command.event << "=" * length
          list.entries.sort.each do |entry|
            command.event << entry
          end
          command.event << "```"
        end
      end

      def validate_command
        Oracle::Validators::CommandValidator.validate(command)
      end

      def find_list
        begin
          # If the list name is a number, lookup the list by number
          number = number_or_nil(command.list_name)
          if number.present?
            return Oracle::Models::List.where(server_id: command.event.server.id,
              number: number).first
          else
            return Oracle::Models::List.where(["server_id == ? and name collate nocase == ?",
              command.event.server.id, command.list_name.strip]).first
          end
        rescue Exception => e
          OracleLogger.log.error("BaseCommandProcessor: Issue loading list: #{e}")
          OracleLogger.log.error(e.backtrace.join("\n"))
        end
      end

      def new_list
        begin
          Oracle::Models::List.new(server_id: command.event.server.id,
            name: command.list_name.strip)
        rescue Exception => e
          OracleLogger.log.error("BaseCommandProcessor: Issue Creating list: #{e}")
          OracleLogger.log.error(e.backtrace.join("\n"))
        end
      end

      def server_lists
        begin
          Oracle::Models::List.where(server_id: command.event.server.id).order("upper(name) asc")
        rescue Exception => e
          OracleLogger.log.error("BaseCommandProcessor: Issue loading sever lists: #{e}")
          OracleLogger.log.error(e.backtrace.join("\n"))
        end
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

      private

      def number_or_nil(string)
        Integer(string || '')
      rescue ArgumentError
        nil
      end

    end
  end
end
