#include "fbgfx.bi"
#include "SDL\SDL.bi"
#include "SDL\SDL_Mixer.bi"
SDL_Init (SDL_INIT_AUDIO)
Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 1024)
Screen 19,32
randomize timer
windowtitle "psypong versão 1.6.7"
declare sub engine
declare sub liberatudo
declare sub levelstuff

Dim shared pad As Any Ptr 'carrega imagens
Dim shared ball As Any Ptr
Dim shared title As Any Ptr
Dim shared bloco As Any Ptr
Dim shared preto As Any Ptr
Dim shared jogar As Any Ptr
Dim shared recor As Any Ptr
Dim shared credi As Any Ptr
Dim shared ump As Any Ptr
Dim shared doisp As Any Ptr
Dim shared voltar As Any Ptr
pad = imagecreate(32,128)
ball = imagecreate(32,32)
title = imagecreate(800,600)
preto = imagecreate(800,600)
bloco = imagecreate(64,64)
jogar = imagecreate(239,47)
recor = imagecreate(239,47)
credi = imagecreate(239,47)
ump = imagecreate(239,47)
doisp = imagecreate(239,47)
voltar = imagecreate(239,47)
Bload "gfx\pad.bmp", pad
Bload "gfx\ball.bmp", ball
Bload "gfx\title.bmp", title
Bload "gfx\bloco.bmp", bloco
Bload "gfx\preto.bmp", preto
Bload "gfx\jogar2.bmp", jogar
Bload "gfx\reco1.bmp", recor
Bload "gfx\cred1.bmp", credi
Bload "gfx\1p1.bmp", ump
Bload "gfx\2p1.bmp", doisp
Bload "gfx\voltar1.bmp", voltar

dim shared as Mix_Music ptr menumus 'carrega sons
dim shared as Mix_Chunk ptr batida
dim shared as Mix_Chunk ptr aceita
dim shared as Mix_Chunk ptr clique
dim shared as Mix_Chunk ptr ping
dim shared as Mix_Chunk ptr pong
dim shared as Mix_Chunk ptr ponto
dim shared as Mix_Chunk ptr ponto2
dim shared as Mix_Chunk ptr fase
menumus = Mix_LoadMUS("sfx\musica1.mp3")
batida = Mix_LoadWAV("sfx\batida.wav")
aceita = Mix_LoadWAV("sfx\menu-aceita.wav")
clique = Mix_LoadWAV("sfx\menu-clique.wav")
ping = Mix_LoadWAV("sfx\ping.wav")
pong = Mix_LoadWAV("sfx\pong.wav")
ponto = Mix_LoadWAV("sfx\ponto.wav")
ponto2 = Mix_LoadWAV("sfx\ponto2.wav")
fase = Mix_LoadWAV("sfx\fase.wav")

Dim shared padx(2) as integer 'faz variáveis
Dim shared pady(2) as integer
Dim shared blox(2) as integer
Dim shared bloy(2) as integer
Dim shared blod(2) as integer
Dim shared balx(7) as integer
Dim shared baly(7) as integer
dim shared balvelx as integer
dim shared balvely as integer
dim shared speed as integer
dim shared resetgame as integer
dim shared nome1 as string
dim shared nome2 as string
dim shared score1 as integer
dim shared score2 as integer
dim shared hit as integer
dim shared level as integer
dim shared sfx as integer
dim shared gfx as integer
dim menuptr as integer
dim f as integer
dim slptim as integer
dim kup as integer
dim kdown as integer
dim menuptr2 as integer
dim kenter as integer
dim gametype as integer
dim scoret1 as integer
dim scoret2 as integer
dim nomer as string
dim scorer as integer
dim i as integer
dim r as integer

put (0,0), title
Mix_PlayMusic(menumus, -1)
title:
sleep
if multikey(FB.SC_ENTER) then mix_freemusic(menumus): mix_playchannel(-1,aceita,0): kenter = 1: goto menu
if multikey(FB.SC_ESCAPE) or inkey$ = chr$(255)+"k" then
    liberatudo
    Mix_CloseAudio()
    SDL_Quit()
    end
endif
goto title

menu:
speed = 4
score1 = 0
score2 = 0
f = 1
sfx = 0
gfx = 0
nome1 = "hal 9000"
nome2 = "cpu"
menuptr = 1

menu2:
resetgame = 0
blox(0) = -100
bloy(0) = -100
blox(1) = -100
bloy(1) = -100
padx(0) = 100: padx(1) = 700-32 'posições
pady(0) = 300-64: pady(1) = 300-64
balx(0) = 400-32-32
baly(0) = 300-16
balvelx = speed*f
f = f*-1
balvely = rnd(1)*speed-speed/2
goto menuloop

menuloop:
if pady(0) > baly(0) and balx(0) < 250+16 then if pady(0) > 10 then pady(0)-=speed-1 'IA besta
if pady(0)+128 < baly(0)+32 and balx(0) < 250+16 then if pady(0) < 590-128 then pady(0)+=speed-1
if pady(1) > baly(0) and balx(0) > 250-16 then if pady(1) > 10 then pady(1)-=speed-1 'IA besta
if pady(1)+128 < baly(0)+32 and balx(0) > 250-16 then if pady(1) < 590-128 then pady(1)+=speed-1
if multikey(FB.SC_ESCAPE) or inkey$ = chr$(255)+"k" then
    liberatudo
    Mix_CloseAudio()
    SDL_Quit()
    end
endif
screenlock
engine
put (0,0),preto,alpha,127
put (400-120,225),jogar,alpha,255
put (400-120,275),recor,alpha,255
put (400-120,325),credi,alpha,255
screenunlock
if multikey(fb.sc_up) = 0 then
    kup = 0
elseif multikey(fb.sc_up) and menuptr > 1 and kup = 0 then
    mix_playchannel(-1,clique,0)
    kup = 1
    menuptr -=1
endif
if multikey(fb.sc_down) = 0 then
    kdown = 0
elseif multikey(fb.sc_down) and menuptr < 3 and kdown = 0 then
    mix_playchannel(-1,clique,0)
    kdown = 1
    menuptr +=1
endif
if multikey(fb.sc_enter) = 0 then
    kenter = 0
elseif multikey(fb.sc_enter) and kenter = 0 then
    mix_playchannel(-1,aceita,0)
    kenter = 1
    if menuptr = 1 then
        menuptr2 = 1
        cls
        goto menupt2
    elseif menuptr = 2 then
        goto recordes
    elseif menuptr = 3 then
        goto creditos
    endif
endif
if menuptr = 1 then
    Bload "gfx\jogar2.bmp", jogar
    Bload "gfx\reco1.bmp", recor
    Bload "gfx\cred1.bmp", credi
elseif menuptr = 2 then
    Bload "gfx\jogar1.bmp", jogar
    Bload "gfx\reco2.bmp", recor
    Bload "gfx\cred1.bmp", credi
elseif menuptr = 3 then
    Bload "gfx\jogar1.bmp", jogar
    Bload "gfx\reco1.bmp", recor
    Bload "gfx\cred2.bmp", credi
endif
if resetgame = 1 then goto menu2
sleep 4
goto menuloop

menupt2:
if multikey(FB.SC_ESCAPE) or inkey$ = chr$(255)+"k" then
    liberatudo
    Mix_CloseAudio()
    SDL_Quit()
    end
endif
screenlock
cls
put (400-120,225),ump,alpha,255
put (400-120,275),doisp,alpha,255
put (400-120,325),voltar,alpha,255
screenunlock
if multikey(fb.sc_up) = 0 then
    kup = 0
elseif multikey(fb.sc_up) and menuptr2 > 1 and kup = 0 then
    mix_playchannel(-1,clique,0)
    kup = 1
    menuptr2 -=1
endif
if multikey(fb.sc_down) = 0 then
    kdown = 0
elseif multikey(fb.sc_down) and menuptr2 < 3 and kdown = 0 then
    mix_playchannel(-1,clique,0)
    kdown = 1
    menuptr2 +=1
endif
if multikey(fb.sc_enter) = 0 then
    kenter = 0
elseif multikey(fb.sc_enter) and kenter = 0 then
    mix_playchannel(-1,aceita,0)
    kenter = 1
    if menuptr2 = 1 then
        speed = 4
        score1 = 0
        score2 = 0
        scoret1 = 0
        scoret2 = 0
        level = 1
        f = 1
        sfx = 1
        gfx = 1
        nome1 = "humano"
        nome2 = "cpu"
        menuptr = 1
        gametype = 1
        goto resett
    elseif menuptr2 = 2 then
        speed = 4
        score1 = 0
        score2 = 0
        scoret1 = 0
        scoret2 = 0
        level = 1
        f = 1
        sfx = 1
        gfx = 1
        nome1 = "humano 1"
        nome2 = "humano 2"
        menuptr = 1
        gametype = 2
        goto resett
    elseif menuptr2 = 3 then
        goto menu
    endif
endif
if menuptr2 = 1 then
    Bload "gfx\1p2.bmp", ump
    Bload "gfx\2p1.bmp", doisp
    Bload "gfx\voltar1.bmp", voltar
elseif menuptr2 = 2 then
    Bload "gfx\1p1.bmp", ump
    Bload "gfx\2p2.bmp", doisp
    Bload "gfx\voltar1.bmp", voltar
elseif menuptr2 = 3 then
    Bload "gfx\1p1.bmp", ump
    Bload "gfx\2p1.bmp", doisp
    Bload "gfx\voltar2.bmp", voltar
endif
goto menupt2
    
creditos:
cls
locate 10,10
print "Programacao"
locate 11,11
print "Eric Pinheiro Manal"
locate 13,10
print "Edicao sonora"
locate 14,11
print "Cristiano Rodrigues Siqueira Soares"
locate 15,11
print "Rudah Paiva"
locate 17,10
print "Musica"
locate 18,11
print "Dexter"
locate 19,11
print "Eric Pinheiro Manal"
locate 21,10
print "Suporte geral"
locate 22,11
print "Ronaldo Sales"
locate 30,10
print "Aperte enter para voltar"
do while 1
    if multikey(fb.sc_enter) = 0 then
        kenter = 0
    elseif multikey(fb.sc_enter) and kenter = 0 then
        mix_playchannel(-1,aceita,0)
        kenter = 1
        goto menu
    endif
loop

recordes:
cls
open "scores.hig" for input as 1
if eof(1) then
    locate 20,40
    print "scores.hig não encontrado!"
    do while 1
        if multikey(fb.sc_enter) = 0 then
            kenter = 0
        elseif multikey(fb.sc_enter) and kenter = 0 then
            mix_playchannel(-1,aceita,0)
            kenter = 1
            goto menu
        endif
    loop
endif
locate 13, 47
print "recordes"
for i = 1 to 5
    input #1, nomer
    input #1, scorer
    locate 15+i*2, 46
    print nomer;" - ";scorer
next
close 1
do while 1
    if multikey(fb.sc_enter) = 0 then
        kenter = 0
    elseif multikey(fb.sc_enter) and kenter = 0 then
        mix_playchannel(-1,aceita,0)
        kenter = 1
        goto menu
    endif
loop

resett:
resetgame = 0
if score1 = 10 then
    mix_playchannel(-1,fase,0)
    level+= 1
    scoret1+=10-score2
    score1 = 0
    score2 = 0
    if level = 6 then
        cls
        locate 18,46
        print "parabens"
        locate 19,46
        print "voce terminou o jogo"
        locate 20,46
        print "pontuacao final: ";scoret1
        open "scores.hig" for input as 1
        if eof(1) then
            close 1
            locate 21,46
            input "novo recorde, digite seu nome: ", nome1
            open "scores.hig" for output as 1
            print #1, nome1
            print #1, scoret1
            print #1, "Anonimo"
            print #1, " 0"
            print #1, "Anonimo"
            print #1, " 0"
            print #1, "Anonimo"
            print #1, " 0"
            print #1, "Anonimo"
            print #1, " 0"
            close 1
        else
            for i = 1 to 5
                input #1, nomer
                input #1, scorer
                if scoret1 > scorer then
                    locate 21,46
                    input "novo recorde, digite seu nome: ", nome1
                    close 1
                    open "scores.hig" for input as 1
                    open "scores2.hig" for output as 2
                    for r = 1 to 5
                        input #1, nomer
                        input #1, scorer
                        print #2, nomer
                        print #2, scorer
                    next
                    close 1
                    close 2
                    open "scores2.hig" for input as 1
                    open "scores.hig" for output as 2
                    if i > 1 then
                        for r = 1 to i-1
                            input #1, nomer
                            input #1, scorer
                            print #2, nomer
                            print #2, scorer
                        next
                    endif
                    print #2, nome1
                    print #2, scoret1
                    if i < 5 then
                        for r = i+1 to 6
                            input #1, nomer
                            input #1, scorer
                            print #2, nomer
                            print #2, scorer
                        next
                    endif
                    close 1
                    close 2
                    kill "scores2.hig"
                    goto done1
                endif
            next
        endif
        done1:
        slptim = timer
        do
        loop until timer > (slptim + 2)
        scoret1+=10-score2
        goto menu
    endif
elseif score2 = 10 then
    if gametype = 1 then
        cls
        locate 18,46
        print "voce perdeu"
        locate 19,46
        print "pontuacao final: ";scoret1
        open "scores.hig" for input as 1
        if eof(1) then
            close 1
            locate 20,46
            input "novo recorde, digite seu nome: ", nome1
            open "scores.hig" for output as 1
            print #1, nome1
            print #1, scoret1
            print #1, "Anonimo"
            print #1, " 0"
            print #1, "Anonimo"
            print #1, " 0"
            print #1, "Anonimo"
            print #1, " 0"
            print #1, "Anonimo"
            print #1, " 0"
            close 1
        else
            for i = 1 to 5
                input #1, nomer
                input #1, scorer
                if scoret1 > scorer then
                    locate 20,46
                    input "novo recorde, digite seu nome: ", nome1
                    close 1
                    open "scores.hig" for input as 1
                    open "scores2.hig" for output as 2
                    for r = 1 to 5
                        input #1, nomer
                        input #1, scorer
                        print #2, nomer
                        print #2, scorer
                    next
                    close 1
                    close 2
                    open "scores2.hig" for input as 1
                    open "scores.hig" for output as 2
                    if i > 1 then
                        for r = 1 to i-1
                            input #1, nomer
                            input #1, scorer
                            print #2, nomer
                            print #2, scorer
                        next
                    endif
                    print #2, nome1
                    print #2, scoret1
                    if i < 5 then
                        for r = i+1 to 6
                            input #1, nomer
                            input #1, scorer
                            print #2, nomer
                            print #2, scorer
                        next
                    endif
                    close 1
                    close 2
                    kill "scores2.hig"
                    goto done2
                endif
            next
        endif
        done2:
        slptim = timer
        do
        loop until timer > (slptim + 2)
        goto menu
    else
        level+= 1
        scoret1+=score1-score2
        scoret2+=score2-score1
        score1 = 0
        score2 = 0
        if level = 5 then
            locate 18,40
            print "parabens"
            locate 19,40
            print "voces terminaram o jogo"
            locate 20,40
            if scoret1 > scoret2 then
                print "o jogador 1 venceu"
            elseif scoret1 < scoret2 then
                print "o jogador 2 venceu"
            else                                   'modificado por Cristiano
                print "os dois jogadores empataram"'modificado por Cristiano
            endif
            slptim = timer
            do
            loop until timer > (slptim + 2)
            scoret1+=score1-score2
            scoret2+=score2-score1
            goto menu
        endif
    endif
endif
padx(0) = 100: padx(1) = 700-32 'posições
pady(0) = 300-64: pady(1) = 300-64
balx(0) = 400-32-32
baly(0) = 300-16
levelstuff
balvelx = speed*f
f = f*-1
balvely = rnd(1)*speed-speed/2
cls
locate 17,47
print "nivel ";level
locate 18,46
print "prepare-se"
slptim = timer
do
loop until timer > (slptim + 1)
if gametype = 1 then goto jogo1p
if gametype = 2 then goto jogo2p

jogo1p:
if multikey(FB.SC_UP) then if pady(0) > 10 then pady(0)-=speed+1 'teclas
if multikey(FB.SC_DOWN) then if pady(0) < 590-128 then pady(0)+=speed+1
if inkey$ = chr$(255)+"k" then
    liberatudo
    Mix_CloseAudio()
    SDL_Quit()
    end
endif
if multikey(fb.sc_escape) then
    put (0,0),preto,alpha,127
    locate 6,46
    print "tem certeza de que deseja sair? (S/N)"
    do until multikey(fb.sc_n)
    if multikey(fb.sc_s) then goto menu
    loop
endif
'if pady(0) > baly(0) and balx(0) < 250+16 then if pady(0) > 10 then pady(0)-=speed-1 'IA besta
'if pady(0)+128 < baly(0)+32 and balx(0) < 250+16 then if pady(0) < 590-128 then pady(0)+=speed-1
if pady(1) > baly(0) and balx(0) > 250-16 then if pady(1) > 10 then pady(1)-=speed-1 'IA besta
if pady(1)+128 < baly(0)+32 and balx(0) > 250-16 then if pady(1) < 590-128 then pady(1)+=speed-1
engine
if resetgame = 1 then goto resett
sleep 6
goto jogo1p 'rinse and repeat

jogo2p:
if multikey(FB.SC_W) then if pady(0) > 10 then pady(0)-=speed+1 'teclas 1p
if multikey(FB.SC_S) then if pady(0) < 590-128 then pady(0)+=speed+1
if inkey$ = chr$(255)+"k" then
    liberatudo
    Mix_CloseAudio()
    SDL_Quit()
    end
endif
if multikey(fb.sc_escape) then
    put (0,0),preto,alpha,127
    locate 6,46
    print "tem certeza de que deseja sair? (S/N)"
    do until multikey(fb.sc_n)
    if multikey(fb.sc_s) then goto menu
    loop
endif
if multikey(FB.SC_O) then if pady(1) > 10 then pady(1)-=speed+1 'teclas 2p
if multikey(FB.SC_L) then if pady(1) < 590-128 then pady(1)+=speed+1
engine
if resetgame = 1 then goto resett
sleep 6
goto jogo2p 'rinse and repeat

sub engine
    balx(6) = balx(5): baly(6) = baly(5) 'sombras
    balx(5) = balx(4): baly(5) = baly(4)
    balx(4) = balx(3): baly(4) = baly(3)
    balx(3) = balx(2): baly(3) = baly(2)
    balx(2) = balx(1): baly(2) = baly(1)
    balx(1) = balx(0): baly(1) = baly(0)
    balx(0)+=balvelx
    baly(0)+=balvely
    if baly(0) < 0 then 'corra bola, corra
        hit = 1
        baly(0) = 0
        balvely=balvely*-1
    elseif baly(0) > 600-32 then
        hit = 1
        baly(0) = 600-32
        balvely=balvely*-1
    endif
    if balx(0) <= 0 then
        if sfx = 1 then mix_playchannel(-1,ponto,0)
        score2+=1
        resetgame = 1
        exit sub
    elseif balx(0) >= 800-32 then
        if sfx = 1 and score1+1 < 10 then mix_playchannel(-1,ponto2,0)
        score1+=1
        resetgame = 1
        exit sub
    endif
    if balx(0) < padx(0)+32 and baly(0) < pady(0)+32 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0) then 'bate bola jogo rápido
        hit = 2
        balx(0) = padx(0)+32
        balvelx=balvelx*-1: balvely-=speed
    elseif balx(0) < padx(0)+32 and baly(0) < pady(0)+64 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0)+32 then
        hit = 2
        balx(0) = padx(0)+32
        balvelx=balvelx*-1: balvely-=int(speed/2)
    elseif balx(0) < padx(0)+32 and baly(0) < pady(0)+96 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0)+64 then
        hit = 2
        balx(0) = padx(0)+32
        balvelx=balvelx*-1: balvely+=int(speed/2)
    elseif balx(0) < padx(0)+32 and baly(0) < pady(0)+128 and balx(0)+32 > padx(0) and baly(0)+32 > pady(0)+96 then
        hit = 2
        balx(0) = padx(0)+32
        balvelx=balvelx*-1: balvely+=speed
    elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+32 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1) then
        hit = 3
        balx(0) = padx(1)-32
        balvelx=balvelx*-1: balvely-=speed
    elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+64 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1)+32 then
        hit = 3
        balx(0) = padx(1)-32
        balvelx=balvelx*-1: balvely-=int(speed/2)
    elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+96 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1)+64 then
        hit = 3
        balx(0) = padx(1)-32
        balvelx=balvelx*-1: balvely+=int(speed/2)
    elseif balx(0) < padx(1)+32 and baly(0) < pady(1)+128 and balx(0)+32 > padx(1) and baly(0)+32 > pady(1)+96 then
        hit = 3
        balx(0) = padx(1)-32
        balvelx=balvelx*-1: balvely+=speed
    elseif balx(0) < blox(0)+64 and baly(0) < bloy(0)+64 and balx(0)+32 > blox(0) and baly(0)+32 > bloy(0)+4 then
        hit = 1: balvelx=balvelx*-1: balvely=balvely*-1
    elseif balx(0) < blox(1)+64 and baly(0) < bloy(1)+64 and balx(0)+32 > blox(1) and baly(0)+32 > bloy(1) then
        hit = 1: balvelx=balvelx*-1: balvely=balvely*-1
    endif
    bloy(0)+=blod(0)
    bloy(1)+=blod(1)
    if bloy(0) < 0 or bloy(0) > 600-64 then blod(0)*=-1
    if bloy(1) < 0 or bloy(1) > 600-64 then blod(1)*=-1
    if sfx = 1 then
        if hit = 1 then
            mix_playchannel(-1,batida,0)
        elseif hit = 2 then
            mix_playchannel(-1,ping,0)
        elseif hit = 3 then
            mix_playchannel(-1,pong,0)
        endif
        if hit <> 0 then hit = 0
    endif
    if gfx = 1 then screenlock 'desenha tudo
    cls
    print ,,nome1;": ";score1, nome2;": ";score2
    put (padx(0),pady(0)),pad,alpha,255
    put (padx(1),pady(1)),pad,alpha,255
    put (balx(6),baly(6)),ball,alpha,55
    put (balx(3),baly(3)),ball,alpha,155
    put (balx(0),baly(0)),ball,alpha,255
    put (blox(0),bloy(0)),bloco,alpha,255
    put (blox(1),bloy(1)),bloco,alpha,255
    if gfx = 1 then screenunlock
end sub

sub liberatudo
    Mix_FreeMusic(menumus)
    Mix_FreeChunk(batida)
    Mix_FreeChunk(aceita)
    Mix_FreeChunk(clique)
    Mix_FreeChunk(ping)
    Mix_FreeChunk(pong)
    Mix_FreeChunk(ponto)
    Mix_FreeChunk(ponto2)
end sub

sub levelstuff
    if level = 1 then
        blox(0) = -100
        bloy(0) = -100
        blox(1) = -100
        bloy(1) = -100
    elseif level = 2 then
        blox(0) = -100
        bloy(0) = -100
        blod(1) = 0
        blox(1) = 400-32
        bloy(1) = 300-32
    elseif level = 3 then
        blox(0) = -100
        bloy(0) = -100
        blod(1) = 2
        blox(1) = 400-32
        bloy(1) = 300-32
    elseif level = 4 then
        blod(0) = 0
        blox(0) = 400-32
        bloy(0) = 200-32
        blod(1) = 0
        blox(1) = 400-32
        bloy(1) = 400-32
    elseif level = 5 then
        blod(0) = 2
        blox(0) = 300-32
        bloy(0) = 300-32
        blod(1) = -2
        blox(1) = 500-32
        bloy(1) = 300-32
    end if
end sub
