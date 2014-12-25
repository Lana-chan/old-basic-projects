#include "fbgfx.bi"
dim shared as integer x,y,alpha(640,480)
dim as double xs,ys
const w=640,h=480,pi=3.141,acc=0.1,deacc=0.05
screenres w,h,16

print "Carregando..."
screenlock
bload "pistas/1alpha.bmp"
for y=1 to 480
    for x=1 to 640
        if point(x,y) = rgb(0,0,0) then alpha(x,y) = 0
        if point(x,y) = rgb(255,255,255) then alpha(x,y) = 1
    next
next
cls
screenunlock
x = 50
y = 50
do until multikey(fb.sc_escape)
    screenlock
    cls
    bload "pistas/1.bmp"
    line (x,y)-(x+5,y+5),rgb(127,0,0),bf
    screenunlock
    if multikey(fb.sc_up) then ys-=acc
    if multikey(fb.sc_down) then ys+=acc
    if multikey(fb.sc_left) then xs-=acc
    if multikey(fb.sc_right) then xs+=acc
    if xs > 0 then xs-=deacc
    if xs < 0 then xs+=deacc
    if ys > 0 then ys-=deacc
    if ys < 0 then ys+=deacc
    x+=xs
    y+=ys
loop
