module Oracle
  module CommandProcessors
    class HelpCommandProcessor < BaseCommandProcessor

      def child_process(result)
        HelpCommandProcessor.build_help_message(command.event)
      end

      def self.build_help_message(event)
        event << "**Welcome to The Oracle**"
        event << " "
        event << "The Oracle allows you to create lists of answers then ask the Oracle questions based on those lists. The Oracle answers your question by selecting a random answer from the list."
        event << " "
        event << "When creating lists, put quotes around answers or list names which have spaces."
        event << " "
        event << "You can use *!oracle* or *!o* to talk to the oracle."
        event << "You can also replace [list name] with the list number."
        event << " "
        event << "**-- Manage Lists --**"
        event << "!oracle add '[answer]' to '[list name]' - Adds an answer to the named list: !oracle add 'not today' to 'very unlikely'"
        event << "!oracle remove '[list name]' - Removes the named list: !oracle remove 'very unlikely'"
        event << "!oracle remove '[answer]' from '[list name]' - Removes an answer from the list: !oracle remove 'not today' from 'very unlikely'"
        event << "!oracle renumber - Renumbers all of the lists"
        event << " "
        event << "**-- View Lists --**"
        event << "!oracle display '[list name]' - Displays all answers in a list: !oracle display 'very unlikely'"
        event << "!oracle display - Displays all lists the Oracle knows about"
        event << "!oralce list"
        event << " "
        event << "**-- Ask The Oracle Questions --**"
        event << "!oracle ask '[list name]' - Asks the oracle a question from the list: !oracle ask 'very unlikely'"
        event << "!oracle ask '[list name]' '[question]' - Asks the oracle a question from the list: !oracle ask 'very unlikely' 'did the car crash?'"
        event << " "
        event << "!oracle help - Display this help message <https://github.com/curtp/the_oracle>"
      end

    end
  end
end
