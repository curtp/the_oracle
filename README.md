# the_oracle
Discord bot providing answers to questions

## Hot It Works
The oracle works off of lists of answers. It is up to the members of the server
to create the lists. Each server can have multiple lists. Once the lists are
created, then the oracle can be asked for answers from those lists.

## Creating Lists
Here is an example of a list for asking how likely it is for something to happen:

even odds
---------
No
Yes

Here are the oracle commands to create this list:
!oracle add No to "even odds"
!oracle add Yes to "even odds"

## Asking Questions
Here are the two commands to ask questions of the list and sample answers:
!oracle ask "even odds"
@user, the answer is: "Yes"

!oracle ask "even odds" "Will it snow today?"
@user asked: "Will it snow today?". The answer is: "Yes".

## List Maintenance

To display all lists for the server:
!oracle display

To display all entries in a list:
!oracle display "[list name]"
e.g. !oracle display "even odds"

To remove an answer from a list:
!oracle remove "[answer]" from "[list name]"
e.g. !oracle remove Yes from "even odds"

To remove a list from the server:
!oracle remove "[list name]"
e.g. !oracle remove "even odds"
