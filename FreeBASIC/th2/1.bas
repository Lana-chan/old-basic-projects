dim as ubyte a(16,16,3)
dim as integer b, c, d
if command(1) = "" then end
if command(2) = "" then end
if command(3) = "" then:d = 0:else:d=val(command(3))*768:endif
screenres 16,16,32
dim shared as any ptr img
img = imagecreate(16,16)
bload command(1), img
put (0,0),img
for b = 0 to 15
    for c = 0 to 15
        a(c,b,0) = (point(c,b) and &h00FF0000)/&hFFFF
        a(c,b,1) = (point(c,b) and &h0000FF00)/&hFF
        if (point(c,b) and &h0000FF00)/&hFF > 255 then a(c,b,1) = 255
        a(c,b,2) = (point(c,b) and &h000000FF)
    next c
next b
open command(2) for binary as #1
for b = 0 to 15:for c = 0 to 15:d+=1:put #1,d,a(c,b,0):next c: next b
for b = 0 to 15:for c = 0 to 15:d+=1:put #1,d,a(c,b,1):next c: next b
for b = 0 to 15:for c = 0 to 15:d+=1:put #1,d,a(c,b,2):next c: next b
close #1