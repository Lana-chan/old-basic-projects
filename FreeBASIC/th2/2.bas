declare SUB drawtile (tile() as ubyte, x as double, y as double, h as double, w as double)
declare sub loadimage (file as string, b as integer, tile() as ubyte)
type object
    x as integer
    y as integer
    h as integer
    w as integer
    i(16,16,3) as ubyte
end type
dim as object char1, char2, char3, char4, floor1, floor2
dim as integer sh = 320, sw = 240, x, y
dim as double sch, scw
screenres sh,sw,16
sch = sh/320
scw = sw/240

loadimage ".\gfx\char.abn",0,char1.i()
loadimage ".\gfx\char.abn",1,char2.i()
loadimage ".\gfx\char.abn",2,char3.i()
loadimage ".\gfx\char.abn",3,char4.i()
loadimage ".\gfx\tiles.abn",0,floor1.i()
loadimage ".\gfx\tiles.abn",1,floor2.i()
floor1.x = 0: floor1.y = 192
floor1.h = 1 : floor1.w = 20
floor2.x = 0: floor2.y = 208
floor2.h = 2 : floor2.w = 20
for y = 0 to floor1.h-1:for x = 0 to floor1.w-1
    drawtile floor1.i(), (floor1.x+x*16)*scw, (floor1.y+y*16)*sch, sch, scw
next x:next y
for y = 0 to floor2.h-1:for x = 0 to floor2.w-1
    drawtile floor2.i(), (floor2.x+x*16)*scw, (floor2.y+y*16)*sch, sch, scw
next x:next y
sleep

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
