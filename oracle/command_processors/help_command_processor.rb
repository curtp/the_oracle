module Oracle
  module CommandProcessors
    class HelpCommandProcessor < BaseCommandProcessor

      def child_process(result)
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = "The Oracle Help"
            embed.colour = rand(0..0xfffff)
            embed.description = "The Oracle allows you to create lists of answers then ask the Oracle questions based on those lists. Answers are randomly selected from the list.\n\n"
            embed.description += "List names and answers with spaces must be put in quotes.\n\n"
            embed.description += "`'[list name]'` can be replaced with the list number.\n\n"
            embed.description += "The Oracle responds to `!oracle` or `!o`\n"
            manage_commands = "> Add a weighted answer to a list. The weight is an integer which represents the number of times the answer is considered when selecting an answer. The higher the number, the more likely it is to be selected. The list will be created if it doesn't already exist.\n"
            manage_commands += "> `!o add '[answer]' [weight] to '[list name]'`\n> \n"
            manage_commands += "> Remove a list\n"
            manage_commands += "> `!o remove '[list name]'`\n> \n"
            manage_commands += "> Remove an answer from a list\n"
            manage_commands += "> `!o remove '[answer]' from '[list name]'`\n"
            manage_commands += "> `!o remove [entry number] from [list number]`\n> \n"
            manage_commands += "> Renumber all of the lists\n"
            manage_commands += "> `!o renumber`\n> \n"
            manage_commands += "> Rename a list\n"
            manage_commands += "> `!o rename '[list name]' to '[new name]'`\n\u200b\n"
            embed.add_field(name: "Manage Lists", value: manage_commands, inline: false)
            view_commands = "> Display all answers in a list\n"
            view_commands += "> `!o display '[list name]'`\n> \n"
            view_commands += "> Display all lists\n"
            view_commands += "> `!o list`\n> \n"
            view_commands += "> Filter the lists down to only those that start with part of a name\n"
            view_commands += "> `!o filter '[name]'`\n\u200b\n"
            embed.add_field(name: "View Lists", value: view_commands, inline: false)
            ask_commands = "> Ask the oracle a question from a list\n"
            ask_commands += "> `!o ask '[list name]'`\n> \n"
            ask_commands += "> Ask the oracle a question and include the question\n"
            ask_commands += "> `!o ask '[list name]' '[question]'`"
            embed.add_field(name: "Ask Questions", value: ask_commands, inline: false)
          end
        else
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
end
