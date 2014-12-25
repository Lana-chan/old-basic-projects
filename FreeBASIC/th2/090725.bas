#include "fbgfx.bi"
declare SUB drawtile (tile() as ubyte, x as double, y as double, h as double, w as double)
declare sub loadimage (file as string, b as integer, tile() as ubyte)
type object
    x as integer
    y as integer
    sx as double
    sy as double
    d as integer
    i(16,16,3) as ubyte
end type
type image
    i(16,16,3) as ubyte
end type

dim as object char
dim as image floor1, floor2, ladder, char2, char3, char4
dim as integer sw = 960, sh = 720, x, y, map(20,15)
dim as double scw, sch
screenres sw,sh,16
scw = sw/320
sch = sh/240

loadimage ".\gfx\char.abn",0,char.i()
loadimage ".\gfx\char.abn",1,char2.i()
loadimage ".\gfx\char.abn",2,char3.i()
loadimage ".\gfx\char.abn",3,char4.i()
loadimage ".\gfx\tiles.abn",0,floor1.i()
loadimage ".\gfx\tiles.abn",1,floor2.i()
loadimage ".\gfx\tiles.abn",2,ladder.i()
for x = 0 to 19:map(x,12)=1:next x
for x = 0 to 19:map(x,13)=2:next x
for x = 0 to 19:map(x,14)=2:next x
map(15,11)=3:map(15,10)=3:map(15,9)=3
char.x = 16:char.y = 16

do
screenlock
cls
line (0,0)-(sw,sh),rgb(130,80,0),BF
for y = 0 to 14:for x = 0 to 19
    select case map(x,y)
    case 1:drawtile floor1.i(), x*16*scw, y*16*sch, scw, sch
    case 2:drawtile floor2.i(), x*16*scw, y*16*sch, scw, sch
    case 3:drawtile ladder.i(), x*16*scw, y*16*sch, scw, sch
    end select
next x:next y
char.x+=char.sx:char.y+=char.sy
drawtile char.i(), char.x*scw, char.y*sch, scw, sch
if multikey(fb.sc_left) then:char.sx-=0.1:drawtile char3.i(), char.x*scw, (char.y+16)*sch, scw, sch:endif
if multikey(fb.sc_right) then:char.sx+=0.1:drawtile char4.i(), char.x*scw, (char.y+16)*sch, scw, sch:endif
if not (multikey(fb.sc_left) or multikey(fb.sc_right)) then
    drawtile char2.i(), char.x*scw, (char.y+16)*sch, scw, sch
    if char.sx>0 then char.sx-=0.1
    if char.sx<0 then char.sx+=0.1
endif
if multikey(fb.sc_escape) then end
screenunlock
sleep 5
loop

SUB drawtile (tile() as ubyte, x as double, y as double, h as double, w as double)
    dim as integer n1, n2
    FOR n1 = 0 TO 15:for n2 = 0 to 15
        if not (tile(n2,n1,0) = 255 and tile(n2,n1,1) = 0 and tile(n2,n1,2) = 255) then
        line (x+(n2*w),y+(n1*h))-(x+(n2*w)+w-1,y+(n1*h)+h-1),rgb(tile(n2,n1,0),tile(n2,n1,1),tile(n2,n1,2)),BF:endif
    next n2:NEXT n1
END SUB

sub loadimage (file as string, b as integer, tile() as ubyte)
    dim as integer x, y, z
    z = b*768
    open file for binary access read as #1
        for y = 0 to 15:for x = 0 to 15:z+=1:get #1,z,tile(x,y,0):next x:next y
        for y = 0 to 15:for x = 0 to 15:z+=1:get #1,z,tile(x,y,1):next x:next y
        for y = 0 to 15:for x = 0 to 15:z+=1:get #1,z,tile(x,y,2):next x:next y
    close #1
end sub
