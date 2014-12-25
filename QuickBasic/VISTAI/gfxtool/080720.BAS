DECLARE SUB loaddraw ()
'VisTAI Graphics Tool
'Copyright 2008 Electrokinesis Studios
'v0.10b
SCREEN 13
resetdraw: CLS
curx = 151
cury = 60
lincolor = 15
LINE (19, 0)-(301, 122), , B
VIEW PRINT 17 TO 24
LOCATE 17, 1
PRINT "C - Change color, X - Clear canvas      Q - Quit, Z - Draw line, F - Save       R - Restore drawing, E - Cancel line"
VIEW PRINT 20 TO 24
OPEN "tmpgfx" FOR OUTPUT AS 1

start:
IF curx < 20 THEN curx = 20
IF cury < 1 THEN cury = 1
IF curx > 300 THEN curx = 300
IF cury > 121 THEN cury = 121
LINE (curx, cury)-(curx, cury)
IF s = 1 THEN LINE (x1, y1)-(curx, cury), lincolor
LINE (curx, cury)-(curx, cury), 0
IF s = 1 THEN LINE (x1, y1)-(curx, cury), 0

a$ = UCASE$(INKEY$)
IF a$ = "Q" THEN
CLOSE 1
KILL "tmpgfx"
END
END IF
IF a$ = "W" THEN cury = cury - 1
IF a$ = "A" THEN curx = curx - 1
IF a$ = "S" THEN cury = cury + 1
IF a$ = "D" THEN curx = curx + 1
IF a$ = "R" THEN loaddraw
IF a$ = "E" THEN s = 0


IF a$ = "Z" THEN
IF s = 0 THEN
x1 = curx
y1 = cury
s = 1
ELSE
x2 = curx
y2 = cury
LINE (x1, y1)-(x2, y2), lincolor
s = 0
fx1$ = LTRIM$(STR$(x1))
fy1$ = LTRIM$(STR$(y1))
fx2$ = LTRIM$(STR$(x2))
fy2$ = LTRIM$(STR$(y2))
col$ = LTRIM$(STR$(lincolor))
DO
IF LEN(fx1$) < 3 THEN fx1$ = "0" + fx1$
IF LEN(fy1$) < 3 THEN fy1$ = "0" + fy1$
IF LEN(fx2$) < 3 THEN fx2$ = "0" + fx2$
IF LEN(fy2$) < 3 THEN fy2$ = "0" + fy2$
IF LEN(col$) < 3 THEN col$ = "0" + col$
lenall = LEN(fx1$) + LEN(fy1$) + LEN(fx2$) + LEN(fy2$) + LEN(col$)
LOOP UNTIL lenall = 15
PRINT #1, fx1$ + " " + fy1$ + " " + fx2$ + " " + fy2$ + " " + col$
END IF
END IF

IF a$ = "C" THEN
getc: INPUT "Choose color (0-15) ", lincolor
IF lincolor > 15 THEN GOTO getc
IF lincolor < 0 THEN GOTO getc
END IF

IF a$ = "F" THEN
INPUT "What name do you want to save as? ", filename$
OPEN filename$ + ".gfx" FOR OUTPUT AS 2
CLOSE 1
OPEN "tmpgfx" FOR INPUT AS 1
DO UNTIL EOF(1)
INPUT #1, lin$
PRINT #2, lin$
LOOP
CLOSE 1
OPEN "tmpgfx" FOR APPEND AS 1
CLOSE 2
END IF

IF a$ = "X" THEN
CLOSE 1
GOTO resetdraw
END IF

GOTO start

nofile:
PRINT "File not found."
GOTO start

SUB loaddraw
ON ERROR GOTO nofile
INPUT "What file do you want to load? ", file$
OPEN file$ + ".gfx" FOR INPUT AS 2
CLOSE 1
KILL "tmpgfx"
OPEN "tmpgfx" FOR OUTPUT AS 1
DO UNTIL EOF(2)
INPUT #2, lin$
PRINT #1, lin$
LOOP
SEEK 2, 1
DO UNTIL EOF(2)
INPUT #2, lin$
LINE (VAL(MID$(lin$, 1, 3)), VAL(MID$(lin$, 5, 3)))-(VAL(MID$(lin$, 9, 3)), VAL(MID$(lin$, 13, 3))), VAL(MID$(lin$, 17, 3))
LOOP
CLOSE 2
END SUB

