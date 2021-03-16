module Oracle
  module Models
    class FilterCommand < BaseCommand
      # The name to filter by is the last entry in the instructions
      def name
        instructions.last
      end
    end
  end
end
