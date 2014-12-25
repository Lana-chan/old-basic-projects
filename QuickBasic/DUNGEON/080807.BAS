'DungeON v0.30b
'Copyright 2008 Electrokinesis Studios
DECLARE SUB loadmaze ()
DECLARE SUB drawmaze (unit, set, cor)
DIM SHARED maze AS STRING
DIM SHARED dir AS INTEGER
SCREEN 13
COLOR 50
CLS
PRINT "DungeON v0.30b"
PRINT "Copyright 2008 Electrokinesis Studios"
INPUT "What maze should I load? ", maze$
loadmaze

nomaze:
PRINT "Maze not found. Quitting..."
END

SUB drawmaze (unit, set, cor)
SCREEN 13
offsetx = 45
offsety = 0
x = 230
y = 199
IF unit = 1 THEN
walldis3 = 10
walldis = 40
walldis2 = 60
ELSEIF unit = 2 THEN
walldis3 = 40
walldis = 60
walldis2 = 70
ELSEIF unit = 3 THEN
walldis3 = 60
walldis = 70
walldis2 = 75
ELSEIF unit = 4 THEN
walldis3 = 70
walldis = 75
walldis2 = 77
END IF

IF set = 1 THEN 'normal tunnel
LINE (offsetx, offsety)-(x + offsetx, y + offsety), 17, B
IF unit < 4 THEN PAINT (offsetx + walldis + 2, offsety + walldis + 2), cor, 17
IF unit < 4 THEN LINE (offsetx + walldis, offsety + walldis)-(x + offsetx - walldis, y + offsety - walldis), 17, B
IF unit < 4 THEN PAINT (offsetx + walldis, offsety + walldis - 2), cor + 2, 17
IF unit = 4 THEN PAINT (offsetx + walldis, offsety + walldis - 2), 18, 17
LINE (offsetx, offsety)-(offsetx + walldis, offsety + walldis), 17
LINE (offsetx + x, offsety)-(x + offsetx - walldis, offsety + walldis), 17
LINE (offsetx + x, offsety + y)-(x + offsetx - walldis, y + offsety - walldis), 17
LINE (offsetx, offsety + y)-(offsetx + walldis, y + offsety - walldis), 17
IF unit < 4 THEN PAINT (offsetx + walldis - 2, offsety + walldis + 2), cor, 17
IF unit < 4 THEN PAINT (offsetx + x - walldis + 2, offsety + y - walldis - 2), cor, 17
IF unit < 4 THEN PAINT (offsetx + x - walldis - 2, offsety + y - walldis + 2), cor - 2, 17


ELSEIF set = 2 THEN 'right
LINE (x + offsetx - walldis, offsety + walldis)-(x + offsetx - walldis + (-walldis + 80), y + offsety - walldis), 17, B
PAINT (x + offsetx - walldis + 3, offsety + walldis - 2), cor + 2, 17
PAINT (x + offsetx - walldis + (-walldis + 80) - 1, y + offsety - walldis + 3), cor - 2, 17

ELSEIF set = 3 THEN 'left
LINE (offsetx + walldis - (-walldis + 80), y + offsety - walldis)-(offsetx + walldis, offsety + walldis), 17, B
PAINT (offsetx + walldis - 3, offsety + walldis - 2), cor + 2, 17
PAINT (offsetx + walldis - (-walldis + 80) + 1, y + offsety - walldis + 2), cor - 2, 17


ELSEIF set = 4 THEN 'door north
LINE (walldis2 + 20 + offsetx, offsety + walldis2)-(x - walldis2 - 20 + offsetx, y - offsety - walldis), 17, B
PAINT (walldis2 + 20 + offsetx + 2, offsety + walldis2 + 3), 18, 17

ELSEIF set = 5 THEN 'door east
LINE (offsetx + (walldis + walldis3) / 2, offsety + walldis2)-(offsetx + (walldis + walldis3) / 2, y - offsety - (walldis + walldis3) / 2), 17

ELSEIF set = 6 THEN 'door west
LINE (x + offsetx - (walldis + walldis3) / 2, offsety + walldis2)-(x + offsetx - (walldis + walldis3) / 2, y - offsety - (walldis + walldis3) / 2), 17

END IF
END SUB

SUB loadmaze
ON ERROR GOTO nomaze
OPEN "./MAZES/" + maze$ + ".dun" FOR INPUT AS 1
INPUT #1, lin$
IF lin$ <> "[MAZE]" THEN
PRINT "File is not a maze. Quitting..."
END
END IF

curunit = 1
dir = 1
drawd: CLS
dis = 1
unit = curunit
doordis = 0
enddis = 0
getunit: SEEK 1, 1
unit2$ = LTRIM$(STR$(unit))
DO UNTIL LEN(unit2$) = 3
unit2$ = "0" + unit2$
LOOP
DO UNTIL EOF(1)
INPUT #1, lin$
IF LEFT$(lin$, 4) = unit2$ + ":" THEN GOTO readunit
LOOP
readunit:
IF dir = 1 THEN
N = VAL(MID$(lin$, 6, 3))
S = VAL(MID$(lin$, 10, 3))
E = VAL(MID$(lin$, 14, 3))
W = VAL(MID$(lin$, 18, 3))
ELSEIF dir = 2 THEN
N = VAL(MID$(lin$, 14, 3))
S = VAL(MID$(lin$, 18, 3))
E = VAL(MID$(lin$, 10, 3))
W = VAL(MID$(lin$, 6, 3))
ELSEIF dir = 3 THEN
N = VAL(MID$(lin$, 10, 3))
S = VAL(MID$(lin$, 6, 3))
E = VAL(MID$(lin$, 18, 3))
W = VAL(MID$(lin$, 14, 3))
ELSEIF dir = 4 THEN
N = VAL(MID$(lin$, 18, 3))
S = VAL(MID$(lin$, 14, 3))
E = VAL(MID$(lin$, 6, 3))
W = VAL(MID$(lin$, 10, 3))
END IF
doordir = VAL(MID$(lin$, 22, 1))
doorunit = VAL(MID$(lin$, 23, 3))
enddir = VAL(MID$(lin$, 27, 1))
cor = VAL(MID$(lin$, 29, 3))
drawmaze 1, 1, cor
IF N <> 0 THEN drawmaze dis + 1, 1, cor
IF E <> 0 THEN drawmaze dis, 3, cor
IF W <> 0 THEN drawmaze dis, 2, cor
IF doordir = dir THEN drawmaze dis, 4, cor
ndoorunit = doorunit
IF doordir = dir + 1 THEN drawmaze dis, 5, cor
IF doordir = 1 AND dir = 4 THEN drawmaze dis, 5, cor
IF doordir = dir - 1 AND doordir <> 0 THEN drawmaze dis, 6, cor
IF doordir = 4 AND dir = 1 THEN drawmaze dis, 6, cor
IF enddir = dir THEN drawmaze dis, 4, cor
IF enddir = dir + 1 THEN drawmaze dis, 5, cor
IF enddir = 1 AND dir = 4 THEN drawmaze dis, 5, cor
IF enddir = dir - 1 AND enddir <> 0 THEN drawmaze dis, 6, cor
IF enddir = 4 AND dir = 1 THEN drawmaze dis, 6, cor
unit = N
dis = dis + 1
IF N <> 0 AND dis < 5 THEN GOTO getunit
dis = dis - 1
SEEK 1, 1
curunit2$ = LTRIM$(STR$(curunit))
DO UNTIL LEN(curunit2$) = 3
curunit2$ = "0" + curunit2$
LOOP
DO UNTIL EOF(1)
INPUT #1, lin$
IF LEFT$(lin$, 4) = curunit2$ + ":" THEN GOTO readunit2
LOOP
readunit2: IF dir = 1 THEN
N = VAL(MID$(lin$, 6, 3))
S = VAL(MID$(lin$, 10, 3))
E = VAL(MID$(lin$, 14, 3))
W = VAL(MID$(lin$, 18, 3))
ELSEIF dir = 2 THEN
N = VAL(MID$(lin$, 14, 3))
S = VAL(MID$(lin$, 18, 3))
E = VAL(MID$(lin$, 10, 3))
W = VAL(MID$(lin$, 6, 3))
ELSEIF dir = 3 THEN
N = VAL(MID$(lin$, 10, 3))
S = VAL(MID$(lin$, 6, 3))
E = VAL(MID$(lin$, 18, 3))
W = VAL(MID$(lin$, 14, 3))
ELSEIF dir = 4 THEN
N = VAL(MID$(lin$, 18, 3))
S = VAL(MID$(lin$, 14, 3))
E = VAL(MID$(lin$, 6, 3))
W = VAL(MID$(lin$, 10, 3))
END IF
IF dis < 4 THEN LINE (offsetx + walldis, offsety + walldis + 3)-(x + offsetx - walldis, y + offsety - walldis + 2), 7, B

SLEEP
a$ = UCASE$(INKEY$)
IF a$ = "A" THEN dir = dir + 1
IF a$ = "D" THEN dir = dir - 1
IF dir > 4 THEN dir = 1
IF dir < 1 THEN dir = 4
IF a$ = "Q" THEN END
IF a$ = "W" THEN
IF doordir = dir AND dis = 1 THEN
curunit = ndoorunit
ELSEIF enddir = dir AND dis = 1 THEN
CLS
PRINT "You have found the exit."
PRINT "Congratulations!"
PRINT "Press any key to exit..."
SLEEP
END
ELSEIF N <> 0 THEN
curunit = N
END IF
END IF
IF a$ = "S" AND S <> 0 THEN curunit = S
GOTO drawd

END SUB

