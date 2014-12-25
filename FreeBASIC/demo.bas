#include "fbgfx.bi"
screen 18,32
dim shared a(8,8) as integer
dim shared b(8,8) as integer
dim shared c(8,8) as integer
dim shared d(8,8) as integer
dim shared e(8,8) as integer
dim shared f(8,8) as integer
dim shared g(8,8) as integer
dim shared h(8,8) as integer
dim shared i(8,8) as integer
dim shared j(8,8) as integer
dim shared k(8,8) as integer
dim shared l(8,8) as integer
dim shared m(8,8) as integer
dim shared n(8,8) as integer
dim shared o(8,8) as integer
dim shared p(8,8) as integer
dim shared q(8,8) as integer
dim shared r(8,8) as integer
dim shared s(8,8) as integer
dim shared t(8,8) as integer
dim shared u(8,8) as integer
dim shared v(8,8) as integer
dim shared w(8,8) as integer
dim shared x(8,8) as integer
dim shared y(8,8) as integer
dim shared z(8,8) as integer
dim shared comma(8,8) as integer
dim shared dot(8,8) as integer
dim shared excl(8,8) as integer
dim speed(15) as integer
dim letter(15) as string
dim lettern(15) as integer
dim x1(15) as integer
dim y1(15) as integer
dim scalex as integer
dim scaley as integer
dim f1 as integer
dim f2 as integer
dim message as string

declare sub tprint(letter as string, x1 as integer, y1 as integer, scalex as integer, scaley as integer)
declare sub awesomepixel()

for f1 = 0 to 7
    for f2 = 0 to 7
        read a(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read b(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read c(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read d(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read e(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read f(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read g(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read h(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read i(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read j(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read k(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read l(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read m(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read n(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read o(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read p(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read q(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read r(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read s(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read t(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read u(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read v(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read w(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read x(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read y(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read z(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read comma(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read dot(f2,f1)
    next
next
for f1 = 0 to 7
    for f2 = 0 to 7
        read excl(f2,f1)
    next
next


for f1 = 1 to 15
    lettern(f1-1) = f1
    x1(f1-1)=650+f1*50
    y1(f1-1)=50+f1*50
    speed(f1-1) = -5
next
message = "look at how bulky this mess is, oh my god what the fuck.............."
do until multikey(fb.sc_escape) or multikey(fb.sc_enter) or inkey$ = chr$(255)+"k"
    screenlock
    cls
    for f1 = 0 to 14
        letter(f1) = mid$(message,lettern(f1),1)
        tprint (letter(f1), x1(f1), y1(f1), 2, 2)
        if x1(f1) > -105 then
            x1(f1)-=2
        else
            x1(f1)=650
            if lettern(f1)+15 > len(message) then
                lettern(f1)=lettern(f1)-len(message)+15
            else
                lettern(f1)+=15
            endif
        endif
        y1(f1)=(cos(x1(f1)*0.02)*40)+400
    next
    screenunlock
    sleep 5
loop
end

sub tprint(letter as string, x1 as integer, y1 as integer, scalex1 as integer, scaley1 as integer)
    dim x2 as integer
    dim y2 as integer
    dim endletter(8,8) as integer
    letter = lcase$(letter)
    if letter = "a" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = a(x2,y2)
            next
        next
    elseif letter = "b" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = b(x2,y2)
            next
        next
    elseif letter = "c" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = c(x2,y2)
            next
        next
    elseif letter = "d" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = d(x2,y2)
            next
        next
    elseif letter = "e" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = e(x2,y2)
            next
        next
    elseif letter = "f" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = f(x2,y2)
            next
        next
    elseif letter = "g" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = g(x2,y2)
            next
        next
    elseif letter = "h" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = h(x2,y2)
            next
        next
    elseif letter = "i" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = i(x2,y2)
            next
        next
    elseif letter = "j" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = j(x2,y2)
            next
        next
    elseif letter = "k" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = k(x2,y2)
            next
        next
    elseif letter = "l" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = l(x2,y2)
            next
        next
    elseif letter = "m" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = m(x2,y2)
            next
        next
    elseif letter = "n" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = n(x2,y2)
            next
        next
    elseif letter = "o" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = o(x2,y2)
            next
        next
    elseif letter = "p" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = p(x2,y2)
            next
        next
    elseif letter = "q" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = q(x2,y2)
            next
        next
    elseif letter = "r" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = r(x2,y2)
            next
        next
    elseif letter = "s" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = s(x2,y2)
            next
        next
    elseif letter = "t" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = t(x2,y2)
            next
        next
    elseif letter = "u" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = u(x2,y2)
            next
        next
    elseif letter = "v" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = v(x2,y2)
            next
        next
    elseif letter = "w" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = w(x2,y2)
            next
        next
    elseif letter = "x" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = x(x2,y2)
            next
        next
    elseif letter = "y" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = y(x2,y2)
            next
        next
    elseif letter = "z" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = z(x2,y2)
            next
        next
    elseif letter = "," then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = comma(x2,y2)
            next
        next
    elseif letter = "." then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = dot(x2,y2)
            next
        next
    elseif letter = "!" then
        for y2 = 0 to 7
            for x2 = 0 to 7
                endletter(x2,y2) = excl(x2,y2)
            next
        next
    endif
    for y2 = 0 to 7
        for x2 = 0 to 7
            'if endletter(x2,y2) = 1 then line (x1+x2+(scalex1*(x2+1)+1),y1+y2+scaley1*(y2+1))-(x1+(scalex1*(x2+1)+1)+scalex1-1,y1+(scaley1*(y2+1))+scaley1-1),,bf 'gradual
            'if endletter(x2,y2) = 1 then line (x1+x2+(scalex1*(x2+1)+1),y1+y2+scaley1*(y2+1))-(x1+x2*scalex1+y2,y1+y2*scaley1+x2),,bf 'wonky
            if endletter(x2,y2) = 1 then line (x1+x2+(scalex1*(x2+1)+1),y1+y2+scaley1*(y2+1))-(x1+x2*scalex1+x2+1,y1+y2*scaley1+y2),,bf 'original
        next
    next
end sub

'a
data 0,0,1,1,1,1,0,0
data 0,1,1,0,0,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,1,1,1,1,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
'b
data 1,1,1,1,1,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,1,1,1,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,1,1,1,1,1,0
'c
data 0,0,1,1,1,1,1,1
data 0,1,1,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 0,1,1,0,0,0,0,0
data 0,0,1,1,1,1,1,1
'd
data 1,1,1,1,1,1,0,0
data 1,1,0,0,0,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,1,1,0
data 1,1,1,1,1,1,0,0
'e
data 1,1,1,1,1,1,1,1
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,1,1,1,1,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,1,1,1,1,1,1
'f
data 1,1,1,1,1,1,1,1
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,1,1,1,1,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
'g
data 0,0,1,1,1,1,0,0
data 0,1,1,0,0,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,0,0
data 1,1,0,0,1,1,1,1
data 1,1,0,0,0,0,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,0
'h
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,1,1,1,1,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
'i
data 0,0,1,1,1,1,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,1,1,1,1,0,0
'j
data 0,0,1,1,1,1,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 1,1,0,1,1,0,0,0
data 0,1,1,1,0,0,0,0
'k
data 1,1,0,0,0,1,1,0
data 1,1,0,0,1,1,0,0
data 1,1,0,1,1,0,0,0
data 1,1,1,1,0,0,0,0
data 1,1,0,1,1,0,0,0
data 1,1,0,0,1,1,0,0
data 1,1,0,0,0,1,1,0
data 1,1,0,0,0,0,1,1
'l
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,1,1,1,1,1,1
'm
data 1,1,0,0,0,0,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,1
data 1,1,0,1,1,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
'n
data 1,1,0,0,0,0,1,1
data 1,1,1,0,0,0,1,1
data 1,1,1,1,0,0,1,1
data 1,1,0,1,1,0,1,1
data 1,1,0,0,1,1,1,1
data 1,1,0,0,0,1,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
'o
data 0,0,1,1,1,1,0,0
data 0,1,1,0,0,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,0
'p
data 1,1,1,1,1,1,0,0
data 1,1,0,0,0,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,1,1,0
data 1,1,1,1,1,1,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
'q
data 0,0,1,1,1,1,0,0
data 0,1,0,0,0,0,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,1,0,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,1
'r
data 1,1,1,1,1,1,0,0
data 1,1,0,0,0,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,1,1,0
data 1,1,1,1,1,1,0,0
data 1,1,0,0,0,1,1,0
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
's
data 0,0,1,1,1,1,1,1
data 0,1,1,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,0,0,0,1,1,1,0
data 0,0,0,0,0,0,1,1
data 0,0,0,0,0,1,1,0
data 1,1,1,1,1,1,0,0
't
data 1,1,1,1,1,1,1,1
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
'u
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,0
'v
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,0
data 0,0,0,1,1,0,0,0
'w
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,1,1,0,1,1
data 1,1,0,1,1,0,1,1
data 1,1,0,1,1,0,1,1
data 0,1,1,1,1,1,1,0
data 0,0,1,0,0,1,0,0
'x
data 1,1,0,0,0,0,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,1,1,1,1,0,0
data 0,1,1,0,0,1,1,0
data 1,1,0,0,0,0,1,1
'y
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 1,1,0,0,0,0,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
'z
data 1,1,1,1,1,1,1,1
data 0,0,0,0,0,1,1,0
data 0,0,0,0,1,1,0,0
data 0,0,0,1,1,0,0,0
data 0,0,1,1,0,0,0,0
data 0,1,1,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,1,1,1,1,1,1
'comma
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,0,1,0,0,0
data 0,0,0,0,1,0,0,0
'dot
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,0,0,0,0,0
'exclamation
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,0,1,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,0,0,0,0,0
