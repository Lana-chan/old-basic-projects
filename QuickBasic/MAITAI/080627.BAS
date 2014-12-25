'MaiTAI v0.11a
'Copyright 2008 Electrokinesis Studios
'Do not distribute

'init
DECLARE SUB loadroom (room$)
DECLARE SUB loadgame (name$)
DECLARE SUB debug (text$)
DECLARE SUB prtitle (rmtitle$, points%)
DECLARE SUB findaction (action$)
DECLARE FUNCTION readline$ (file)
DIM SHARED lfile AS STRING
DIM SHARED gamename AS STRING
DIM SHARED maxpoint AS INTEGER
DIM SHARED points AS INTEGER
DIM SHARED chrname AS STRING
DIM SHARED longgamename AS STRING
DIM SHARED rmtitle AS STRING
points = 0

CLS
PRINT "Mai-TAI v0.11a build 240608 - FOR USE WITHIN ELECTROKINESIS STUDIOS WORKERS"
PRINT "DO NOT DISTRIBUTE"
INPUT "What game should I load? (0 to exit) ", gamename$
IF gamename$ = "0" THEN END
loadgame gamename$
END

'errors
notgame:
PRINT "Game not found"
PRINT "Press any key to exit..."
SLEEP
a$ = INKEY$
END

brokenfile:
IF ERR = 62 THEN
SEEK 1, 1
RESUME NEXT
END IF
PRINT lfile$ + " file corrupted"
PRINT "Press any key to exit..."
SLEEP
a$ = INKEY$
END

SUB debug (text$)
bdebug = 1
tdebug$ = "DEBUG (will not appear on release versions): "
IF bdebug = 1 THEN PRINT tdebug$ + text$
END SUB

SUB findaction (action$)
DO UNTIL EOF(1)
IF readline(1) = "@" + action$ THEN
debug ("action " + action$ + " found")
GOTO getstatement
con$ = readline(1)
END IF
LOOP

PRINT "I don't know what `" + action$ + "` means."
EXIT SUB

getstatement:
DO UNTIL con$ = "END"

IF LEFT$(con$, 4) = "GOTO" THEN
debug ("goto statement")
CLOSE 1
loadroom MID$(action$, 6)

ELSEIF LEFT$(con$, 5) = "SCORE" THEN
points = points + VAL(MID$(con$, 7))
debug MID$(con$, 7)
oldrow = CSRLIN
prtitle rmtitle$, points
LOCATE oldrow, 1

ELSEIF LEFT$(con$, 3) = "SAY" THEN
PRINT MID$(con$, 5)

END IF
con$ = readline(1)
LOOP

END SUB

SUB loadgame (name$)
ON ERROR GOTO notgame
lfile$ = "INT.TAI"
OPEN "./" + name$ + "/int.tai" FOR INPUT AS 1
debug "opened ./" + name$ + "/int.tai"
IF readline(1) = "[MAITAI]" THEN PRINT "Game recognized. Loading..."
longgamename$ = readline(1)
firstroom$ = readline(1)
chrname$ = readline(1)
maxpoint = VAL(readline(1))
debug "game name: " + longgamename$
debug "first room to run: " + firstroom$
debug "charater's name: " + chrname$
debug "maximum points:" + STR$(maxpoint)
CLOSE 1
debug "file closed"
PRINT "Game loaded successfully."
PRINT "Press any key..."
SLEEP
a$ = INKEY$
loadroom firstroom$
END SUB

SUB loadroom (room$)
lfile$ = room$ + ".RM"
OPEN "./" + gamename$ + "/rooms/" + room$ + ".rm" FOR INPUT AS 1
debug "opened ./" + gamename$ + "/rooms/" + room$ + ".rm"
IF readline(1) = "[MAITAI ROOM]" THEN debug ("room recognized")
rmtitle$ = readline(1)
debug "room title: " + rmtitle$
PRINT "Press any key..."
SLEEP
a$ = INKEY$

CLS
prtitle rmtitle$, points
SEEK 1, 1
look: DO UNTIL desc$ = "&DESC"
desc$ = readline$(1)
LOOP
DO UNTIL desc$ = "%"
desc$ = readline$(1)
PRINT desc$
LOOP
PRINT

rmin: PRINT chrname$;
INPUT "> ", cmd$

IF UCASE$(cmd$) = "LOOK" THEN
GOTO look

ELSEIF UCASE$(cmd$) = "QUIT" THEN
END

ELSEIF cmd$ = "" THEN
GOTO rmin

ELSE
SEEK 1, 1
DO
fin$ = readline(1)
IF fin$ = "[ACTION]" THEN
debug ("actions found")
findaction UCASE$(cmd$)
PRINT
GOTO rmin
END IF
LOOP UNTIL EOF(1)
SEEK 1, 1
debug ("actions not found")
GOTO rmin
END IF

END SUB

SUB prtitle (rmtitle$, points%)
VIEW PRINT 1 TO 25
COLOR 0, 7
PRINT "                                                                                "
LOCATE 1, 1
PRINT " " + rmtitle$
endlen = 78 - LEN(STR$(points)) - LEN(STR$(maxpoint))
LOCATE 1, endlen
PRINT "|" + STR$(points) + "/" + LTRIM$(STR$(maxpoint)) + " "
VIEW PRINT 2 TO 25
COLOR 7, 0
END SUB

FUNCTION readline$ (file)
ON ERROR GOTO brokenfile
in: INPUT #file, in$
IF LEFT$(in$, 1) = "#" THEN GOTO in
readline$ = in$
END FUNCTION

