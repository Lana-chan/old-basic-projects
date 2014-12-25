'WinDungeON v0.aaaaaa
'Copyright 2011 Syniphas and Zan-Zan-Zawa-Veia
#include "fbgfx.bi"

'--- DECLARES ------------------------------------------------------------------
type maze 'each unit
    t as ubyte 'cell type
    r as ubyte 'red
    g as ubyte 'green
    b as ubyte 'blue
    o as ubyte 'object
end type
'const w=320, h=240, sw=w/320, sh=h/240
const w=640, h=480, sw=w/320, sh=h/240
'const w=1280, h=960, sw=w/320, sh=h/240
screenres w,h,32,,
Dim as FB.IMAGE ptr Buf = ImageCreate(320, 240) 'screen buffer
Dim as FB.IMAGE ptr TBox = ImageCreate(320, 53) 'text box
dim as integer xBlit, yBlit, i, moolti
Dim as uInteger ptr ScrP = ScreenPtr
Dim as uInteger ptr BufP = Cast(uInteger ptr,Cast(uByte ptr,Buf)+Sizeof(FB.IMAGE))
dim shared as ubyte font(2048)
dim shared as maze dun(128,128)

'--- FUNCTIONS -----------------------------------------------------------------
sub Printc(xOff as integer, yOff as integer, text as string, byRef surface as uInteger ptr, col as integer)
    dim as integer ch, px, py 'this sub prints text with the custom font on a
    for ch = 0 to len(text)-1 'FB.IMAGE surface
        for py = 0 to 7
            for px = 0 to 7
                'surface[(py+yOff+(ch*8))*240+(px+xOff)]=font(asc(mid(text,ch+1,1))*8+py) and 2^px
                if font(asc(mid(text,ch+1,1))*8+py) and 2^px then surface[(py+yOff)*320+(px+xOff+(ch*8))]=col
                'surface[(py+yOff)*320+(px+xOff+(ch*8))] = (font(asc(mid(text,ch+1,1))*8+py) and 2^px)*col
            next
        next
    next
end sub

sub drawMaze(xOff as integer, yOff as integer, mW as integer, mH as integer, pX as integer, pY as integer, pD as integer, byRef surface as FB.IMAGE ptr)
    dim as integer col, ccol, fcol, wcol, cr, cg, cb, dcol
    dim as integer d(2), o(4), i(4)
    cr = dun(pX,pY).r : cg = dun(pX,pY).g : cb = dun(pX,pY).b
    col = rgb(dun(pX,pY).r,dun(pX,pY).g,dun(pX,pY).b)
    ccol = rgb(iif(cr-40<000,000,cr-40),iif(cg-40<000,000,cg-40),iif(cb-40<000,000,cb-40))
    wcol = rgb(iif(cr-20<000,000,cr-20),iif(cg-20<000,000,cg-40),iif(cb-20<000,000,cb-40))
    fcol = rgb(iif(cr+40>255,255,cr+40),iif(cg+40>255,255,cg+40),iif(cb+40>255,255,cb+40))
    dcol = int(rgb(5,5,5))
    d(0) = 0 : d(1) = 50
    o(0) = xOff+d(0)    : o(1) = yOff+d(0)
    o(2) = xOff+mW-d(0) : o(3) = yOff+mH-d(0)
    i(0) = xOff+d(1)    : i(1) = yOff+d(1)
    i(2) = xOff+mW-d(1) : i(3) = yOff+mH-d(1)
    line surface,  (o(0),o(1))-(o(2),o(3)),dcol,b
    paint surface, (o(0)+1,o(1)+1),col,dcol
    line surface,  (o(0),o(1))-(i(0),i(1)),dcol
    line surface,  (o(2),o(1))-(i(2),i(1)),dcol
    line surface,  (o(0),o(3))-(i(0),i(3)),dcol
    line surface,  (o(2),o(3))-(i(2),i(3)),dcol
    line surface,  (i(0),i(1))-(i(2),i(3)),dcol,b
    paint surface, (o(0)+2,o(1)+1),ccol,dcol
    paint surface, (o(0)+1,o(1)+2),wcol,dcol
    paint surface, (o(2)-1,o(1)+2),wcol,dcol
    paint surface, (o(0)+2,o(3)-1),fcol,dcol
end sub

'--- INITIALIZATION ------------------------------------------------------------
open "font.bin" for binary as 1 'load fonts
get #1,, font()
close 1

LINE TBox, (0,0)-(320,0), rgb(255,220,30) 'textbox
LINE TBox, (0,1)-(320,42), rgb(255,200,10),bf
LINE TBox, (0,43)-(320,43), rgb(230,170,0)
LINE TBox, (0,44)-(320,52), rgb(200,200,200),bf

i=0

dun(0,0).t = 001
dun(0,0).r = 070
dun(0,0).g = 000
dun(0,0).b = 200
dun(0,0).o = 000

'--- MAIN LOOP -----------------------------------------------------------------
'do
    For yBlit = 0 to 239
        For xBlit = 0 to 319 'clear screen buffer
            BufP[yBlit*320+xBlit] = rgb(0,0,0)
        Next
    Next
    
    drawMaze(3,3,180,180,0,0,0,Buf)
    put Buf, (0,187), TBox
    Printc(0,24*8-3,"placeholder",BufP,rgb(0,0,0)) 'lines
    Printc(0,25*8-3,"placeholder",BufP,rgb(0,0,0))
    Printc(0,26*8-3,"placeholder",BufP,rgb(0,0,0))
    Printc(0,27*8-3,"placeholder",BufP,rgb(0,0,0))
    Printc(0,28*8-3,"placeholder",BufP,rgb(0,0,0))
    Printc(0,29*8,"placeholder_",BufP,rgb(0,0,0))
    
    /'
    'here goes realtime game logic or some shit
    CIRCLE Buf, (sin(i/5)*100+160, cos(i/5)*100+120), 20, rgb(255,255,255),,,,f
    i+=1 'cycle
    sleep 16 'cheap 60fps limit
    '/
    
    screenlock 'blit buffer resized

    /'
    For yBlit = 0 to h-1 'flexible renderer
        For xBlit = 0 to w-1
            ScrP[yBlit*w+xBlit] = BufP[int(yBlit/sh)*320+int(xBlit/sw)]
        Next
    Next
    '/
    
    For yBlit = 0 To h - 1 Step 2 'fast rendered for 640x480
        For xBlit = 0 To w - 1 Step 2
            moolti=BufP[int(yBlit/sh)*320+int(xBlit/sw)]
            ScrP [(yBlit)*w+(xBlit)] = moolti
            ScrP [(yBlit+1)*w+(xBlit)] = moolti
            ScrP [(yBlit+1)*w+(xBlit+1)] = moolti
            ScrP [(yBlit)*w+(xBlit+1)] = moolti
        Next
    Next
    
    screenunlock
'loop while inkey=""

sleep
