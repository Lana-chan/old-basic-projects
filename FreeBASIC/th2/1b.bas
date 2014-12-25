dim as ubyte a(20,15)
dim as integer b, c, d
if command(1) = "" then end
if command(2) = "" then end
screenres 20,15,32
dim shared as any ptr img
img = imagecreate(20,30)
bload command(1), img
put (0,0),img
for b = 0 to 14
    for c = 0 to 19
        if (point(c,b) and &h00FF0000)/&hFFFF >= 250 then:a(c,b) = 1
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 230 then:a(c,b) = 2
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 210 then:a(c,b) = 3
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 190 then:a(c,b) = 4
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 170 then:a(c,b) = 5
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 150 then:a(c,b) = 6
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 130 then:a(c,b) = 7
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 110 then:a(c,b) = 8
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 90 then:a(c,b) = 9
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 70 then:a(c,b) = 10
        endif
    next c
next b
open command(2) for binary as #1
for b = 0 to 14:for c = 0 to 19:d+=1:put #1,d,a(c,b):a(c,b)=0:next c: next b
close #1
cls
put (0,-15),img
for b = 0 to 14
    for c = 0 to 19
        if (point(c,b) and &h00FF0000)/&hFFFF >= 250 then:a(c,b) = 1
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 230 then:a(c,b) = 2
        elseif (point(c,b) and &h00FF0000)/&hFFFF >= 210 then:a(c,b) = 5
        endif
        if (point(c,b) and &h0000FF00)/&hFF >= 250 then:a(c,b) = 3
        elseif (point(c,b) and &h0000FF00)/&hFF >= 230 then:a(c,b) = 4
        elseif (point(c,b) and &h0000FF00)/&hFF >= 210 then:a(c,b) = 6
        elseif (point(c,b) and &h0000FF00)/&hFF >= 190 then:a(c,b) = 7
        endif
    next c
next b
open command(2) for binary as #1
for b = 0 to 14:for c = 0 to 19:d+=1:put #1,d,a(c,b):next c: next b
close #1