#include "chisock/chisock.bi"
#include "fbgfx.bi"
using chi

type mouse
    x as integer
    y as integer
    b as integer
    w as integer
    bb as integer
end type

dim shared as socket sock
dim shared as ushort x1,y1,x2,y2
dim shared as ubyte typ, keep, r, g, b
dim as mouse c
dim as zstring ptr nam
dim as string nam1
const w = 800, h = 600, ver="0.holyshitmultithreading"

input "Type your name: ", nam1
nam = allocate(len(nam1)+1)
*nam = nam1
input "Pick RED value (0-255): ",r
input "Pick GREEN value (0-255): ",g
input "Pick BLUE value (0-255): ",b
var res = sock.client("syniphas.bounceme.net", 25679)
if(res) then print translate_error(res)
sock.put(cubyte(2))
sock.put(cshort(len(*nam)))
sock.put_data(nam, len(*nam))
sock.put(cbyte(r))
sock.put(cbyte(g))
sock.put(cbyte(b))
deallocate nam
screenres w,h,32
windowtitle "World of Artcraft v"+ver

function getstr() as zstring ptr
    dim as short le
    dim as ubyte ptr buf
    sock.get(le,1,500)
    buf = allocate(int(le + 1))
    sock.get_data(buf, int(le))
    buf[le] = 0
    getstr=@buf[0]
end function

do
    getmouse c.x, c.y, c.w, c.b
    if (c.b and 1) and (c.x > 0 and c.y > 0) then
        if c.bb then
            if keep = 1 then
                x1 = x2
                y1 = y2
            endif
            x2 = cshort(c.x)
            y2 = cshort(c.y)
            if x1<>x2 or y1<>y2 then
                if (x1 > 0 and x1 < w) and (y1 > 0 and y1 < h) and (x2 > 0 and x2 < w) and (y2 > 0 and y2 < h) then
                    sock.put(cubyte(0))
                    sock.put(x1):sock.put(y1):sock.put(x2):sock.put(y2)
                    line (x1,y1)-(x2,y2),rgb(cint(r),cint(g),cint(b))
                endif
            endif
            keep = 1
        else
            c.bb = 1
            keep = 0
            x1 = cshort(c.x)
            y1 = cshort(c.y)
        endif
    sleep 20
    elseif c.b=0 then:c.bb=0:endif
    if sock.get(typ,,,true) then
        sock.get(typ)
        select case typ
        case 0
            dim as short ptr pt
            dim as ubyte ptr col
            pt = allocate(4*len(short))
            col = allocate(3*len(ubyte))
            sock.get(*pt,4,400)
            sock.get(*col,3,400)
            line(pt[0],pt[1])-(pt[2],pt[3]), rgb(cint(col[0]),cint(col[1]),cint(col[2]))
            deallocate pt
            deallocate col
        case 1
            cls
        case 2
            dim as zstring ptr nn
            dim as ubyte ptr col
            col = allocate(3*len(ubyte))
            nn = getstr
            sock.get(*col,3,400)
            dim as ubyte st
            sock.get(st,,400)
            color rgb(cint(col[0]),cint(col[1]),cint(col[2]))
            if st = 1 then print *nn & " joined"
            if st = 2 then print *nn & " left"
            color rgb(255,255,255)  
            deallocate col
            deallocate nn
        end select
    endif
    sleep 1
    if sock.is_closed() then print "disconnected":sleep
    if inkey = chr(255)+"k" or multikey(fb.sc_escape) then exit do
loop

sock.close
end
