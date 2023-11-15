pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

-- template for pico-8 games / experiments

-- include common libraries
#include ../lib/coroutines.lua
#include ../lib/mouse.lua
#include ../lib/math.lua

-- include game objects
#include ../assets/objects/tank.lua
#include ../assets/objects/dirt.lua

-- include game functions
#include ../assets/logic/physics.lua

function _init()
    -- bkgr_clr = randib(0, 15)
    bkgr_clr = 0
    debug = true
    mouse_init()
    test_tank = create_tank(64, 64)
end


function _update60()
    poke_crs(coroutines)
    if (m_clk) then
        printh("mouse clicked")
        create_dirt(m_x, m_y)
    end
end


function _draw()
    cls(bkgr_clr)
    poke_crs(aroutines)
    if debug then
        print("coroutines: " .. #coroutines, 0, 0, 7)
        print("aroutines: " .. #aroutines, 0, 7, 7)
        print("dirtpile: " .. #dirtpile, 0, 14, 7)
    end
    if (m_on) draw_m()
end

__gfx__
d6660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60010000000000000000000000700000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001000000700000707070007700000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777007777777077777770777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000707070707070707070707070707077070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777707777777007777700077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000