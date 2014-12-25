DungeON help file
--------------------------------------------------------------------------------
DungeON is copyright 2008 Electrokinesis Studios
--------------------------------------------------------------------------------
Contents:
1. What is DungeON?
2. How do I make mazes for it?
3. Changelog
4. Credits

----------------------------------------
1. What is DungeON?
   As the name suggests, DungeON is a maze/dungeon engine, that with someone can
easily make a maze game in 3D.

----------------------------------------
2. How do I make mazes for it?
   Think of a maze as a grid. Each square here is an unit, with directions
North, South, East and West. Here's an example:

   [MAZE]
   #     N   S   E   W  door end
   001: 002 000 000 000 0000 0
   002: 003 001 005 000 0000 0
   003: 004 002 000 006 0000 0
   004: 000 003 000 000 0000 0
   005: 000 000 000 002 2007 0
   006: 000 000 003 000 0000 0

   007: 008 000 000 000 4005 0
   008: 000 007 000 000 0000 2

   In this case, the unit 1 (where the player starts) has the unit 2 at north,
unit 2 has the unit 3 at north, 1 at south, 5 at east and so on.
   In the "door" row, it's checked if the unit has a door on it. The first digit
determines the direction (1=N, 2=E, 3=S, 4=W), and the other 3 digits determine
to what room it'll go.
   On the last row, it's checked if there will be an end door or not (It will be
just like the other doors). The number tells the program which direction it'll
be on.
   Be careful to not put a door and another unit on the same direction, or it
may cause graphical and/or logical glitches.

----------------------------------------
3. Changelog
   v0.10b - first release
   v0.20b - Added doors and end.

----------------------------------------
4. Credits
   DungeON is copyright 2008 Electrokinesis Studios
   Visit us at electrokinesis.blogspot.com

   Programming................................Eric P. Manal
   Original idea..............................Eric P. Manal
   Additional ideas...........................Chwoka

   Contact:
   Eric P. Manal..............................cool_eric94@hotmail.com

--------------------------------------------------------------------------------