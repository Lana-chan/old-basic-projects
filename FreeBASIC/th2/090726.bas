#include "fbgfx.bi"
declare function collide(x as integer, y as integer) as integer
declare function climb(x as integer, y as integer) as integer
declare sub drawtile (tile() as ubyte, x as double, y as double, w as double, h as double, d as integer)
declare sub loadimage (file as string, b as integer, tile() as ubyte)
type object
    x as double
    y as double
    sx as double
    sy as double
    d as integer
    st as integer
    cy as integer
    ac as double
    da as double
    ma as integer
    jmp as integer
    i(16,16,3) as ubyte
end type
type image
    i(16,16,3) as ubyte
end type

dim as object char
dim as image floor1, floor2, ladder, char2, char3, char4
dim as integer sw, sh, x, y
dim shared as integer map(20,15)
dim as double scw, sch, tim, cycle, wlk
dim as string binn
const grav=0.2
boot:
open "config.ini" for input as 1
if eof(1) then
    close 1
    open "config.ini" for output as 1
    print #1,"# Treasure Hunt 2 config file"
    print #1,"# Do not edit this file if you don't know what you're doing"
    print #1,"# --------------"
    print #1,"# Treasure Hunt 2 (c) 2009 Electrokinesis Studios"
    print #1,"# --------------"
    print #1,"# Screen resolution"
    print #1,"res=640x480"
    print #1,"# Timer"
    print #1,"tim=10"
    close 1
    goto boot
endif
do until left(binn,4)="res=":input #1, binn:loop
for x=5 to len(binn)
    if mid(binn,x,1)="x" then y=x
next x
sw=val(mid(binn,5,y-5))
sh=val(mid(binn,y+1,len(binn)-y+1))
do until left(binn,4)="tim=":input #1, binn:loop
tim=val(mid(binn,5,len(binn)-4))
close 1
screenres sw,sh,16
windowtitle "Treasure Hunt 2"
scw = sw/320
sch = sh/240

loadimage ".\gfx\char.abn",0,char.i()
loadimage ".\gfx\char.abn",1,char2.i()
loadimage ".\gfx\char.abn",2,char3.i()
loadimage ".\gfx\char.abn",3,char4.i()
loadimage ".\gfx\tiles.abn",0,floor1.i()
loadimage ".\gfx\tiles.abn",1,floor2.i()
loadimage ".\gfx\tiles.abn",2,ladder.i()
for x = 0 to 19:map(x,0)=2:map(x,12)=1:map(x,13)=2:map(x,14)=2:next x
for y = 0 to 14:map(0,y)=2:map(19,y)=2:next y
map(15,11)=3:map(15,10)=3:map(15,9)=3
map(8,10)=1:map(9,10)=1:map(10,10)=1
map(12,9)=1:map(13,9)=1:map(14,9)=1
map(5,11)=1:map(6,11)=1:map(7,11)=1
char.x=16:char.y=16:char.d=1
char.ac=0.1:char.da=0.09:char.ma=2:char.jmp=3

line (0,0)-(sw,sh),rgb(130,80,0),BF
for y = 0 to 14:for x = 0 to 19
    select case map(x,y)
    case 1:drawtile floor1.i(), x*16*scw, y*16*sch, scw, sch, 1
    case 2:drawtile floor2.i(), x*16*scw, y*16*sch, scw, sch, 1
    case 3:drawtile ladder.i(), x*16*scw, y*16*sch, scw, sch, 1
    end select
next x:next y

do
screenlock
line ((fix(char.x/16)-2)*16*scw,(fix(char.y/16)-2)*16*sch)-((fix(char.x/16)+3)*16*scw-1,(fix(char.y/16)+4)*16*sch-1),rgb(130,80,0),BF
for y=fix(char.y/16)-2 to fix(char.y/16)+3:for x=fix(char.x/16)-2 to fix(char.x/16)+2
    select case map(x,y)
    case 1:drawtile floor1.i(), x*16*scw, y*16*sch, scw, sch, 1
    case 2:drawtile floor2.i(), x*16*scw, y*16*sch, scw, sch, 1
    case 3:drawtile ladder.i(), x*16*scw, y*16*sch, scw, sch, 1
    end select
next x:next y
drawtile char.i(), char.x*scw, char.y*sch, scw, sch, char.d
if char.cy=1 then:drawtile char2.i(), char.x*scw, (char.y+16)*sch, scw, sch, char.d
elseif char.cy=2 then:drawtile char3.i(), char.x*scw, (char.y+16)*sch, scw, sch, char.d
elseif char.cy=3 then:drawtile char2.i(), char.x*scw, (char.y+16)*sch, scw, sch, char.d
elseif char.cy=4 then:drawtile char4.i(), char.x*scw, (char.y+16)*sch, scw, sch, char.d
elseif char.cy=5 then:drawtile char3.i(), char.x*scw, (char.y+16)*sch, scw, sch, char.d
endif
screenunlock
char.x+=char.sx:char.y+=char.sy
if cycle=0 then
    if wlk and char.st then
        char.cy+=1:if char.cy>=5 then char.cy=1
    endif
    cycle = 10
endif
if char.sy < 0 then if collide(int((char.x+2)/16),int(char.y/16)) or collide(int((char.x+8)/16),int(char.y/16)) then char.sy=0:char.y=int(char.y/16+1)*16
if char.sx > 0 then if collide(int((char.x+16)/16),int(char.y/16)) or collide(int((char.x+16)/16),int((char.y+16)/16)) then char.sx=0:char.x=int(char.x/16)*16
if char.sx < 0 then if collide(int((char.x)/16),int(char.y/16)) or collide(int(char.x/16),int((char.y+16)/16)) then char.sx=0:char.x=int(char.x/16+1)*16
if char.sx<>0 or char.sy<>0 then if collide(int((char.x+4)/16),int((char.y+32)/16)) or collide(int((char.x+10)/16),int((char.y+32)/16)) then:char.sy=0:char.st=1:char.y=int(char.y/16)*16:else:char.st=0:endif
if climb(int((char.x+4)/16),int((char.y+32)/16)) or climb(int((char.x+10)/16),int((char.y+32)/16)) then char.st=1
if char.st = 0 then:char.sy+=grav:char.cy=5
    if char.sy<>0 then
        if char.sx > 0 then if collide(int((char.x+16)/16),int((char.y+32)/16)) then char.sx=0:char.x=int(char.x/16)*16
        if char.sx < 0 then if collide(int((char.x)/16),int((char.y+32)/16)) then char.sx=0:char.x=int(char.x/16+1)*16
    endif
elseif wlk=0 then char.cy=1:endif
if not (multikey(fb.sc_up) or multikey(fb.sc_down)) then
    if climb(int((char.x+4)/16),int((char.y+32)/16)) or climb(int((char.x+10)/16),int((char.y+32)/16)) then char.sy=0
    wlk=0
endif
if not (multikey(fb.sc_left) or multikey(fb.sc_right)) then
    if char.sx>0 then char.sx-=char.da:if char.sx < char.da then char.sx = 0
    if char.sx<0 then char.sx+=char.da:if char.sx > -char.da then char.sx = 0
    wlk=0
endif
if multikey(fb.sc_up) then
    if climb(int((char.x+4)/16),int((char.y+30)/16)) or climb(int((char.x+10)/16),int((char.y+30)/16)) then:char.sy=-1:wlk=1
    elseif char.st=1 then:char.sy=-char.jmp: char.st=0
    endif:endif
if multikey(fb.sc_down) then if climb(int((char.x+4)/16),int((char.y+32)/16)) or climb(int((char.x+10)/16),int((char.y+32)/16)) then char.sy=1:wlk=1
if multikey(fb.sc_left) and char.sx > -char.ma then char.sx-=char.ac: char.d=-1
if multikey(fb.sc_right) and char.sx < char.ma then char.sx+=char.ac: char.d=1
if multikey(fb.sc_left) or multikey(fb.sc_right) then wlk=1
if multikey(fb.sc_escape) then end
sleep tim
cycle-=1
loop

sub drawtile (tile() as ubyte, x as double, y as double, w as double, h as double, d as integer)
    dim as integer n1,n2
    if d=1 then
        for n1 = 0 TO 15:for n2 = 0 to 15
            if not (tile(n2,n1,0) = 255 and tile(n2,n1,1) = 0 and tile(n2,n1,2) = 255) then
            line (x+(n2*w),y+(n1*h))-(x+(n2*w)+w-1,y+(n1*h)+h-1),rgb(tile(n2,n1,0),tile(n2,n1,1),tile(n2,n1,2)),BF:endif
        next n2:next n1
    else
        for n1 = 0 TO 15:for n2 = 0 to 15
            if not (tile(n2,n1,0) = 255 and tile(n2,n1,1) = 0 and tile(n2,n1,2) = 255) then
            line (x+((-n2+15)*w),y+(n1*h))-(x+((-n2+15)*w)+w-1,y+(n1*h)+h-1),rgb(tile(n2,n1,0),tile(n2,n1,1),tile(n2,n1,2)),BF:endif
        next n2:next n1
    endif
end sub

sub loadimage (file as string, b as integer, tile() as ubyte)
    dim as integer x, y, z
    z = b*768
    open file for binary access read as #1
        if eof(1) then
            print "Error loading file "+file
            print "Press any key to terminate"
            sleep
            end
        endif
        for y = 0 to 15:for x = 0 to 15:z+=1:get #1,z,tile(x,y,0):next x:next y
        for y = 0 to 15:for x = 0 to 15:z+=1:get #1,z,tile(x,y,1):next x:next y
        for y = 0 to 15:for x = 0 to 15:z+=1:get #1,z,tile(x,y,2):next x:next y
    close #1
end sub

function collide(x as integer, y as integer) as integer
    if map(x,y) = 1 or map(x,y) = 2 then return 1
    return 0
end function

function climb(x as integer, y as integer) as integer
    if map(x,y) = 3 then return 1
    return 0
end function