Hitchhiker's Guide to VisTAI games
--------------------------------------------
VisTAI is copyright 2008 Electrokinesis Studios
--------------------------------------------
Contents:
1.What the heck is VisTAI?
2.So how do I program it?
  2.1.Main file
  2.2.Rooms
  2.3.Graphics
3. Changelog
4. Credits

--------------------------------------------
1. What the heck is VisTAI?
   The name VisTAI means Visual Text Adventure Interpreter. Some will find the
name familiar, as it is related to another program of ours, MaiTAI. This
program reads files programmed according to this help file and interprets them
into games.
   That means you can easily make graphical text adventure games with this
program.

--------------------------------------------
2. So how do I program it?
   It's simple. VisTAI uses a BASIC-alike programming method, so you can just
grab your prefered text editor (EDIT, Notepad, Wordpad, vi, emacs, whatever.)
and start coding.

--------------------------------------------
2.1. Main file
     The main file is what sends all the general information such
as names to the interpreter. It should be located at
"(VisTAI root directory)\(name of game, up to 8 chars)\INT.TAI".
     Here's a breakdown of the structure of the main file:

     [VISTAI] - Header: It's what VisTAI uses to recognize the files.
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
located at "(VisTAI)\(game)\ROOMS\(room name, up to 8 chars).RM"
     Here's the structure:

     [VISTAI ROOM] - Header.
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
     %R (item) - Removes said item from user's inventory.
     %T ## (timer) - Sets off a timer as the player enters the room, details
                     below.
     %D (drawing, sans .gfx) - Loads a graphic made with VisTAI's Graphic Tool.

     [ACTION] - Marks the start of the actions section.
     @SAY - The action the player should type, can be repeated with another
	        name if the statements are the same for that action, demonstrated
			below.
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
               if the room has any timers. NOTE: When you leave a room (GOTO),
			   any timer present will be disabled, unless you set it as global.
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
                        number of steps is up to 9, you must set it as
						two-digit like 09, or else it'll fail.), then runs a
						timer sub named whatever you put in (timer).
     DISTIMER (timer) - Disables a timer, named here.
     LOADDRAW (drawing, sans .GFX) - Loads said drawing.

     IMPORTANT NOTE: There's an universal action file support on VisTAI, so you
         don't have to program the same command for every room. These are
         located at "(VisTAI)\(game)\ACT.TAI". The file's presence in that
         folder is necessary, even if it's blank.

--------------------------------------------
2.3. Graphics
   The graphics that are used with VisTAI must be made with the VisTAI Graphics
tool (VTAIGFX#.EXE), then moved to the following folder: "(VisTAI)/(Game)/GFX".
   After doing so, you can load them in the game with %D and LOADDRAW, both
explained above.

--------------------------------------------
4. Changelog
   v0.20b - First revision
   v0.25b - Bugfixes
   v0.30b - more bugfixes.
   
--------------------------------------------
4. Credits
   VisTAI is copyright 2008 Electrokinesis Studios
   Visit us at electrokinesis.blogspot.com

   Programmer.........................................Eric P. Manal
   Original concept...................................Eric P. Manal
   Graphics...........................................Eric P. Manal

Contact:
   Eric P. Manal.............................cool_eric94@hotmail.com

--------------------------------------------------------------------------------