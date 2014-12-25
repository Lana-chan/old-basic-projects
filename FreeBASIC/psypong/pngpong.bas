#include "fbgfx.bi"
#include "sdl\sdl.bi"
#include "SDL\SDL_Image.bi"
dim as SDL_Surface ptr tela
dim as SDL_Event ptr event
tela = SDL_SetVideoMode(800, 600, 32, SDL_DOUBLEBUF)
'windowtitle "psypong versão 1.2.1"

Dim pad As SDL_Surface ptr 'carrega imagens
Dim ball As SDL_Surface ptr
Dim title As SDL_Surface ptr
pad = imagecreate(32,128)
ball = imagecreate(32,32)
title = imagecreate(800,600)
pad = IMG_Load("gfxpng/pad.png")
ball = IMG_Load("gfxpng/ball.png")
title = IMG_Load("gfxpng/title.png")

if tela = NULL or pad = NULL or ball = NULL or title = NULL then
	print "impossível inicializar a janela grafica ou carregar imagens: ";SDL_GetError()
    print "viva la revolucion"
    SDL_Quit()
    end
endif

SDL_BlitSurface(title,NULL, tela, NULL)
SDL_Flip(tela)
title:
print event.type
if SDL_PollEvent(event) then
    if event = SDL_KEYDOWN then end
endif
goto title

start:
Dim padx(2) as integer 'faz variáveis
Dim pady(2) as integer
Dim balx(7) as integer
Dim baly(7) as integer
dim balvelx as integer
dim balvely as integer
dim score1 as integer
dim score2 as integer
dim a as string
dim speed as integer
dim slptim as integer

speed = 4

resett:
padx(0) = 100: padx(1) = 700-32 'posições
pady(0) = 300-64: pady(1) = 300-64
balx(0) = 400-16
baly(0) = 300-16
balvelx = -speed
balvely = 0
cls
locate 18,46
print "prepare-se"
slptim = timer
do
loop until timer > (slptim + 1)
goto jogo

jogo:
if multikey(FB.SC_UP) then if pady(0) > 10 then pady(0)-=speed+1 'teclas
if multikey(FB.SC_DOWN) then if pady(0) < 590-128 then pady(0)+=speed+1
if multikey(FB.SC_ESCAPE) or inkey$ = chr$(255)+"k" then end
if pady(1) > baly(0) and balx(0) > 250-16 then if pady(1) > 10 then pady(1)-=speed-1 'IA besta
if pady(1)+128 < baly(0)+32 and balx(0) > 250-16 then if pady(1) < 590-128 then pady(1)+=speed-1
balx(6) = balx(5): baly(6) = baly(5) 'sombras
balx(5) = balx(4): baly(5) = baly(4)
balx(4) = balx(3): baly(4) = baly(3)
balx(3) = balx(2): baly(3) = baly(2)
balx(2) = balx(1): baly(2) = baly(1)
balx(1) = balx(0): baly(1) = baly(0)
a = inkey$
balx(0)+=balvelx
baly(0)+=balvely
if baly(0) < 0 then
    baly(0) = 0
    balvely=balvely*-1
elseif baly(0) > 600-32 then
    baly(0) = 600-32
    balvely=balvely*-1
endif
if balx(0) <= 0 then
    score2+=1
    goto resett
elseif balx(0) >= 800-32 then
    score1+=1
    goto resett
endif
if balx(0) < padx(0)+32 and baly(0) < pady(0)+32 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0) then 'bate bola jogo rápido
    balx(0) = padx(0)+32
    balvelx=balvelx*-1: balvely-=speed
elseif balx(0) < padx(0)+32 and baly(0) < pady(0)+64 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0)+32 then
    balx(0) = padx(0)+32
    balvelx=balvelx*-1: balvely-=int(speed/2)
elseif balx(0) < padx(0)+32 and baly(0) < pady(0)+96 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0)+64 then
    balx(0) = padx(0)+32
    balvelx=balvelx*-1: balvely+=int(speed/2)
elseif balx(0) < padx(0)+32 and baly(0) < pady(0)+128 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0)+96 then
    balx(0) = padx(0)+32
    balvelx=balvelx*-1: balvely+=speed
elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+32 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1) then
    balx(0) = padx(1)-32
    balvelx=balvelx*-1: balvely-=speed
elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+64 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1)+32 then
    balx(0) = padx(1)-32
    balvelx=balvelx*-1: balvely-=int(speed/2)
elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+96 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1)+64 then
    balx(0) = padx(1)-32
    balvelx=balvelx*-1: balvely+=int(speed/2)
elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+128 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1)+96 then
    balx(0) = padx(1)-32
    balvelx=balvelx*-1: balvely+=speed
endif
'screenlock 'desenha tudo
'cls
print ,,"humano: ";score1, "cpu: ";score2
print a
'SDL_BlitSurface(bitmap,NULL, tela, NULL) 
'put (padx(0),pady(0)),pad,alpha,255
'put (padx(1),pady(1)),pad,alpha,255
'put (balx(6),baly(6)),ball,alpha,55
'put (balx(3),baly(3)),ball,alpha,155
'put (balx(0),baly(0)),ball,alpha,255
'screenunlock
sleep 1
goto jogo 'rinse and repeat