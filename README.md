# The Oracle
Discord bot providing answers to questions

This is a work in progress and not ready for general use. Message me if you'd like to try it out. There is a very limited number of servers allowed at this time.

# Required Permissions
Send Messages - Allows the bot to send messages to the channel.

# Optional Permissions
Embed Links - Allows the bot to reply to ask commands with a nicer formatted answer.
Manage Messages - Allows the bot to remove the original ask question when replying with an answer, reducing clutter.

## How It Works
The oracle works off of lists of entries. It is up to the server owners to
create and manage the lists. Each server can have multiple lists. Once the
lists are created, then the oracle can be asked questions from those lists.

When the bot is first added to the server, the following 3 lists are added.

| Odds - Even           | Odds - Unlikely       | Odds - Likely         |
| --------------------- | --------------------- | --------------------- |
| No, and complication  | No, and complication  | No                    |
| No                    | No                    | No, but benefit       |
| No, but benefit       | No                    | Yes, but complication |
| Yes, but complication | No, but benefit       | Yes                   |
| Yes                   | Yes, but complication | Yes                   |
| Yes, and benefit      | Yes                   | Yes, and benefit      |

You can change these lists to suit your needs, or remove them from the oracle (see below).

## Some Things to Know
1) Only server owners can add, edit, or remove lists.
2) Anyone can view lists or ask the oracle questions.
3) List names can only be 50 characters long. Anything longer than 50 characters is automatically shortened to 50.
4) Entries can be up to 100 characters long. Anything longer than 100 characters is automatically shortened to 100.
5) Currently, there isn't a limit to the number of lists allowed on a server. Add too many, and it will be difficult to use.
6) Duplicate entries can be added to a list, however, entries are removed by name. In the examples above, removing No from a list will remove ALL No entries.
7) Think beyond question/answer interactions. This works great for any random table.
8) Name lists so they are grouped together. Lists are always displayed in alphabetical order.
9) After adding the list, use the assigned number to interact with it and save typing. This makes it much easier to use on a phone.

## Talking to the Oracle
There are two ways to talk to the oracle. Either of these will work
```
!oracle
!o
```

## Creating Lists
Here is an example of a list for asking how likely it is for something to happen:

```
even odds
---------
No
Yes
```

Here are the oracle commands to create this list:
```
!oracle add No to "even odds"
!oracle add Yes to "even odds"
```
Once the list is created, it will be assigned a number which can be used to referr to the list, saving typing.

## Asking Questions
Here are the two commands to ask questions of the list and sample answers:
```
!oracle ask "even odds"
@user, the answer is: "Yes"

!oracle ask "even odds" "Will it snow today?"
@user asked: "Will it snow today?". The answer is: "Yes".

!o ask 1 "Will it snow today?"
```

## List Maintenance
To display all lists for the server:
```
!oracle display

!oracle list

!o list
```

To display all entries in a list:
```
!oracle display "[list name]"
e.g. !oracle display "even odds"

!oracle list "[list name]"
e.g. !oracle list "even odds"

!o list 1
```

To rename a list:
```
!oracle rename "[list name]" to "[new list name]"
e.g. !oracle rename "even odds" to "Odds - Even"

!o rename 1 to "Odds - Even"
```

To remove an answer from a list:
```
!oracle remove "[answer]" from "[list name]"
e.g. !oracle remove Yes from "even odds"

!o remove Yes from 1
```

To remove a list from the server:
```
!oracle remove "[list name]"
e.g. !oracle remove "even odds"

!o remove 1
```

To renumber the lists:
```
!oracle renumber
!o renumber
```

# Development
1. Clone the repository
2. Make the data and logs directories
3. Create a bot in Discord and copy the token
4. Make the .env file
5. Add the following to the .env file:
```
BOT_TOKEN="[Paste Discord Bot Token Here]"
```
6. Run docker-compose up
