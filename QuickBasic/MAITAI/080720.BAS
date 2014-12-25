'MaiTAI v1.10b
'Copyright 2008 Electrokinesis Studios
'Do not distribute
'init
DECLARE SUB loadroom (room$)
DECLARE SUB loadgame (name$)
DECLARE SUB debug (text$)
DECLARE SUB prtitle (rmtitle$, points%)
DECLARE SUB findaction (action$, file)
DECLARE SUB additem (item$)
DECLARE SUB delitem (item$)
DECLARE SUB savegame (file$)
DECLARE SUB loadsave (file$)
DECLARE SUB addtimer (stps, timr$)
DECLARE SUB distimer (timr$)
DECLARE SUB chktimer ()
DECLARE FUNCTION chkitem (item$)
DECLARE FUNCTION readline$ (file)
DIM SHARED lfile AS STRING
DIM SHARED gamename AS STRING
DIM SHARED chrname AS STRING
DIM SHARED rmtitle AS STRING
DIM SHARED glbroom AS STRING
DIM SHARED maxpoint AS INTEGER
DIM SHARED points AS INTEGER
DIM SHARED oeof AS INTEGER
DIM SHARED oeof2 AS INTEGER
DIM SHARED oeof3 AS INTEGER
DIM SHARED oeof4 AS INTEGER
DIM SHARED rmerr AS INTEGER
DIM SHARED actfail AS INTEGER
DIM SHARED steps AS INTEGER
points = 0
steps = 0
CLS
PRINT "Mai-TAI v1.10b build 200708d - Copyright 2008 Electrokinesis Studios"
INPUT "What game should I load? (`quit` to exit) ", gamename$
IF gamename$ = "quit" THEN END
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
oeof = 1
oeof2 = 1
oeof3 = 1
oeof4 = oeof4 + 1
RESUME NEXT
END IF
debug STR$(ERR)
PRINT lfile$ + " file corrupted or not found."
PRINT "Press any key to exit..."
SLEEP
a$ = INKEY$
END

'noinv:
'IF ERR = 62 THEN
'debug ("EOF")
'oeof = 1
'oeof2 = oeof2 + 1
'SEEK 2, 1
'RESUME NEXT
'END IF
'debug ("inventory not found")
'CLOSE 2
'OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 4
'CLOSE 4
'inv = 1
'RESUME NEXT

error404:
PRINT "Savegame not found or corrupt."
rmerr = 1
SEEK 1, 1
loadroom room$

SUB additem (item$)
OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 2
PRINT #2, item$
CLOSE 2
END SUB

SUB addtimer (stps, timr$)
OPEN "./" + gamename$ + "/tim.tai" FOR INPUT AS 2
DO UNTIL oeof = 1
lin$ = readline(2)
IF MID$(lin$, 4) = timr$ THEN GOTO gottimr
LOOP
CLOSE 2
OPEN "./" + gamename$ + "/tim.tai" FOR APPEND AS 2
stps2 = stps + steps
debug STR$(stps) + STR$(steps) + STR$(stps2) + STR$(LEN(MID$(STR$(stps2), 2)))
IF LEN(MID$(STR$(stps2), 2)) = 1 THEN stps3$ = "0" + MID$(STR$(stps2), 2)
IF LEN(MID$(STR$(stps2), 2)) > 1 THEN stps3$ = MID$(STR$(stps2), 2)
PRINT #2, stps3$ + " " + timr$
CLOSE 2
EXIT SUB

gottimr:
debug ("has timer")
oeof = 0
CLOSE 2
END SUB

FUNCTION chkitem (item$)
'debug "chkitem " + item$
oeof4 = 0
ON ERROR GOTO brokenfile
OPEN "./" + gamename$ + "/inv.tai" FOR INPUT AS 2
SEEK 2, 1
DO
INPUT #2, lin$
debug lin$
IF lin$ = item$ THEN GOTO got
LOOP UNTIL oeof4 >= 2
debug "no item"
chkitem = 0
oeof4 = 0
CLOSE 2
EXIT FUNCTION

got:
debug "has item"
chkitem = 1
oeof4 = 0
CLOSE 2
END FUNCTION

SUB chktimer
OPEN "./" + gamename$ + "/tim.tai" FOR INPUT AS 2
oeof = 0
DO UNTIL oeof = 1
lin$ = readline(2)
IF VAL(LEFT$(lin$, 2)) = steps THEN
IF MID$(lin$, 4, 1) = "$" THEN
OPEN "./" + gamename$ + "/act.tai" FOR INPUT AS 3
filenum = 3
ELSE
SEEK 1, 1
filenum = 1
END IF
oeof2 = 0
DO UNTIL lin2$ = "[TIMER]"
lin2$ = readline$(filenum)
IF oeof2 = 1 THEN GOTO notimer
LOOP
findaction "&" + MID$(lin$, 4), filenum
CLOSE 2
distimer MID$(lin$, 4)
OPEN "./" + gamename$ + "/tim.tai" FOR INPUT AS 2
END IF
LOOP
IF filenum = 3 THEN CLOSE 3
CLOSE 2
EXIT SUB

notimer:
debug "There was an error while trying to find timers in room '" + glbroom$ + "'."
END SUB

SUB debug (text$)
bdebug = 0
tdebug$ = "DEBUG: "
IF bdebug = 1 THEN PRINT tdebug$ + text$
END SUB

SUB delitem (item$)
OPEN "./" + gamename$ + "/inv.tai" FOR INPUT AS 2
OPEN "tmpinv" FOR APPEND AS 3
DO UNTIL EOF(2)
lin$ = readline(2)
IF lin$ <> item$ THEN PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
KILL "./" + gamename$ + "/inv.tai"
NAME "tmpinv" AS "./" + gamename$ + "/inv.tai"
debug ("item " + item$ + " deleted.")
END SUB

SUB distimer (timr$)
lfile$ = "tim.tai"
OPEN "./" + gamename$ + "/tim.tai" FOR INPUT AS 4
OPEN "tmptim" FOR APPEND AS 5
oeof3 = 0
DO UNTIL oeof3 = 1
lin$ = readline(4)
IF UCASE$(timr$) = "ALL" THEN
IF MID$(lin$, 4, 1) = "$" THEN PRINT #5, lin$
ELSE
IF MID$(lin$, 4) <> timr$ THEN PRINT #5, lin$
END IF
LOOP
CLOSE 4
CLOSE 5
KILL "./" + gamename$ + "/tim.tai"
NAME "tmptim" AS "./" + gamename$ + "/tim.tai"
debug ("timer " + timr$ + " deleted.")
END SUB

SUB findaction (action$, file)
DO UNTIL EOF(file)
IF readline(file) = action$ THEN
debug ("action " + action$ + " found")
GOTO getstatement
con$ = readline(file)
END IF
LOOP

actfail = actfail + 1
EXIT SUB

getstatement:
DO UNTIL con$ = "END"

IF UCASE$(LEFT$(con$, 4)) = "GOTO" THEN
CLOSE 1
distimer "all"
CALL loadroom(MID$(con$, 6))

ELSEIF UCASE$(LEFT$(con$, 5)) = "SCORE" THEN
points = points + VAL(MID$(con$, 7))
oldrow = CSRLIN
prtitle rmtitle$, points
LOCATE oldrow, 1

ELSEIF UCASE$(LEFT$(con$, 3)) = "SAY" THEN
PRINT MID$(con$, 5)

ELSEIF UCASE$(LEFT$(con$, 4)) = "ITEM" THEN
IF chkitem(MID$(con$, 6)) = 0 THEN
additem (MID$(con$, 6))
PRINT readline$(file)
ELSE
bin$ = readline$(file)
PRINT readline$(file)
END IF

ELSEIF UCASE$(LEFT$(con$, 5)) = "SITEM" THEN
IF chkitem(MID$(con$, 7)) = 0 THEN additem (MID$(con$, 7))

ELSEIF UCASE$(LEFT$(con$, 6)) = "RMITEM" THEN
IF chkitem(MID$(con$, 8)) = 1 THEN
delitem (MID$(con$, 8))
END IF

ELSEIF UCASE$(LEFT$(con$, 4)) = "WAIT" THEN
PRINT "Press any key..."
SLEEP
a$ = INKEY$

ELSEIF UCASE$(LEFT$(con$, 7)) = "CHKITEM" THEN
debug "yeah it`s a chkitem"
IF VAL(MID$(con$, 9, 1)) = 1 THEN check = 0
IF VAL(MID$(con$, 9, 1)) = 0 THEN check = 1
IF chkitem(MID$(con$, 11)) = check THEN
debug "this should work, but guess what, IT DOESN`T!"
LINE INPUT #file, bin$
END IF

ELSEIF UCASE$(LEFT$(con$, 4)) = "LOSE" THEN
PRINT "You have lost the game in" + STR$(steps) + " steps and your final score is" + STR$(points) + " out of possible" + STR$(maxpoint) + "."
INPUT "Try again? (Y/N) ", tryagain$
CLOSE 1
IF UCASE$(tryagain$) = "Y" THEN loadgame gamename$
END

ELSEIF UCASE$(LEFT$(con$, 3)) = "WIN" THEN
PRINT "You have won the game in" + STR$(steps) + " steps and your final score is" + STR$(points) + " out of possible" + STR$(maxpoints) + "."
INPUT "Try again? (Y/N) ", tryagain$
CLOSE 1
IF UCASE$(tryagain$) = "Y" THEN loadgame gamename$
END

ELSEIF UCASE$(LEFT$(con$, 5)) = "TIMER" THEN
addtimer VAL(MID$(con$, 7, 2)), MID$(con$, 10)

ELSEIF UCASE$(LEFT$(con$, 8)) = "DISTIMER" THEN
distimer MID$(con$, 10)

END IF
con$ = readline$(file)
LOOP

END SUB

SUB loadgame (name$)
ON ERROR GOTO notgame
lfile$ = "INT.TAI"
redo: OPEN "./" + name$ + "/int.tai" FOR INPUT AS 1
debug "opened ./" + name$ + "/int.tai"
IF readline(1) = "[MAITAI]" THEN
PRINT "Game recognized. Loading..."
ELSE
CLOSE 1
PRINT "Game not recognized, quitting..."
END
END IF
longgamename$ = readline(1)
firstroom$ = readline(1)
chrname$ = readline(1)
maxpoint = VAL(readline(1))
steps = 0
DO
IF FREEFILE > 2 THEN CLOSE FREEFILE - 1
LOOP UNTIL FREEFILE = 2
OPEN "./" + gamename$ + "/inv.tai" FOR OUTPUT AS 5
CLOSE 5
OPEN "./" + gamename$ + "/tim.tai" FOR OUTPUT AS 5
CLOSE 5
debug "game name: " + longgamename$
debug "first room to run: " + firstroom$
debug "charater's name: " + chrname$
debug "maximum points:" + STR$(maxpoint)
CLOSE 1
debug "file closed"
PRINT "`" + longgamename$ + "` loaded successfully."
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
'SLEEP
'a$ = INKEY$
OPEN "./" + gamename$ + "/rooms/" + room$ + ".rm" FOR INPUT AS 1
IF readline(1) <> "[MAITAI ROOM]" THEN
PRINT "Room `" + room$ + "` not recognized as a MaiTAI room. Quitting..."
END
END IF
rmtitle$ = readline(1)
debug "room title: " + rmtitle$
glbroom$ = room$
CLS
prtitle rmtitle$, points
look: SEEK 1, 1
DO UNTIL desc$ = "&DESC"
desc$ = readline$(1)
LOOP
contp: DO UNTIL desc$ = "%H"
desc$ = readline$(1)
IF LEFT$(desc$, 2) = "%P" THEN GOTO skip
IF desc$ = "%S" THEN GOTO pause
IF LEFT$(desc$, 2) = "%I" THEN GOTO item
IF LEFT$(desc$, 2) = "%N" THEN GOTO hasitem
IF LEFT$(desc$, 2) = "%G" THEN GOTO getitem
IF LEFT$(desc$, 2) = "%T" THEN GOTO gtimer
IF desc$ <> "%H" THEN PRINT desc$
LOOP
PRINT

rmin: PRINT chrname$;
LINE INPUT "> ", cmd$
steps = steps + 1
chktimer

IF UCASE$(cmd$) = "LOOK" THEN
'GOTO look

ELSEIF UCASE$(cmd$) = "SAVE" THEN
PRINT "To save a game, type `SAVE` and the name (UP TO 8 CHARACTERS ONLY) of the savegame. If that savegame exists, IT WILL BE OVERWRITTEN."
PRINT
'GOTO rmin

ELSEIF LEFT$(UCASE$(cmd$), 4) = "SAVE" THEN
savegame (MID$(UCASE$(cmd$), 6, 8))
PRINT
'GOTO rmin

ELSEIF UCASE$(cmd$) = "LOAD" THEN
PRINT "To load a game, type `LOAD` and the name of the savegame."
PRINT
'GOTO rmin

ELSEIF LEFT$(UCASE$(cmd$), 4) = "LOAD" THEN
loadsave (MID$(UCASE$(cmd$), 6, 8))
loadback: PRINT
'GOTO rmin

ELSEIF UCASE$(cmd$) = "QUIT" THEN
debug "deleting temp files"
KILL "./" + gamename$ + "/inv.tai"
KILL "./" + gamename$ + "/tim.tai"
END

ELSEIF UCASE$(cmd$) = "INV" THEN
oeof = 0
lfile$ = "INV.TAI"
OPEN "./" + gamename$ + "/inv.tai" FOR INPUT AS 2
PRINT "You are carrying: ";
printinv: IF oeof = 1 THEN GOTO endprint
LINE INPUT #2, lin$
IF LEFT$(lin$, 1) = "$" THEN GOTO printinv
IF lin$ <> lastlin$ THEN
IF morethan = 1 THEN PRINT ", ";
PRINT lin$;
END IF
IF oeof = 0 THEN
morethan = 1
lastlin$ = lin$
GOTO printinv
END IF
endprint: CLOSE 2
PRINT "."
PRINT
oeof = 0
morethan = 0
lastlin$ = ""
'GOTO rmin

ELSEIF cmd$ = "" THEN
steps = steps - 1
'GOTO rmin

ELSE
SEEK 1, 1
DO
fin$ = readline(1)
IF fin$ = "[ACTION]" THEN
debug ("actions found")
lfile$ = room$ + ".RM"
findaction "@" + UCASE$(cmd$), 1
IF actfail = 1 THEN
lfile$ = "ACT.TAI"
OPEN "./" + gamename$ + "/act.tai" FOR INPUT AS 5
findaction "@" + UCASE$(cmd$), 5
CLOSE 5
END IF
IF actfail = 2 THEN PRINT "I don`t know what `" + cmd$ + "` means."
actfail = 0
PRINT
GOTO rmin
END IF
LOOP UNTIL EOF(1)
SEEK 1, 1
debug ("actions not found")
END IF

GOTO rmin

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
bin$ = readline(1)
GOTO contp
END IF

hasitem: IF chkitem(MID$(desc$, 4)) = 1 THEN
GOTO contp
ELSE
bin$ = readline(1)
GOTO contp
END IF

getitem: IF chkitem(MID$(desc$, 4)) = 0 THEN additem MID$(desc$, 4)
GOTO contp

gtimer: addtimer VAL(MID$(desc$, 4, 2)), MID$(desc$, 7)
GOTO contp
END SUB

SUB loadsave (file$)
ON ERROR GOTO error404
OPEN "./" + gamename$ + "/SAVES/" + file$ + ".inv" FOR INPUT AS 2
KILL "./" + gamename$ + "/inv.tai"
OPEN "./" + gamename$ + "/inv.tai" FOR APPEND AS 3
oeof = 0
DO UNTIL oeof
lin$ = readline$(2)
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
debug "the second one is shit"
OPEN "./" + gamename$ + "/SAVES/" + file$ + ".tim" FOR INPUT AS 2
KILL "./" + gamename$ + "/tim.tai"
OPEN "./" + gamename$ + "/tim.tai" FOR APPEND AS 3
oeof = 0
DO UNTIL oeof
lin$ = readline$(2)
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
debug ("loading ./" + gamename$ + "/SAVES/" + file$ + ".sav")
OPEN "./" + gamename$ + "/SAVES/" + file$ + ".sav" FOR INPUT AS 2
INPUT #2, points
debug STR$(points)
INPUT #2, ldroom$
debug ldroom$
INPUT #2, steps
debug STR$(steps)
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
ON ERROR GOTO brokenfile
in: LINE INPUT #file, in$
IF LEFT$(in$, 1) = "#" THEN GOTO in
readline$ = in$
debug in$
END FUNCTION

SUB savegame (file$)
OPEN "./" + gamename$ + "/inv.tai" FOR INPUT AS 2
OPEN "./" + gamename$ + "/SAVES/" + file$ + ".inv" FOR OUTPUT AS 3
DO UNTIL EOF(2)
LINE INPUT #2, lin$
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
OPEN "./" + gamename$ + "/tim.tai" FOR INPUT AS 2
OPEN "./" + gamename$ + "/SAVES/" + file$ + ".tim" FOR OUTPUT AS 3
DO UNTIL EOF(2)
LINE INPUT #2, lin$
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
debug ("saving ./" + gamename$ + "/" + file$ + ".sav")
OPEN "./" + gamename$ + "/SAVES/" + file$ + ".sav" FOR OUTPUT AS 2
PRINT #2, STR$(points)
PRINT #2, glbroom$
PRINT #2, steps
CLOSE 2
PRINT "Game saved as " + file$ + "."
END SUB

