'MaiTAI v0.50b
'Copyright 2008 Electrokinesis Studios
'Do not distribute
'init
DECLARE SUB loadroom (room$)
DECLARE SUB loadgame (name$)
DECLARE SUB debug (text$)
DECLARE SUB prtitle (rmtitle$, points%)
DECLARE SUB findaction (action$)
DECLARE SUB additem (item$)
DECLARE SUB delitem (item$)
DECLARE SUB savegame (file$)
DECLARE SUB loadsave (file$)
DECLARE FUNCTION chkitem (item$)
DECLARE FUNCTION readline$ (file)
DIM SHARED lfile AS STRING
DIM SHARED gamename AS STRING
DIM SHARED chrname AS STRING
DIM SHARED longgamename AS STRING
DIM SHARED rmtitle AS STRING
DIM SHARED glbroom AS STRING
DIM SHARED maxpoint AS INTEGER
DIM SHARED points AS INTEGER
DIM SHARED OEOF AS INTEGER
DIM SHARED inv AS INTEGER
DIM SHARED errors AS INTEGER
DIM SHARED rmerr AS INTEGER
points = 0
inv = 0
errors = 1

CLS
PRINT "Mai-TAI v0.50b build 070708 - FOR USE WITHIN ELECTROKINESIS STUDIOS WORKERS"
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

noinv:
IF ERR = 62 THEN
debug ("EOF")
OEOF = 1
SEEK 2, 1
RESUME NEXT
END IF
debug ("inventory not found")
CLOSE 2
OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 4
CLOSE 4
inv = 1
RESUME NEXT

error404:
PRINT "Savegame not found or corrupt."
rmerr = 1
loadroom room$

SUB additem (item$)
OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 2
inv = 1
PRINT #2, item$
CLOSE 2
END SUB

FUNCTION chkitem (item$)
'ON ERROR GOTO noinv
IF inv = 0 GOTO noitem
CLOSE 2
OPEN "./" + gamename$ + "/inv.tai" FOR INPUT AS 2
DO UNTIL OEOF = 1
INPUT #2, lin$
IF lin$ = item$ THEN GOTO got
LOOP
noitem: chkitem = 0
OEOF = 0
CLOSE 2
EXIT FUNCTION

got:
debug ("has item")
chkitem = 1
OEOF = 0
CLOSE 2
END FUNCTION

SUB debug (text$)
bdebug = 1
tdebug$ = "DEBUG (will not appear on release versions): "
IF bdebug = 1 THEN PRINT tdebug$ + text$
END SUB

SUB delitem (item$)
OPEN "./" + gamename$ + "/inv.tai" FOR INPUT AS 2
OPEN "tmpinv" FOR APPEND AS 3
DO UNTIL EOF(2)
INPUT #2, lin$
IF lin$ <> item$ THEN PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
KILL "./" + gamename$ + "/inv.tai"
NAME "tmpinv" AS "./" + gamename$ + "/inv.tai"
debug ("item " + item$ + " deleted.")
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
CLOSE 1
CALL loadroom(MID$(con$, 6))

ELSEIF LEFT$(con$, 5) = "SCORE" THEN
points = points + VAL(MID$(con$, 7))
debug MID$(con$, 7)
oldrow = CSRLIN
prtitle rmtitle$, points
LOCATE oldrow, 1

ELSEIF LEFT$(con$, 3) = "SAY" THEN
PRINT MID$(con$, 5)

ELSEIF LEFT$(con$, 4) = "ITEM" THEN
IF chkitem(MID$(con$, 6)) = 0 THEN
additem (MID$(con$, 6))
PRINT readline$(1)
ELSE
debug ("has item")
INPUT #1, bin$
PRINT readline$(1)
END IF

ELSEIF LEFT$(con$, 6) = "RMITEM" THEN
IF chkitem(MID$(con$, 8)) = 1 THEN
delitem (MID$(con$, 8))
PRINT readline$(1)
ELSE
PRINT "You don`t have that."
END IF

ELSEIF LEFT$(con$, 4) = "WAIT" THEN
PRINT "Press any key..."
SLEEP
a$ = INKEY$

ELSEIF LEFT$(con$, 7) = "CHKITEM" THEN
IF VAL(MID$(con$, 9, 1)) = 1 THEN check = 0
IF VAL(MID$(con$, 9, 1)) = 0 THEN check = 1
IF chkitem(MID$(con$, 11)) = check THEN
INPUT #1, bin$
END IF

END IF
con$ = readline$(1)
LOOP

END SUB

SUB loadgame (name$)
'ON ERROR GOTO notgame
lfile$ = "INT.TAI"
OPEN "./" + name$ + "/int.tai" FOR INPUT AS 1
debug "opened ./" + name$ + "/int.tai"
IF readline(1) = "[MAITAI]" THEN
PRINT "Game recognized. Loading..."
ELSE
PRINT "Game not recognized, quitting..."
END
END IF
longgamename$ = readline(1)
firstroom$ = readline(1)
chrname$ = readline(1)
maxpoint = VAL(readline(1))
OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 5
CLOSE 5
KILL "./" + gamename$ + "/inv.tai"
OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 5
CLOSE 5
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
IF rmerr = 1 THEN
rmerr = 0
GOTO loadback
END IF

lfile$ = room$ + ".RM"
debug "opening ./" + gamename$ + "/rooms/" + room$ + ".rm"
SLEEP
a$ = INKEY$
OPEN "./" + gamename$ + "/rooms/" + room$ + ".rm" FOR INPUT AS 1
IF readline(1) = "[MAITAI ROOM]" THEN debug ("room recognized")
rmtitle$ = readline(1)
debug "room title: " + rmtitle$
glbroom$ = room$
CLS
prtitle rmtitle$, points
SEEK 1, 1
look: DO UNTIL desc$ = "&DESC"
desc$ = readline$(1)
LOOP
contp: DO UNTIL desc$ = "%H"
desc$ = readline$(1)
IF LEFT$(desc$, 2) = "%P" THEN GOTO skip
IF desc$ = "%S" THEN GOTO pause
IF LEFT$(desc$, 2) = "%I" THEN GOTO item
IF desc$ <> "%H" THEN PRINT desc$
LOOP
PRINT

rmin: PRINT chrname$;
INPUT "> ", cmd$

IF UCASE$(cmd$) = "LOOK" THEN
GOTO look

ELSEIF UCASE$(cmd$) = "SAVE" THEN
PRINT "To save a game, type `SAVE` and the name (UP TO 8 CHARACTERS ONLY) of the savegame. If that savegame exists, IT WILL BE OVERWRITTEN."
PRINT
GOTO rmin

ELSEIF LEFT$(UCASE$(cmd$), 4) = "SAVE" THEN
savegame (MID$(UCASE$(cmd$), 6, 8))
PRINT
GOTO rmin

ELSEIF UCASE$(cmd$) = "LOAD" THEN
PRINT "To load a game, type `LOAD` and the name of the savegame."
PRINT
GOTO rmin

ELSEIF LEFT$(UCASE$(cmd$), 4) = "LOAD" THEN
loadsave (MID$(UCASE$(cmd$), 6, 8))
loadback: PRINT
GOTO rmin

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

skip: PRINT "Press any key to continue..."
SLEEP
a$ = INKEY$
CLOSE 1
CALL loadroom(MID$(desc$, 4))

pause: PRINT "Press any key to continue..."
SLEEP
a$ = INKEY$
GOTO contp

item: IF chkitem(MID$(desc$, 4)) = 0 THEN
GOTO contp
ELSE
INPUT #1, bin$
GOTO contp
END IF

END SUB

SUB loadsave (file$)
'ON ERROR GOTO error404
OPEN "./" + gamename$ + "/" + file$ + ".inv" FOR INPUT AS 2
KILL "./" + gamename$ + "/inv.tai"
OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 3
DO UNTIL EOF(2)
INPUT #2, lin$
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
debug ("loading ./" + gamename$ + "/" + file$ + ".sav")
OPEN "./" + gamename$ + "/" + file$ + ".sav" FOR INPUT AS 2
INPUT #2, points
debug STR$(points)
INPUT #2, ldroom$
debug ldroom$
CLOSE 2
CLOSE 1
loadroom ldroom$
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
'on ERROR GOTO brokenfile
in: INPUT #file, in$
IF LEFT$(in$, 1) = "#" THEN GOTO in
readline$ = in$
debug in$
END FUNCTION

SUB savegame (file$)
OPEN "./" + gamename$ + "/inv.tai" FOR INPUT AS 2
KILL "./" + gamename$ + "/" + file$ + ".inv"
OPEN "./" + gamename$ + "/" + file$ + ".inv" FOR APPEND AS 3
DO UNTIL EOF(2)
INPUT #2, lin$
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
debug ("saving ./" + gamename$ + "/" + file$ + ".sav")
OPEN "./" + gamename$ + "/" + file$ + ".sav" FOR APPEND AS 2
CLOSE 2
KILL "./" + gamename$ + "/" + file$ + ".sav"
OPEN "./" + gamename$ + "/" + file$ + ".sav" FOR APPEND AS 2
PRINT #2, STR$(points)
PRINT #2, glbroom$
CLOSE 2
PRINT "Game saved as " + file$ + "."
END SUB


