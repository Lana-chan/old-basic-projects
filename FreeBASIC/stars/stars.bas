#include "fbgfx.bi"
randomize timer
'bumarse

type star
    x as integer
    y as integer
    z as integer
    s as integer 'speed
end type

type camera
    sx as integer
    sy as integer
    sz as integer
end type

const w=800,h=600,maxstars=2000,ver="0.9.9"
const sxmax = 50, symax = 50, sxmin = -50, symin = -50, szmax = 50

dim as star stars(maxstars)
dim shared as camera cam
dim as integer n

sub drawstar(st as star)
    'hello i am an asshole who doesn't know 3d
    dim as double sx, sy, dsx, dsy, r, tc
    sx = st.x/(st.z/3)+w/2
    sy = st.y/(st.z/3)+h/2
    dsx = (st.x+cam.sx*100)/(st.z/3+st.s+cam.sz)+w/2
    dsy = (st.y+cam.sy*100)/(st.z/3+st.s+cam.sz)+h/2
    r = 500/st.z
    tc = (600-st.z)/599*100
    if tc < 0 then tc = 0
    line (dsx,dsy)-(sx-r,sy),rgb(tc,tc,tc)
    line (dsx,dsy)-(sx+r,sy),rgb(tc,tc,tc)
    line (dsx,dsy)-(sx,sy-r),rgb(tc,tc,tc)
    line (dsx,dsy)-(sx,sy+r),rgb(tc,tc,tc)
    circle (sx,sy),r,rgb(255,255,255)
end sub

sub initstar(st as star)
    'what am i doing
    st.x = int(rnd(1)*160000)-80000
    st.y = int(rnd(1)*160000)-80000
    st.z = int(rnd(1)*500)+501
    st.s = int(rnd(1)*20)+1
end sub

screenres w,h,32
windowtitle "stars v"+ver
do
    'this is stupid
    screenlock
    cls
    circle (w/2+cam.sx*2,h/2+cam.sy*2),5,rgb(100,0,0),,,,f
    for n = 1 to maxstars
        if stars(n).z < 1 then
            initstar stars(n)
        else
            drawstar stars(n)
            stars(n).z-=stars(n).s+cam.sz
            stars(n).x+=cam.sx*100
            stars(n).y+=cam.sy*100
            if stars(n).x < -80000 then stars(n).x += 160000
            if stars(n).x >  80000 then stars(n).x -= 160000
            if stars(n).y < -80000 then stars(n).y += 160000
            if stars(n).y >  80000 then stars(n).y -= 160000
        endif
    next
    print "Use arrow keys and space, ESC to exit."
    print "SX:", cam.sx
    print "SY:", cam.sy
    print "SZ:", cam.sz
    screenunlock
    if inkey = chr(255)+"k" or multikey(fb.sc_escape) then exit do
    if cam.sx < sxmax and multikey(fb.sc_left) then  cam.sx += 5
    if cam.sx > sxmin and multikey(fb.sc_right) then cam.sx -= 5
    if cam.sy < symax and multikey(fb.sc_up) then    cam.sy += 5
    if cam.sy > symin and multikey(fb.sc_down) then  cam.sy -= 5
    if cam.sz < szmax and multikey(fb.sc_space) then cam.sz += 5
    if inkey="" then
        cam.sx -= sgn(cam.sx)
        cam.sy -= sgn(cam.sy)
        cam.sz -= sgn(cam.sz)
    endif
    sleep 1000/30
loop

end
            