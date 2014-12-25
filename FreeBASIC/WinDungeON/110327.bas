'WinDungeON v0.aaaaaa
'Copyright 2011 Syniphas and Zan-Zan-Zawa-Veia
#include "fbgfx.bi"

type maze 'each unit
    t as ubyte 'cell type
    r as ubyte 'red
    g as ubyte 'green
    b as ubyte 'blue
    o as ubyte 'object
end type
'const w=320, h=240, sw=w/320, sh=h/240
const w=640, h=480, sw=w/320, sh=h/240
screenres w,h,32,,
Dim as FB.IMAGE ptr Buf = ImageCreate(320, 240) 'screen buffer
dim as integer xBlit, yBlit, i, moolti
Dim as uInteger ptr ScrP = ScreenPtr
dim shared as ubyte font(2048)
Dim as uInteger ptr BufP = Cast(uInteger ptr,Cast(uByte ptr,Buf)+Sizeof(FB.IMAGE))

sub Printc(xOff as integer, yOff as integer, text as string, byRef surface as uInteger ptr, col as integer)
    dim as integer ch, px, py 'this sub prints text with the custom font on a
    for ch = 0 to len(text)-1 'FB.IMAGE surface
        for py = 0 to 7
            for px = 0 to 7
                'surface[(py+yOff+(ch*8))*240+(px+xOff)]=font(asc(mid(text,ch+1,1))*8+py) and 2^px
                if font(asc(mid(text,ch+1,1))*8+py) and 2^px then surface[(py+yOff)*320+(px+xOff+(ch*8))]=col
            next
        next
    next
end sub

open "font.bin" for binary as 1 'load fonts
get #1,, font()
close 1

i=0
do
    For yBlit = 0 to 239
        For xBlit = 0 to 319 'clear screen buffer
            BufP[yBlit*320+xBlit] = rgb(0,0,0)
        Next
    Next
    
    Printc(0,0,"hello world!",BufP,rgb(255,255,255))
    Printc(0,8,"hello world!",BufP,rgb(255,0,0))
    Printc(0,16,"hello world!",BufP,rgb(0,255,0))
    Printc(0,24,"hello world!",BufP,rgb(0,0,255))
    
    Printc(100,17,"hello world!",BufP,rgb(0,0,255))
    Printc(100,16,"hello world!",BufP,rgb(0,255,0))
    Printc(100,15,"hello world!",BufP,rgb(255,0,0))
    
    Printc(50,100,"this is very flexible",BufP,rgb(150,150,150))
    CIRCLE Buf, (160, 120), 60, rgb(200,200,200),,, 2
    CIRCLE Buf, (160, 120), 61, rgb(200,200,200),,, 2
    CIRCLE Buf, (160, 120), 62, rgb(200,200,200),,, 2
    Printc(56,106,"this is very flexible",BufP,rgb(250,250,250))
    
    CIRCLE Buf, (sin(i/5)*100+160, cos(i/5)*100+120), 20, rgb(200,200,200)
    i+=1
    sleep 16
    
    screenlock 'blit buffer resized
    /'
    For xBlit as Integer = 0 to w-1
        For yBlit as Integer = 0 to h-1
            ScrP[yBlit*w+xBlit] = BufP[int(yBlit/sh)*320+int(xBlit/sw)]
        Next
    Next
    
    For yBlit = 0 to h-1
        For xBlit = 0 to w-1
            ScrP[yBlit*w+xBlit] = BufP[int(yBlit/sh)*320+int(xBlit/sw)]
        Next
    Next
    '/
    
    For yBlit = 0 To h - 1 Step 2
        For xBlit = 0 To w - 1 Step 2
            moolti=BufP[int(yBlit/sh)*320+int(xBlit/sw)]
            ScrP [(yBlit)*w+(xBlit)] = moolti
            ScrP [(yBlit+1)*w+(xBlit)] = moolti
            ScrP [(yBlit+1)*w+(xBlit+1)] = moolti
            ScrP [(yBlit)*w+(xBlit+1)] = moolti
        Next
    Next
    
    screenunlock
loop while inkey=""

'sleep
