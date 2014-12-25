'Treasure Hunt 2 ----- Copyright 2009-2010 Electrokinesis Studios
'Rewritten code 20/06/2010 by Syniphas and Treeki
'#include "fbgfx.bi"
#include "SDL\SDL.bi"

#include "SDL\SDL_Image.bi"
'Types--------------------------------------------------------------------------
Type Tile
    'raw(16,16,3) as ubyte 'useless?
    imageL as SDL_Surface ptr
    imageR as SDL_Surface ptr 'does SDL flip images? storing a cached flipped version should be better, I think
    Declare Function Load(filename as string, offset as integer) as integer
End Type

Type Enemy
    Exists as Integer
    X as Integer
    Y as Integer
    D as Integer
    State as Integer
    Declare Function Create(x as Integer, y as Integer, typ as integer, byval direction as integer) as integer
    Declare Sub Destroy()
    Declare Sub Execute()
    Declare Sub Draw()
End Type

Type Character
    X as Double
    Y as Double
    Xspeed as Double
    Yspeed as Double
    Xacc as Double
    Yacc as Double
    D as Integer
    State as Integer
    Walk as Integer
    OnGround as Integer
    Declare Function Create(x as Integer, y as Integer) as integer
    Declare Sub Death()
    Declare Sub Execute()
    Declare Sub Draw()
    Declare Function CheckCollision() as integer
End Type

Type Map
    tilemap(20,15) as ubyte
    collision(20,15) as ubyte
    screens(20,20) as ubyte
    Declare Function Load(filename as string) as integer
    Declare Sub Draw(x as integer, y as integer)
End Type
'Global Dims--------------------------------------------------------------------
Dim shared as double aspW, aspH
Dim shared as integer n
Dim shared as Tile bgTile(11)
Dim shared as Tile snakeTile(3)
Dim shared as Tile charTile(6)
Dim shared as Character player
Dim shared as Map level
dim shared SnakeAnimationFrames(4) as integer => {0, 1, 2, 1}
dim shared CharWalkFrames(4) as integer =>  {0, 1, 0, 2}

#define TargetFPS 60
dim shared as uint32 frameStartTicks, fpsMeasureStartTicks, cycles, fps, fpsTrack

Declare SUB BlitImage(x as integer,y as  integer,image as sdl_surface ptr)
Declare Function KeyPressed(check as SDLKey) as integer
Declare Function CheckCollisionRect(x as integer, y as integer,  rectwidth as integer, rectheight as integer) as integer
Dim shared CurrentKeys as Uint8 ptr
Dim shared KeyCount as Integer
Dim shared GameScreen as SDL_Surface ptr

Dim As String sTime = Time
'Subs---------------------------------------------------------------------------
Function KeyPressed(check as SDLKey) as integer
    if *(CurrentKeys+check) <> 0 then return -1
    return 0
End Function

Function CheckCollisionRect(x as integer, y as integer, rectwidth as integer, rectheight as integer) as integer
    'see how many tiles we need to check
    Dim as integer xbound1, xbound2, ybound1, ybound2, checkx, checky
    xbound1 = int(x / 16)
    xbound2 = int((x+rectwidth-1) / 16)
    ybound1 = int(y / 16)
    ybound2 = int((y+rectheight-1) / 16)
    
    for checky = ybound1 to ybound2
        for checkx = xbound1 to xbound2
            if level.collision(checkx,checky) = 1 then return 1
        next checkx
    next checky
    
    return 0
End Function

SUB BlitImage(x as integer,y as integer,image as sdl_surface ptr)
    DIM Rectangle as SDL_Rect
    DIM Rectangle2 as SDL_Rect
    Rectangle.X = 0: Rectangle.Y = 0 'i don't think this is necessary
    rectangle.w = image->w: rectangle.h = image->h
    Rectangle2.x = x*aspW: Rectangle2.y = y*aspH
    SDL_BlitSurface image, @rectangle, GameScreen, @rectangle2
    'clever.
END SUB 

Function Tile.Load(filename as string, offset as integer) as integer
    dim tempImage as SDL_Surface ptr
    tempImage = IMG_Load(".\data\gfx\" & filename & ".png")
    if tempImage = NULL then
        print "Image loading fail: "; SDL_GetError() 'this works
        SDL_quit():end
    endif
    
    offset *= 16
    
    This.imageL = SDL_CreateRGBSurface(SDL_HWSURFACE or SDL_SRCCOLORKEY, 16*aspW, 16*aspH, tempImage->format->BitsPerPixel, tempImage->format->Rmask, tempImage->format->Gmask, tempImage->format->Bmask, tempImage->format->Amask)
    This.imageR = SDL_CreateRGBSurface(SDL_HWSURFACE or SDL_SRCCOLORKEY, 16*aspW, 16*aspH, tempImage->format->BitsPerPixel, tempImage->format->Rmask, tempImage->format->Gmask, tempImage->format->Bmask, tempImage->format->Amask)
    
    SDL_SetColorKey(This.imageL, SDL_SRCCOLORKEY, SDL_MapRGB(This.imageL->format, 255, 0, 255))
    SDL_SetColorKey(This.imageR, SDL_SRCCOLORKEY, SDL_MapRGB(This.imageR->format, 255, 0, 255))
    
    'enable direct pixel access
    SDL_LockSurface(tempImage)
    SDL_LockSurface(This.imageL)
    SDL_LockSurface(This.imageR)
    
    'stretch+flip the surface
    dim as integer xsrc, ysrc, xdest, ydest, bytespp, curbyte
    dim as uint8 ptr srcPtr, destPtrL, destPtrR
    bytespp = tempImage->format->BytesPerPixel
    
    for ysrc = 0 to 15
        srcPtr = tempImage->pixels + (tempImage->pitch * ysrc)
        for ydest = ysrc*aspH to (ysrc*aspH)+aspH-1
            destPtrL = this.imageL->pixels + (this.imageL->pitch * ydest)
            destPtrR = this.imageR->pixels + (this.imageR->pitch * ydest)
            for xsrc = 0 to 15
                for xdest = xsrc*aspW to (xsrc*aspW)+aspW-1
                    for curbyte = 0 to bytespp-1
                        *(destPtrR+(xdest*bytespp)+curbyte) = *(srcPtr+((offset+xsrc)*bytespp)+curbyte)
                        *(destPtrL+(xdest*bytespp)+curbyte) = *(srcPtr+((offset+(15-xsrc))*bytespp)+curbyte)
                    next curbyte
                next xdest
            next xsrc
        next ydest
    next ysrc
    
    SDL_UnlockSurface(This.imageL)
    SDL_UnlockSurface(This.imageR)
    SDL_UnlockSurface(tempImage)
    
    SDL_FreeSurface(tempImage)
    return 0
End Function

Function Enemy.Create(x as Integer, y as Integer, typ as integer, byval direction as integer) as integer
    if typ < 1 then return -1
    This.Exists = typ
    This.X = x
    This.Y = y
    This.State = 0 'why do we need dir exactly so we can set the initial direction using snakes(idz).Create() 'but why why not?
    This.D = direction
    Return 0
End Function

Sub Enemy.Destroy()
    This.Exists = 0
End Sub

Sub Enemy.Execute()
    This.State = SnakeAnimationFrames((cycles/8) mod 4)
    
    if cycles mod 2 = 0 then
        'check walls
        select case Level.collision((This.X+(This.D*8))/16,This.Y/16)
            case 1 to 3, 5 to 9:This.D*=-1
        end select
        
        'check for end of ledge
        select case Level.collision((This.X+(This.D*8))/16,(This.Y+16)/16)
            case 0, 4:This.D*=-1
        end select
        
        This.X += This.D
    end if
End Sub

Sub Enemy.Draw()'rewritten
    select case This.D
        'case -1:put (This.X*aspW,This.Y*aspH),snakeTile(This.State).imageL,trans
        case -1:BlitImage(This.X,This.Y,snakeTile(This.State).imageL)
        'case  1:put (This.X*aspW,This.Y*aspH),snakeTile(This.State).imageR,trans
        case  1:BlitImage(This.X,This.Y,snakeTile(This.State).imageR)
    end select
End Sub

Function Character.Create(x as Integer, y as Integer) as integer
    This.X = x
    This.Y = y
    This.D = 1 'start off facing right
    This.OnGround = 0
    Return 0
End Function

Sub Character.Death()
'    This.State = deathstate (change me)
    ''This.Exists = 0
End Sub

Sub Character.Execute()
    If Xspeed <> 0 then:This.Walk = CharWalkFrames((cycles/8) mod 4)
    Elseif This.OnGround = 0 then:This.Walk = 1 'lazy jump frame
    Else:This.Walk = 0:endif 'i think this will work
    
    'oh boy here we go
    'accept input
    
    if KeyPressed(SDLK_LEFT) then
        This.D = -1:This.Xacc = -0.1
    elseif KeyPressed(SDLK_RIGHT) then
        This.D = 1:This.Xacc = 0.1
    else:This.Xacc = 0:endif
    
    'move the player accordingly
    if This.Xacc <> 0 then:This.Xspeed += This.Xacc
    else
        if This.Xspeed <> 0 then
            if abs(This.Xspeed) >= 0.1 then:This.Xspeed-= (0.1 * sgn(This.Xspeed))
            else:This.Xspeed = 0:endif
        endif
    endif
    if abs(This.Xspeed) >= 1.5 then This.Xspeed = 1.5 * sgn(This.Xspeed) 'keep the xspeed within  limits
    
    'process the xspeed
    'this probably makes no sense to you but it should work
    dim xloop as integer
    for xloop = 0 to abs(This.Xspeed)
        This.X += sgn(This.Xspeed)
        if This.CheckCollision() = 1 then
            This.X -= sgn(This.Xspeed)
            This.Xspeed = 0
            exit for
        end if
    next xloop
    
    'now, process the yspeed, fun
    This.Yacc = 0.2
    if KeyPressed(SDLK_UP) and This.OnGround = 1 then This.Yacc = -2
    This.Yspeed += This.Yacc
    
    dim as integer yloop
    This.OnGround = 0
    for yloop = 0 to abs(This.Yspeed)
        This.Y += sgn(This.Yspeed)
        if This.CheckCollision() = 1 then
            if sgn(This.Yspeed) = 1 then This.OnGround = 1
            
            This.Y -= sgn(This.Yspeed)
            This.Yspeed = 0
            exit for
        end if
    next yloop
    
End Sub

Function Character.CheckCollision() as integer 'is this really necessary
    return CheckCollisionRect(This.X, This.Y, 16, 32) 'seriously
End Function

Sub Character.Draw()'rewritten
    select case This.D
        case -1
            'put (This.X*aspW,This.Y*aspH),charTile(0).imageL,trans
            'put (This.X*aspW,(This.Y+16)*aspH),charTile(This.Walk+1).imageL,trans
            BlitImage(This.X,This.Y,charTile(0).imageL)
            BlitImage(This.X,This.Y+16,charTile(This.Walk+1).imageL)
        case 1
            'put (This.X*aspW,This.Y*aspH),charTile(0).imageR,trans
            'put (This.X*aspW,(This.Y+16)*aspH),charTile(This.Walk+1).imageR,trans
            BlitImage(This.X,This.Y,charTile(0).imageR)
            BlitImage(This.X,This.Y+16,charTile(This.Walk+1).imageR)
    end select
End Sub

Function Map.Load(filename as string) as integer
    dim as integer x, y
    open filename for binary access read as #1
        if eof(1) then return -1
        for y = 0 to 14:for x = 0 to 19:get #1,y*20+x+1,This.tilemap(x,y):next x:next y
        for y = 0 to 14:for x = 0 to 19:get #1,y*20+x+301,This.collision(x,y):next x:next y
    close #1
    return 0
End Function

Sub Map.Draw(x as integer, y as integer)'rewritten
    select case This.tilemap(x,y)
        'case 1 to 8:put (x*16*aspW,y*16*aspH),bgTile(This.tilemap(x,y)-1).imageR,pset
        'case 9:put (x*16*aspW,y*16*aspH),bgTile(9).imageR,pset
        'case 10:put (x*16*aspW,y*16*aspH),bgTile(8).imageR,pset
        case 1 to 8:BlitImage(x*16,y*16,bgTile(This.tilemap(x,y)-1).imageR)
        case 9:BlitImage(x*16,y*16,bgTile(9).imageR)
        case 10:BlitImage(x*16,y*16,bgTile(8).imageR)
    end select
    select case This.collision(x,y) ' why the fuck did i do this -- nevermind
        'case 6:put (x*16*aspW,y*16*aspH),bgTile(10).imageR,trans
        'case 7:put (x*16*aspW,y*16*aspH),bgTile(11).imageR,trans
        case 6,7:BlitImage(x*16,y*16,bgTile(This.tilemap(x,y)+4).imageR)
    end select
End Sub

'Init---------------------------------------------------------------------------
Redim as Enemy  snake(0)
Dim As Integer idx,idy, idz, ful

SDL_Init (SDL_INIT_TIMER or SDL_INIT_VIDEO)
GameScreen = SDL_SetVideoMode(960, 720, 32, SDL_HWSURFACE or (SDL_FULLSCREEN*ful))
if GameScreen = NULL then
    print "Video error: "; SDL_GetError() 'this works
    SDL_quit():end
endif
aspW = 960/320
aspH = 720/240

for n = 0 to 11:bgTile(n).Load("tiles",n):next
for n = 0 to 5:charTile(n).Load("char",n):next
for n = 0 to 2:snakeTile(n).Load("snake",n):next
level.Load(".\data\map2.abm")
for idy = 0 to 14:for idx = 0 to 19
    idz = ubound(snake)
    select case Level.collision(idx,idy)
        case 4:Redim preserve snake(idz+1) as Enemy
            snake(idz).Create(idx*16, idy*16, 1, -1)
        case 3:player.Create(idx*16,idy*16)
    end select
next:next
'Main---------------------------------------------------------------------------
fpsMeasureStartTicks = SDL_GetTicks()
Do
    'lastStep = tstep 'FPS code
    'tstep = ct - t
    't = ct
    'diff = ( lastStep - tStep )
    'If sTime <> Time Then
    '    sTime = Time
    '    fps = cycles
    '    cycles = 0
    'End If
    'cycles += 1
    'If tFPS < 5 Then tFPS = 5: myStep = 1/tFPS
    
    frameStartTicks = SDL_GetTicks()
    
    SDL_PumpEvents()
    CurrentKeys = SDL_GetKeyState(@KeyCount)
    
    '----Execute----
    If KeyPressed(SDLK_ESCAPE) then exit do
    
    For idx = 0 To ubound(snake)-1
        If snake(idx).Exists = 1 Then snake(idx).Execute()
    Next idx
    Player.Execute()
    
    '----Draw----
    'screenlock
    For idy=0 to 15:for idx=0 to 20
        level.Draw(idx,idy)
    next:next
    For idx = 0 To ubound(snake)-1
        If snake(idx).Exists = 1 Then snake(idx).Draw()
    Next idx
    Player.Draw()
    
    'screenunlock
    
    'While Timer < t + ( myStep )
    '    Sleep 0,1
    'Wend
    'ct = Timer
    'windowtitle "Treasure Hunt 2 - " & fps & "/" & tfps
    
    SDL_Flip(GameScreen)
    
    cycles += 1
    fpsTrack += 1
    
    if (SDL_GetTicks() - frameStartTicks) < (1000 / TargetFPS) then
        SDL_Delay((1000 / TargetFPS) - (SDL_GetTicks() - frameStartTicks))
    endif
    
    if (SDL_GetTicks() - fpsMeasureStartTicks) > 1000 then
        'fps = cycles / ((SDL_GetTicks() - fpsMeasureStartTicks) / 1000)
        fps = fpsTrack
        SDL_WM_SetCaption("Treasure Hunt 2 - " & fps & "/" & TargetFPS, "Treasure Hunt 2")
        fpsMeasureStartTicks = SDL_GetTicks()
        fpsTrack = 0
    endif
    
Loop
SDL_Quit()
End
