DECLARE SUB growdraw ()
DECLARE SUB loaddraw ()
'VisTAI Graphics Tool
'Copyright 2008 Electrokinesis Studios
'v0.20b
SCREEN 12
resetdraw: CLS
VIEW PRINT 1 TO 30
FOR i = 0 TO 15
COLOR i
PRINT i
NEXT i
curx = 300
cury = 120
lincolor = 15
speed = 1
LINE (40, 0)-(602, 244), , B
VIEW PRINT 17 TO 30
LOCATE 17, 1
PRINT "VisTAI Graphics Tool v0.20b"
PRINT "T - Draw line, Y - Change color, U - Save, I - Restore drawing, O - Cancel line P - Toggle cursor speed (1/10),";
COLOR 4
PRINT " N - Clear canvas, M - Quit"
COLOR 15
VIEW PRINT 20 TO 30
OPEN "tmpgfx" FOR OUTPUT AS 1

start:
IF curx < 41 THEN curx = 41
IF cury < 1 THEN cury = 1
IF curx > 600 THEN curx = 600
IF cury > 243 THEN cury = 243
LINE (curx, cury)-(curx, cury)
IF s = 1 THEN LINE (x1, y1)-(curx, cury), lincolor
LINE (curx, cury)-(curx, cury), 0
IF s = 1 THEN LINE (x1, y1)-(curx, cury), 0

a$ = UCASE$(INKEY$)
IF a$ = "M" THEN
INPUT "Are you sure you want to exit? (Y/N) ", exit$
IF UCASE$(exit$) = "Y" THEN
CLOSE 1
KILL "tmpgfx"
END
END IF
END IF
IF a$ = "W" THEN cury = cury - speed
IF a$ = "A" THEN curx = curx - speed
IF a$ = "S" THEN cury = cury + speed
IF a$ = "D" THEN curx = curx + speed
IF a$ = "I" THEN loaddraw
IF a$ = "O" THEN s = 0


IF a$ = "T" THEN
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

IF a$ = "Y" THEN
getc: INPUT "Choose color (0-15) ", lincolor
IF lincolor > 15 THEN GOTO getc
IF lincolor < 0 THEN GOTO getc
END IF

IF a$ = "U" THEN
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

IF a$ = "N" THEN
CLOSE 1
GOTO resetdraw
END IF

IF a$ = "P" THEN
IF speed = 1 THEN
speed = 10
ELSEIF speed = 10 THEN
speed = 1
END IF
PRINT "Speed toggled to" + STR$(speed)
END IF

GOTO start

nofile:
PRINT "File not found."
GOTO start

SUB growdraw
ON ERROR GOTO nofile
INPUT "What file do you want to load? ", file$
OPEN file$ + ".gfx" FOR INPUT AS 2
CLOSE 1
KILL "tmpgfx"
OPEN "tmpgfx" FOR OUTPUT AS 1
DO UNTIL EOF(2)
INPUT #2, lin$
nx1 = VAL(MID$(lin$, 1, 3)) * 2
ny1 = VAL(MID$(lin$, 5, 3)) * 2
nx2 = VAL(MID$(lin$, 9, 3)) * 2
ny2 = VAL(MID$(lin$, 13, 3)) * 2
col = VAL(MID$(lin$, 17, 3))
gx1$ = LTRIM$(STR$(nx1))
gy1$ = LTRIM$(STR$(ny1))
gx2$ = LTRIM$(STR$(nx2))
gy2$ = LTRIM$(STR$(ny2))
gcol$ = LTRIM$(STR$(col))
DO
IF LEN(gx1$) < 3 THEN gx1$ = "0" + gx1$
IF LEN(gy1$) < 3 THEN gy1$ = "0" + gy1$
IF LEN(gx2$) < 3 THEN gx2$ = "0" + gx2$
IF LEN(gy2$) < 3 THEN gy2$ = "0" + gy2$
IF LEN(gcol$) < 3 THEN gcol$ = "0" + gcol$
lenall = LEN(gx1$) + LEN(gy1$) + LEN(gx2$) + LEN(gy2$) + LEN(gcol$)
LOOP UNTIL lenall = 15
PRINT #1, gx1$ + " " + gy1$ + " " + gx2$ + " " + gy2$ + " " + gcol$
LOOP
CLOSE 2
CLOSE 1
OPEN "tmpgfx" FOR INPUT AS 1
DO UNTIL EOF(1)
INPUT #1, lin$
LINE (VAL(MID$(lin$, 1, 3)), VAL(MID$(lin$, 5, 3)))-(VAL(MID$(lin$, 9, 3)), VAL(MID$(lin$, 13, 3))), VAL(MID$(lin$, 17, 3))
LOOP
CLOSE 1
OPEN "tmpgfx" FOR APPEND AS 1
END SUB

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

