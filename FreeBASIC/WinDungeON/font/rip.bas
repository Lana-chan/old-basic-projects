screenres 8,8,24
dim as integer ix, iy, x, y
dim as ubyte li
dim font as any ptr
font = imagecreate(128,128)
Bload "CGA8x8thick.bmp", font

open "font.bin" for binary as 1
for iy = 0 to 15
    for ix = 0 to 15
        cls
        put (-(ix*8),-(iy*8)),font
        for y = 0 to 7
            li = 0
            for x = 0 to 7
                if point(x,y)=&hFFFFFF then li+=2^x
            next
            put #1,, li
        next
    next
next
close #1
