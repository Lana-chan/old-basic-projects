'MaiTAI v0.11a
'Copyright 2008 Electrokinesis Studios
'Do not distribute

'init
DECLARE SUB loadroom (room$)
DECLARE SUB loadgame (name$)
DECLARE SUB debug (text$)
DECLARE SUB prtitle (rmtitle$, points%)
DECLARE FUNCTION readline$ (file)
DIM SHARED lfile AS STRING
DIM SHARED gamename AS STRING
DIM SHARED maxpoint AS INTEGER
DIM SHARED points AS INTEGER
DIM SHARED chrname AS STRING
DIM SHARED longgamename AS STRING
points = 0

CLS
PRINT "Mai-TAI v0.11a build 170508 - FOR USE WITHIN ELECTROKINESIS STUDIOS WORKERS"
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
SLEEP
a$ = INKEY$
PRINT "Press any key..."

CLS
prtitle rmtitle$, points
rmin: PRINT chrname$;
INPUT "> ", cmd$

IF UCASE$(LEFT$(cmd$, 6)) = "SCORE " THEN
points = VAL(MID$(cmd$, 6))
CLS
prtitle rmtitle$, points
GOTO rmin
ELSEIF UCASE$(cmd$) = "QUIT" THEN
END
ELSE
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

