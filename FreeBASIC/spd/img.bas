#include "fbgfx.bi"
'GmEngine v0.10
DECLARE SUB drawtile (tile as string, x as integer, y as integer, h as integer, w as integer)
dim as integer x, y, scale
SCREEN 13
x = 150
y = 50
scale = 32
OPEN "tile.til" FOR INPUT AS 1
loop1:
sleep 5
CLS
drawtile "surfguy", x, y, scale, scale
drawtile "surfguy2", x, y + scale, scale, scale
loop2:
IF multikey(fb.sc_W) THEN
y = y - 5
GOTO loop1
ELSEIF multikey(fb.sc_S) THEN
y = y + 5
GOTO loop1
ELSEIF multikey(fb.sc_A) THEN
x = x - 5
GOTO loop1
ELSEIF multikey(fb.sc_D) THEN
x = x + 5
GOTO loop1
ELSEIF multikey(fb.sc_R) THEN
scale = scale + 1
GOTO loop1
ELSEIF multikey(fb.sc_F) THEN
scale = scale - 1
GOTO loop1
ELSEIF multikey(fb.sc_Q) THEN
CLOSE 1
END
END IF
GOTO loop2

SUB drawtile (tile as string, x as integer, y as integer, h as integer, w as integer)
dim as string in
dim as integer i, let1, let2, let3, let4, let5, let6, let7, let8, let9, let10, let11, let12, let13, let14, let15, let16
SEEK 1, 1
DO UNTIL EOF(1)
INPUT #1, in
IF in = tile + ":" THEN GOTO drawit
LOOP
END
drawit:
FOR i = 1 TO 16 STEP 1
INPUT #1, in
let1 = VAL(MID(in, 1, 3)): let2 = VAL(MID(in, 5, 3)): let3 = VAL(MID(in, 9, 3)): let4 = VAL(MID(in, 13, 3)): let5 = VAL(MID(in, 17, 3)): let6 = VAL(MID(in, 21, 3)): let7 = VAL(MID(in, 25, 3)): let8 = VAL(MID(in, 29, 3))
let9 = VAL(MID(in, 33, 3)): let10 = VAL(MID(in, 37, 3)): let11 = VAL(MID(in, 41, 3)): let12 = VAL(MID(in, 45, 3)): let13 = VAL(MID(in, 49, 3)): let14 = VAL(MID(in, 53, 3)): let15 = VAL(MID(in, 57, 3)): let16 = VAL(MID(in, 61, 3))
IF let1 > 0 AND let1 < 256 THEN LINE (x + (w / 16) * 1, y + (h / 16) * i)-((x + (w / 16) * 2) - 1, y + (h / 16) * (i + 1) - 1), let1, BF
IF let2 > 0 AND let2 < 256 THEN LINE (x + (w / 16) * 2, y + (h / 16) * i)-((x + (w / 16) * 3) - 1, y + (h / 16) * (i + 1) - 1), let2, BF
IF let3 > 0 AND let3 < 256 THEN LINE (x + (w / 16) * 3, y + (h / 16) * i)-((x + (w / 16) * 4) - 1, y + (h / 16) * (i + 1) - 1), let3, BF
IF let4 > 0 AND let4 < 256 THEN LINE (x + (w / 16) * 4, y + (h / 16) * i)-((x + (w / 16) * 5) - 1, y + (h / 16) * (i + 1) - 1), let4, BF
IF let5 > 0 AND let5 < 256 THEN LINE (x + (w / 16) * 5, y + (h / 16) * i)-((x + (w / 16) * 6) - 1, y + (h / 16) * (i + 1) - 1), let5, BF
IF let6 > 0 AND let6 < 256 THEN LINE (x + (w / 16) * 6, y + (h / 16) * i)-((x + (w / 16) * 7) - 1, y + (h / 16) * (i + 1) - 1), let6, BF
IF let7 > 0 AND let7 < 256 THEN LINE (x + (w / 16) * 7, y + (h / 16) * i)-((x + (w / 16) * 8) - 1, y + (h / 16) * (i + 1) - 1), let7, BF
IF let8 > 0 AND let8 < 256 THEN LINE (x + (w / 16) * 8, y + (h / 16) * i)-((x + (w / 16) * 9) - 1, y + (h / 16) * (i + 1) - 1), let8, BF
IF let9 > 0 AND let9 < 256 THEN LINE (x + (w / 16) * 9, y + (h / 16) * i)-((x + (w / 16) * 10) - 1, y + (h / 16) * (i + 1) - 1), let9, BF
IF let10 > 0 AND let10 < 256 THEN LINE (x + (w / 16) * 10, y + (h / 16) * i)-((x + (w / 16) * 11) - 1, y + (h / 16) * (i + 1) - 1), let10, BF
IF let11 > 0 AND let11 < 256 THEN LINE (x + (w / 16) * 11, y + (h / 16) * i)-((x + (w / 16) * 12) - 1, y + (h / 16) * (i + 1) - 1), let11, BF
IF let12 > 0 AND let12 < 256 THEN LINE (x + (w / 16) * 12, y + (h / 16) * i)-((x + (w / 16) * 13) - 1, y + (h / 16) * (i + 1) - 1), let12, BF
IF let13 > 0 AND let13 < 256 THEN LINE (x + (w / 16) * 13, y + (h / 16) * i)-((x + (w / 16) * 14) - 1, y + (h / 16) * (i + 1) - 1), let13, BF
IF let14 > 0 AND let14 < 256 THEN LINE (x + (w / 16) * 14, y + (h / 16) * i)-((x + (w / 16) * 15) - 1, y + (h / 16) * (i + 1) - 1), let14, BF
IF let15 > 0 AND let15 < 256 THEN LINE (x + (w / 16) * 15, y + (h / 16) * i)-((x + (w / 16) * 16) - 1, y + (h / 16) * (i + 1) - 1), let15, BF
IF let16 > 0 AND let16 < 256 THEN LINE (x + (w / 16) * 16, y + (h / 16) * i)-((x + (w / 16) * 17) - 1, y + (h / 16) * (i + 1) - 1), let16, BF
NEXT i
END SUB

