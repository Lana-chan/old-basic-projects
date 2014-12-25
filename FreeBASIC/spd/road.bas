#include "fbgfx.bi"
screenres 640,480,16
dim as integer road_x, scanline, x(6), z, middle, road_mode, base_x, road_factor, real_z, tgt_fact
dim as double zspeed, road_z
middle = 320
road_factor = 0
road_mode = 2
do
    screenlock
    for scanline = 250 to 30 step -1
        z = 128*128 / scanline
        real_z = z + road_z

        if road_mode = 0 then base_x = road_x
        if road_mode = 1 then base_x = road_x + (((z - 192) * (z - 192) / 512) * road_factor / 256)
        if road_mode = 2 then base_x = road_x - (((z - 192) * (z - 192) / 512) * road_factor / 256)

        x(0) = ((-152 - base_x) * 128) / z + middle
        x(1) = ((-128 - base_x) * 128) / z + middle
        x(2) = ((-6 - base_x) * 128) / z + middle
        x(3) = ((6 - base_x) * 128) / z + middle
        x(4) = ((128 - base_x) * 128) / z + middle
        x(5) = ((152 - base_x) * 128) / z + middle
        z += road_z/5
        'color = (z & 64) ? 1 : 0
        line (0, scanline + 230)-(x(0)-1, scanline + 230), rgb(0,int(sin(z*.05))*16+127,0)
        line (x(0), scanline + 230)-(x(1) - 1, scanline + 230), rgb(int(sin(z*.05))*16+127,0,0)
        line (x(1), scanline + 230)-(x(2) - 1, scanline + 230), rgb(int(sin(z*.05))*16+127,int(sin(z*.05))*16+127,int(sin(z*.05))*16+127)
        line (x(2), scanline + 230)-(x(3) - 1, scanline + 230), rgb(int(sin(z*.05))*63+180,int(sin(z*.05))*63+180,int(sin(z*.05))*63+180)
        line (x(3), scanline + 230)-(x(4) - 1, scanline + 230), rgb(int(sin(z*.05))*16+127,int(sin(z*.05))*16+127,int(sin(z*.05))*16+127)
        line (x(4), scanline + 230)-(x(5) - 1, scanline + 230), rgb(int(sin(z*.05))*16+127,0,0)
        line (x(5), scanline + 230)-(799, scanline + 230), rgb(0,int(sin(z*.05))*16+127,0)
    next
    screenunlock
    road_z+=zspeed
    if road_factor > tgt_fact then road_factor-=5
    if road_factor < tgt_fact then road_factor+=5
    if multikey(fb.sc_left) then road_x-=1
    if multikey(fb.sc_right) then road_x+=1
    if multikey(fb.sc_down) and zspeed > 0 then zspeed-=.01
    if multikey(fb.sc_up) and zspeed < 5 then zspeed+=.01
    if multikey(fb.sc_up) = 0 and multikey(fb.sc_down) = 0 and zspeed > 0 then zspeed-=.005
    if multikey(fb.sc_x) then tgt_fact = 0
    if multikey(fb.sc_z) then tgt_fact=-500
    if multikey(fb.sc_c) then tgt_fact=500
    if multikey(fb.sc_escape) then end
    'sleep 1
loop
