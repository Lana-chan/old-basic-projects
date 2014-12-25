'VisTAI v0.30b
'Copyright 2008 Electrokinesis Studios
'Do not distribute
DIM SHARED game AS STRING
DIM SHARED gfx AS STRING
DIM SHARED char AS STRING
DIM SHARED room AS STRING
DIM SHARED savedgame AS STRING
DIM SHARED rmtitle AS STRING
DIM SHARED maxpoints AS INTEGER
DIM SHARED points AS INTEGER
DIM SHARED inverr AS INTEGER
DIM SHARED saveerr AS INTEGER
DIM SHARED inv1 AS INTEGER
DIM SHARED actfail AS INTEGER
DIM SHARED steps AS INTEGER
DIM SHARED timfail AS INTEGER
DECLARE SUB loaddraw (file$)
DECLARE SUB loadroom (lroom$)
DECLARE SUB prtitle (title$)
DECLARE SUB additem (item$)
DECLARE SUB rmitem (item$)
DECLARE SUB addtimer (timstep, timer$)
DECLARE SUB findaction (action$, file)
DECLARE SUB Savegame (save$)
DECLARE SUB loadsave (save$)
DECLARE SUB distimer (timr$)
DECLARE SUB loadgame ()
DECLARE SUB ocls ()
DECLARE SUB chktimer ()
DECLARE FUNCTION chkitem (item$)
DECLARE FUNCTION readline$ (file)
SCREEN 12
CLS
VIEW PRINT 17 TO 30
loaddraw "welcome2"
PRINT "VisTAI v0.30b - Copyright Electrokinesis Studios"
load: INPUT "What game should I load? (`quit` to quit) ", game$
IF UCASE$(game$) = "QUIT" THEN END
IF game$ = "" THEN GOTO load
loadgame
INPUT "Game not recognized. Try again? (Y/N) ", try$
IF UCASE$(try$) = "Y" THEN GOTO load
END

nogame:
PRINT "Game " + game$ + " not found."
END

nogfx:
PRINT "Graphic " + gfx$ + " not found."
END

noroom:
PRINT "Room " + room$ + " not found."
END

noinv:
CLOSE 2
IF inv1 = 0 THEN PRINT "You have no items."
inverr = 1
RESUME NEXT

nosave:
PRINT "Savegame " + savedgame$ + " not found."
saveerr = 1
RESUME NEXT

distim:
timfail = 1
RESUME NEXT

SUB additem (item$)
OPEN "inv" FOR APPEND AS 2
PRINT #2, item$
CLOSE 2
END SUB

SUB addtimer (timstep, timer$)
OPEN "tim" FOR APPEND AS 2
finalstep = timstep + steps
IF LEN(LTRIM$(STR$(finalstep))) < 2 THEN fstep$ = "0" + LTRIM$(STR$(finalstep))
IF LEN(LTRIM$(STR$(finalstep))) = 2 THEN fstep$ = LTRIM$(STR$(finalstep))
PRINT #2, fstep$ + " " + timer$
CLOSE 2
END SUB

FUNCTION chkitem (item$)
ON ERROR GOTO distim
OPEN "inv" FOR INPUT AS 2
DO UNTIL EOF(2)
lin$ = readline$(2)
IF lin$ = item$ THEN GOTO has
LOOP
chkitem = 0
CLOSE 2
EXIT FUNCTION

has:
chkitem = 1
CLOSE 2
END FUNCTION

SUB chktimer
actfail = 0
ON ERROR GOTO distim
OPEN "tim" FOR INPUT AS 2
DO UNTIL EOF(2)
lin$ = readline$(2)
IF VAL(LEFT$(lin$, 2)) = steps THEN
IF MID$(lin$, 4, 1) = "$" THEN
OPEN "./" + game$ + "/act.tai" FOR INPUT AS 3
filenum = 3
ELSE
SEEK 1, 1
filenum = 1
END IF
DO
fin$ = readline(filenum)
IF fin$ = "[TIMER]" THEN
findaction "&" + MID$(lin$, 4), filenum
CLOSE 2
distimer MID$(lin$, 4)
IF actfail = 1 THEN GOTO notimer
END IF
LOOP UNTIL EOF(filenum)
IF filenum = 1 THEN SEEK 1, 1
IF filenum = 3 THEN CLOSE 3
END IF
LOOP
notimer:
CLOSE 2
END SUB

SUB distimer (timr$)
ON ERROR GOTO distim
timfail = 0
OPEN "tim" FOR INPUT AS 2
OPEN "tmptim" FOR OUTPUT AS 3
DO UNTIL EOF(2) = 1
lin$ = readline$(2)
IF timfail = 1 THEN GOTO enddis
IF UCASE$(timr$) = "ALL" THEN
IF MID$(lin$, 4, 1) = "$" THEN PRINT #3, lin$
ELSE
IF MID$(lin$, 4) <> timr$ THEN PRINT #3, lin$
END IF
LOOP
CLOSE 2
CLOSE 3
KILL "tim"
NAME "tmptim" AS "tim"
enddis:
END SUB

SUB findaction (action$, file)
DO UNTIL EOF(file)
IF readline(file) = action$ THEN
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
loadroom (MID$(con$, 6))

ELSEIF UCASE$(LEFT$(con$, 5)) = "SCORE" THEN
points = points + VAL(MID$(con$, 7))
oldrow = CSRLIN
prtitle rmtitle$
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
rmitem (MID$(con$, 8))
END IF

ELSEIF UCASE$(LEFT$(con$, 4)) = "WAIT" THEN
PRINT "Press any key..."
SLEEP
a$ = INKEY$

ELSEIF UCASE$(LEFT$(con$, 7)) = "CHKITEM" THEN
IF VAL(MID$(con$, 9, 1)) = 1 THEN check = 0
IF VAL(MID$(con$, 9, 1)) = 0 THEN check = 1
IF chkitem(MID$(con$, 11)) = check THEN
LINE INPUT #file, bin$
END IF

ELSEIF UCASE$(LEFT$(con$, 4)) = "LOSE" THEN
PRINT "You have lost the game in" + STR$(steps) + " steps and your final score is" + STR$(points) + " out of possible" + STR$(maxpoint) + "."
INPUT "Try again? (Y/N) ", tryagain$
CLOSE 1
IF UCASE$(tryagain$) = "Y" THEN loadgame
END

ELSEIF UCASE$(LEFT$(con$, 3)) = "WIN" THEN
PRINT "You have won the game in" + STR$(steps) + " steps and your final score is" + STR$(points) + " out of possible" + STR$(maxpoints) + "."
INPUT "Try again? (Y/N) ", tryagain$
CLOSE 1
IF UCASE$(tryagain$) = "Y" THEN loadgame
END

ELSEIF UCASE$(LEFT$(con$, 5)) = "TIMER" THEN
addtimer VAL(MID$(con$, 7, 2)), MID$(con$, 10)

ELSEIF UCASE$(LEFT$(con$, 8)) = "DISTIMER" THEN
distimer MID$(con$, 10)

ELSEIF UCASE$(LEFT$(con$, 8)) = "LOADDRAW" THEN
loaddraw "./" + game$ + "/gfx/" + MID$(con$, 10)

END IF
con$ = readline$(file)
LOOP

END SUB

SUB loaddraw (file$)
LINE (40, 0)-(602, 244), 0, BF
LINE (40, 0)-(602, 244), , B
gfx$ = file$
ON ERROR GOTO nogfx
OPEN file$ + ".gfx" FOR INPUT AS 5
DO UNTIL EOF(5)
INPUT #5, lin$
LINE (VAL(MID$(lin$, 1, 3)), VAL(MID$(lin$, 5, 3)))-(VAL(MID$(lin$, 9, 3)), VAL(MID$(lin$, 13, 3))), VAL(MID$(lin$, 17, 3))
LOOP
CLOSE 5
END SUB

SUB loadgame
ON ERROR GOTO nogame
points = 0
steps = 0
OPEN "inv" FOR OUTPUT AS 1
PRINT #1,
CLOSE 1
OPEN "tim" FOR OUTPUT AS 1
CLOSE 1
OPEN "./" + game$ + "/int.tai" FOR INPUT AS 1
lin$ = readline(1)
IF lin$ = "[VISTAI]" THEN
PRINT "Game recognized, loading..."
ELSE
EXIT SUB
END IF
longname$ = readline$(1)
firstroom$ = readline$(1)
char$ = readline$(1)
maxpoints = VAL(readline$(1))
PRINT "`" + longname$ + "` loaded successfully. Press any key..."
CLOSE 1
SLEEP
a$ = INKEY$
LINE (40, 0)-(602, 244), 0, BF
LINE (40, 0)-(602, 244), , B
VIEW PRINT 17 TO 30
loadroom firstroom$
END SUB

SUB loadroom (lroom$)
room$ = lroom$
ON ERROR GOTO noroom
OPEN "./" + game$ + "/rooms/" + lroom$ + ".rm" FOR INPUT AS 1
lin$ = readline$(1)
IF lin$ <> "[VISTAI ROOM]" THEN EXIT SUB
lin$ = readline$(1)
rmtitle$ = lin$
ocls
prtitle lin$

DO UNTIL EOF(1)
lin$ = readline$(1)
IF lin$ = "&DESC" THEN GOTO desc
LOOP
desc: DO UNTIL lin$ = "%H"
lin$ = readline$(1)
IF LEFT$(lin$, 2) = "%I" THEN
IF chkitem(MID$(lin$, 4)) = 1 THEN bin$ = readline$(1)
ELSEIF LEFT$(lin$, 2) = "%N" THEN
IF chkitem(MID$(lin$, 4)) = 0 THEN bin$ = readline$(1)
ELSEIF LEFT$(lin$, 2) = "%G" THEN
IF chkitem(MID$(lin$, 4)) = 0 THEN additem MID$(lin$, 4)
ELSEIF LEFT$(lin$, 2) = "%R" THEN
IF chkitem(MID$(lin$, 4)) = 1 THEN rmitem MID$(lin$, 4)
ELSEIF LEFT$(lin$, 2) = "%T" THEN
addtimer VAL(MID$(lin$, 4, 2)), MID$(lin$, 7)
ELSEIF LEFT$(lin$, 2) = "%P" THEN
PRINT "Press any key..."
SLEEP
a$ = INKEY$
CLOSE 1
loadroom MID$(lin$, 4)
ELSEIF LEFT$(lin$, 2) = "%S" THEN
PRINT "Press any key..."
SLEEP
a$ = INKEY$
ELSEIF LEFT$(lin$, 2) = "%D" THEN
loaddraw "./" + game$ + "/gfx/" + MID$(lin$, 4)
ELSEIF LEFT$(lin$, 2) <> "%H" THEN
PRINT lin$
END IF
LOOP

getcmd: PRINT
PRINT char$;
INPUT "> ", cmd$
steps = steps + 1
chktimer

cmd$ = UCASE$(cmd$)
IF cmd$ = "QUIT" THEN
KILL "inv"
KILL "tim"
END

ELSEIF UCASE$(cmd$) = "LOOK" THEN
GOTO look
steps = steps - 1

ELSEIF UCASE$(cmd$) = "SAVE" THEN
PRINT "To save a game, type `SAVE` and the name (UP TO 8 CHARACTERS ONLY) of the savegame. If that savegame exists, IT WILL BE OVERWRITTEN."
steps = steps - 1

ELSEIF LEFT$(UCASE$(cmd$), 4) = "SAVE" THEN
Savegame (MID$(UCASE$(cmd$), 6, 8))
ELSEIF UCASE$(cmd$) = "LOAD" THEN
PRINT "To load a game, type `LOAD` and the name of the savegame."
steps = steps - 1

ELSEIF LEFT$(UCASE$(cmd$), 4) = "LOAD" THEN
loadsave (MID$(UCASE$(cmd$), 6, 8))

ELSEIF UCASE$(cmd$) = "INV" THEN
ON ERROR GOTO distim
OPEN "inv" FOR INPUT AS 2
PRINT "You are carrying: ";
printinv: IF EOF(2) = 1 THEN GOTO endprint
LINE INPUT #2, lin$
IF LEFT$(lin$, 1) = "$" THEN GOTO checkeof
IF lin$ <> lastlin$ THEN
IF lastlin2$ = lin$ AND LEFT$(lin$, 1) = "$" THEN
lin$ = ""
GOTO endprint
END IF
IF morethan = 1 AND lastlin$ <> "" OR LEFT$(lastlin$, 1) <> "$" THEN PRINT ", ";
PRINT lin$;
END IF
checkeof: IF EOF(2) = 0 THEN
morethan = 1
lastlin2$ = lastlin$
lastlin$ = lin$
GOTO printinv
END IF
endprint: CLOSE 2
IF lin$ = "" THEN PRINT "Nothing";
PRINT "."
morethan = 0
lastlin$ = ""
steps = steps - 1

ELSEIF cmd$ = "" THEN
steps = steps - 1

ELSE
SEEK 1, 1
actfail = 0
DO
fin$ = readline(1)
IF fin$ = "[ACTION]" THEN
findaction "@" + UCASE$(cmd$), 1
IF actfail = 1 THEN
OPEN "./" + game$ + "/act.tai" FOR INPUT AS 2
findaction "@" + UCASE$(cmd$), 2
CLOSE 2
END IF
IF actfail = 2 THEN PRINT "I don`t know what `" + cmd$ + "` means."
actfail = 0
GOTO getcmd
END IF
LOOP UNTIL EOF(1)
SEEK 1, 1
END IF
GOTO getcmd

look: SEEK 1, 1
DO UNTIL EOF(1)
lin$ = readline$(1)
IF lin$ = "&DESC" THEN GOTO desc
LOOP
DO UNTIL lin$ = "%H"
lin$ = readline$(1)
IF LEFT$(lin$, 2) = "%I" THEN
IF chkitem(MID$(lin$, 4)) = 1 THEN bin$ = readline$(1)
ELSEIF LEFT$(lin$, 2) = "%N" THEN
IF chkitem(MID$(lin$, 4)) = 0 THEN bin$ = readline$(1)
ELSEIF LEFT$(lin$, 2) = "%G" THEN
ELSEIF LEFT$(lin$, 2) = "%R" THEN
ELSEIF LEFT$(lin$, 2) = "%T" THEN
ELSEIF LEFT$(lin$, 2) = "%S" THEN
PRINT "Press any key..."
SLEEP
a$ = INKEY$
ELSEIF LEFT$(lin$, 2) = "%D" THEN
ELSEIF LEFT$(lin$, 2) <> "%H" THEN
PRINT lin$
END IF
LOOP
GOTO getcmd

END SUB

SUB loadsave (save$)
saveerr = 0
ON ERROR GOTO nosave
savedgame$ = save$
OPEN "inv" FOR OUTPUT AS 3
OPEN "./" + game$ + "/saves/" + save$ + ".inv" FOR INPUT AS 2
DO UNTIL EOF(2)
lin$ = readline$(2)
IF saveerr = 1 THEN GOTO exitsave
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
OPEN "tim" FOR OUTPUT AS 3
OPEN "./" + game$ + "/saves/" + save$ + ".tim" FOR INPUT AS 2
DO UNTIL EOF(2)
lin$ = readline$(2)
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
OPEN "./" + game$ + "/saves/" + save$ + ".sav" FOR INPUT AS 2
IF saveerr = 1 THEN EXIT SUB
INPUT #2, points
INPUT #2, room$
INPUT #2, steps
CLOSE 2
IF saveerr <> 1 THEN
CLOSE 1
loadroom room$
END IF

exitsave:
END SUB

SUB ocls
FOR i = 1 TO 30
PRINT
NEXT i
VIEW PRINT 17 TO 30
LOCATE 17, 1
END SUB

SUB prtitle (title$)
VIEW PRINT 17 TO 30
COLOR 14
PRINT "                                                                                "
LOCATE 17, 1
PRINT " " + title$
endlen = 78 - LEN(STR$(points)) - LEN(STR$(maxpoints))
LOCATE 17, endlen
PRINT "|" + STR$(points) + "/" + LTRIM$(STR$(maxpoints)) + " "
VIEW PRINT 18 TO 30
COLOR 15
END SUB

FUNCTION readline$ (file)
in: LINE INPUT #file, in$
IF LEFT$(in$, 1) = "#" THEN GOTO in
readline$ = in$
END FUNCTION

SUB rmitem (item$)
OPEN "inv" FOR INPUT AS 2
OPEN "tmpinv" FOR OUTPUT AS 3
DO UNTIL EOF(2)
lin$ = readline$(2)
IF lin$ <> item$ THEN PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
KILL "inv"
NAME "tmpinv" AS "inv"
END SUB

SUB Savegame (save$)
OPEN "inv" FOR INPUT AS 2
OPEN "./" + game$ + "/saves/" + save$ + ".inv" FOR OUTPUT AS 3
DO UNTIL EOF(2)
lin$ = readline$(2)
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
OPEN "tim" FOR INPUT AS 2
OPEN "./" + game$ + "/saves/" + save$ + ".tim" FOR OUTPUT AS 3
DO UNTIL EOF(2)
lin$ = readline$(2)
PRINT #3, lin$
LOOP
CLOSE 2
CLOSE 3
OPEN "./" + game$ + "/saves/" + save$ + ".sav" FOR OUTPUT AS 2
PRINT #2, points
PRINT #2, room$
PRINT #2, steps
CLOSE 2
END SUB

