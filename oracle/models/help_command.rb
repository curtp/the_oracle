module Oracle
  module Models
    class HelpCommand < BaseCommand
      def help_command?
        return true
      end
    end
  end
end
