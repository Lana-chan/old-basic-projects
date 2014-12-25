dim as ubyte a(8,8,3)
dim as integer b, c, d
if command(1) = "" then end
if command(2) = "" then end
if command(3) = "" then:d = 0:else:d=val(command(3))*192:endif
screenres 8,8,32
dim shared as any ptr img
img = imagecreate(8,8)
bload command(1), img
put (0,0),img
for b = 0 to 7
    for c = 0 to 7
        a(c,b,0) = (point(c,b) and &h00FF0000)/&hFFFF
        a(c,b,1) = (point(c,b) and &h0000FF00)/&hFF
        if (point(c,b) and &h0000FF00)/&hFF > 255 then a(c,b,1) = 255
        a(c,b,2) = (point(c,b) and &h000000FF)
    next c
next b
open command(2) for binary as #1
for b = 0 to 7:for c = 0 to 7:d+=1:put #1,d,a(c,b,0):next c: next b
for b = 0 to 7:for c = 0 to 7:d+=1:put #1,d,a(c,b,1):next c: next b
for b = 0 to 7:for c = 0 to 7:d+=1:put #1,d,a(c,b,2):next c: next b
close #1