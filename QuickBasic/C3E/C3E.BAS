DECLARE SUB cmd ()
DECLARE SUB sbemail ()
DECLARE SUB splash ()
SCREEN 7
splash

SUB cmd
COLOR 15, 0
INPUT "a>", prmpt$

IF LCASE$(prmpt$) = "strongbad_email.exe" THEN
sbemail

ELSEIF LCASE$(prmpt$) = "quit" OR LCASE$(prmpt$) = "exit" OR LCASE$(prmpt$) = "end" THEN
END

ELSEIF LCASE$(prmpt$) = "" THEN
cmd

ELSE
PRINT "Bad command or filename."
PRINT
cmd
END IF

END SUB

SUB sbemail
RANDOMIZE TIMER
email = INT(RND * 57 + 41)
OPEN "emails.c3e" FOR INPUT AS 1
INPUT #1, lin$
IF lin$ = "["; email ;"]" THEN
DO
INPUT #1, lin$
PRINT lin$
LOOP UNTIL lin$ = "[end]"
CLOSE #1
PRINT
SLEEP
a$ = INKEY$
cmd
END SUB

SUB splash
COLOR 15, 1
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT "         ллллл    ллллл    ллллл"
PRINT
PRINT "        лл   лл  лл   лл  лл"
PRINT
PRINT "            лл    ллллл   лллллл"
PRINT
PRINT "        лл   лл  лл   лл  лл   лл"
PRINT
PRINT "         ллллл    ллллл    ллллл"
PRINT
PRINT
PRINT
PRINT "               version 1.5"
PLAY "l12<< f p50 a a#"
SLEEP 1
a$ = INKEY$
CLS
cmd
END SUB

