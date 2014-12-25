Hitchhiker's Guide to MaiTAI games
--------------------------------------------
MaiTAI copyright 2008 Electrokinesis Studios
--------------------------------------------
Contents:
1.What the heck is MaiTAI?
2.So how do I program it?
  2.1.Main file
  2.2.Rooms
3. Changelog
4. Credits

--------------------------------------------
1. What the heck is MaiTAI?
   The clever ones probably already said "duh, it's a drink."
If you're one of these, congratulations, you can recognize names.
   But no, MaiTAI is a pun on the drink's name, but it's not
drinkable. (WARNING: THE CREATOR OF THIS PROGRAM IS NOT RESPONSIBLE
IF YOU TRY TO SAVE MAITAI INTO A FLOPPY DISK, GRIND IT TO FINE POWDER,
MIX IT WITH WATER OR ANY OTHER FLUID AND DRINK IT.) MaiTAI instead
is, as the name also suggests, a Text Adventure Interpreter.
   That means you can easily make text adventure games with this
program.

--------------------------------------------
2. So how do I program it?
   it's simple. MaiTAI uses a BASIc-alike programming method, so you
can just grab your prefered text editor (EDIT, Notepad, Wordpad,
vi, emacs, whatever.) and start coding.

--------------------------------------------
2.1. Main file
     The main file is what sends all the general information such
as names to the interpreter. It should be located at
"(MaiTAI root directory)\(name of game, up to 8 chars)\INT.TAI".
     Here's a breakdown of the structure of the main file:

     [MAITAI] - Header: It's what MaiTAI uses to recognize the files.
     #hi - You can have comments on separate lines starting with #.
     The Average Adventures of Eric - Full name of the game.
     bedroom - First room's filename, sans .RM
     Eric -Character 's name
     200 - Game's maximum score

     IMPORTANT NOTE: As save games are now located at
         "(MaiTAI)\(game)\SAVES", you MUST created said folder, even if that
         folder is blank.

--------------------------------------------
2.2. Rooms
     The rooms are coded just like the main files. They should be
located at "(MaiTAI)\(game)\ROOMS\(room name, up to 8 chars).RM"
     Here's the structure:

     [MAITAI ROOM] - Header.
     Bedroom - Full title of room.
     &DESC - Start of description.
     You see your bedroom. - Description, can be as long as you like.
     %H - end of desc.

     List of description statements:
     %H - end.
     %P (room) - Skips to a room after pausing.
     %S - Pause the desc (for if it is longer than the screen or something)
     %I (item) - Checks for said item and only shows the following line if
                 player doesn't have the item.
     %N (item) - Checks for said item and only shows the following line if
                 player has the item.
     %G (item) - Adds said item to user's inventory, useful for first rooms
                 where the player starts off with an item.
     %T ## (timer) - Sets off a timer as the player enters the room, details
                     below.

     [ACTION] - Marks the start of the actions section.
     @SAY - The action the player should type, can be repeated with another name
            if the statements are the same for that action, demonstrated below.
     SAY Woo! - Statement, or "consequence".
     END - End of action.

     @GET 1 POINT - another action
     @GET ONE POINT - alternative action name
     SCORE 1 - Another statement.
     SAY WORKS!
     END

     @TIMER
     TIMER 02 test
     SAY The timer will go off in 2 steps...
     END

     @GET DISK -ditto
     ITEM DISK - Adds an item to the inventory...
     You got mail! I mean, disk. -...announces it if you get it
     You already have that. -...or if you already had it
        (NOTE: These lines must be right after the first ITEM one, or it won't
         work. Comment lines are OK though, as they are entirely skipped by the
         line parser.)
     END

     @DROP DISK
     RMITEM DISK
     SAY You dropped the disk.
     END

     [TIMER] - After the ACTION section there is the TIMER section, only needed
               if the room has any timers. NOTE: When you leave a room (GOTO),                  any timer present will be disabled, unless you set it as global.
               For it to be global, you must put this section with the
               correspondent timer sub in the ACT.TAI file (explained in a note
               below.)
     &test - Just like actions, but these start with &.
     SAY The timer has gone off - Any of the statements work here.
     END - Also just line actions, you need an END.

     Here's a list of statements:
     SAY (string of text) - prints said string.
     SCORE (number) - Adds said number to the score.
     ITEM (item) - Already explained in the file structure.
     RMITEM (item) - Removes a certain item from inventory.
     CHKITEM (0-1) (item) - Checks if item is on the inventory (1) or not (0),
                            and runs the following line accordingly.
     WAIT - Waits for user to press any key (useful for pauses between SAY
            statements or before GOTOs, if you have printed something before).
     GOTO (room filename, sans .RM) - Warps player to said room.
     WIN - Ends the game with a win message (remember you can still SAY custom
           messages before this).
     LOSE - Ends the game with a lose message.
     TIMER ## (timer) - Triggers a timer to be set off in ## steps (Even if the
                        number of steps is up to 9, you must set it as two-digit
                        like 09, or else it'll fail.), then runs a timer sub
                        named whatever you put in (timer).
     DISTIMER (timer) - Disables a timer, named here.

     IMPORTANT NOTE: In the last revision of MaiTAI (v1.00), an universal action
         file was added so you don't have to type out the same command for every
         room. These are located at "(MaiTAI)\(game)\ACT.TAI". The file presence
         in that folder is necessary, even if it's blank.

--------------------------------------------
4. Changelog
   v0.35a - First revision
   v0.35b - Minor bugfixes
   v0.40b - More bugfixes, new statement "CHKITEM"
   v0.50b - Added "SAVE" and "LOAD" on main gameplay.
   v0.55b - Added statements "WIN" and "LOSE", statements are no longer
            case sensitive, added %N and %G to desc statements, minor bugfixes.
   v1.00  - Added "INV" command to gameplay, added universal action files,
            bugfixes.
   v1.10  - Major bugfixes, including one (QuickBasic's fault!) that caused
            commas to be registred as line breaks, and the introduction of
            timers.
   
--------------------------------------------
4. Credits
   MaiTAI is copyright 2008 Electrokinesis Studios
   Visit us at electrokinesis.blogspot.com

   Programmer.........................................Eric P. Manal
   Idea-giving guy...........................................Chwoka
   Original concept...................................Eric P. Manal
   New concepts..............................................Chwoka

Contact:
   Eric P. Manal.............................cool_eric94@hotmail.com

--------------------------------------------------------------------------------