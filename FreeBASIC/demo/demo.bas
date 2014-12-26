# define FBEXT_NO_LIBJPG -1
# include once "ext/graphics.bi"
# include once "fbgfx.bi"
# include once "fmod.bi"

using ext

'variables----------------------------------------------------------------------
const deg_to_rad As Double = 3.1415926535897932/180
const w=800,h=600,scale=3

IF FSOUND_GetVersion < FMOD_VERSION THEN
    print "FMOD version " + STR$(FMOD_VERSION) + " or greater required", FSOUND_GetVersion
    end
end if

If FSOUND_Init(44100, 32, 0) = FALSE Then
    print "Can't initialize FMOD"
    end
End If

screenres w, h, 32

dim shared as FB.IMAGE ptr font(40), fontr(40)
dim as FB.IMAGE ptr fontsrc  = gfx.png.load("font.png")
dim as integer x, y, x2, y2, t
dim shared as string msg, pmsg
DIM Song AS FMUSIC_MODULE ptr

for x = 0 to 4 'load font into separate images
    for y = 0 to 8
        if y+x*9 > 39 then exit for
        font(y+x*9) = imagecreate(16*scale,22*scale)
        fontr(y+x*9) = imagecreate(16*scale,22)
        for y2 = 0 TO 21:for x2 = 0 to 15 'scaler
            var x3 = x*16+x2
            line font(y+x*9),(x2*scale,y2*scale)-(x2*scale+scale-1,y2*scale+scale-1),point(x3,y*22+y2,fontsrc),BF
            line fontr(y+x*9),(x2*scale,y2)-(x2*scale+scale-1,y2),point(x3,y*22+21-y2,fontsrc),BF
        next:next
    next
next

'subs---------------------------------------------------------------------------
sub printc(_x_ as integer, _y_ as integer, _tx as string, _r as integer)
    var n = 0
    for n = 0 to len(_tx)-1
        var i = asc(_tx,n+1)
        if i>=97 and i<=122 then: i-=97
        elseif i>=65 and i<=90 then: i-=65
        elseif i>=48 and i<=57 then: i-=22
        elseif i=62 then: i=36
        elseif i=60 then: i=37
        elseif i=46 then: i=38
        elseif i=58 then: i=39
        else: continue for: end if
        if _r then: put(_x_+n*16*scale,_y_),fontr(i),alpha,_r
        else: put(_x_+n*16*scale,_y_),font(i),trans: end if
    next
end sub

'main loop----------------------------------------------------------------------

Song = FMUSIC_LoadSong("epic_pinball_-_song1_-_super_android.xm")
FMUSIC_PlaySong(Song)
x=800
y=1
msg="hello world......this is a quick demo in freebasic.........>svetlana 2012<......"
pmsg=mid(msg,y,50)
do while not multikey(FB.SC_ESCAPE)
    var s=abs(sin(t*deg_to_rad))
	screenlock
	cls
    printc(x,-s*100+300,pmsg,0)
    printc(x,s*30+300+22*scale,pmsg,127-s*63)
	screenunlock
    x-=4
    t+=2
    if x<-16*scale then
        x=-4
        y+=1
        pmsg=mid(msg,y,50)
        if len(pmsg)<50 then pmsg=pmsg+left(msg,50-len(pmsg))
        if y>len(msg) then y=1
    end if
    if t>180 then t=0
	sleep 10,1
loop
FMUSIC_StopSong(Song)
FSOUND_Close()
end
