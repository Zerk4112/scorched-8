-- tank.lua
-- object code for a pico-8 remake of scorched earth
-- #include ../../lib/coroutines.lua
tanks = {}
tank_sprites = {1,2,3,4}
function create_tank(x,y)
    local tank = {
        id=#tanks+1,
        x=x,
        y=y,
        dx=0,
        dy=0,
        cx=3,
        cy=3,
        mspd=1,
        angle=0,
        -- sprite=tank_sprites[flr(rnd(#tank_sprites)+1)],
        sprite=3,
        sprite_flip=false,
        update = make_cr(update_tank),
        draw = make_cr(draw_tank, aroutines),
        alive=true,
    }
    poke_cr(tank.update,tank)
    poke_cr(tank.draw,tank)
    -- coresume(tank.update,tank)
    -- coresume(tank.draw,tank)
    add(tanks,tank)
    return tank
end


function update_tank(tank)
    while tank.alive do
        control_tank(tank)
        move_tank(tank)
        yield()
    end
    -- tank.x += tank.speed
end

function draw_tank(tank)
    while tank.alive do
        draw_tank_sprite(tank)
        yield()
    end
end

function draw_tank_sprite(tank)
    if debug then
        local angle
        if tank.sprite_flip then 
            angle = map_range(tank.angle,0.5,0,0,90)
        else    
            angle = map_range(tank.angle,0,0.5,0,90)
        end
        print("angle: "..round_float(angle,2).." sprite_flip: "..tostr(tank.sprite_flip),tank.x+4,tank.y-8,7)
    end
    spr(tank.sprite,tank.x,tank.y,1,1,tank.sprite_flip)
    draw_tank_crosshair(tank)

end

function draw_tank_crosshair(tank)
    local x = tank.x + tank.cx
    local y = tank.y + tank.cy
    local angle = tank.angle
    -- local r = 8
    local x2 = x + cos(angle)*5
    local y2 = y + sin(angle)*5
    line(x,y,x2,y2,7)
end

function control_tank(tank)
    local prev_direction = tank.sprite_flip

    if btn(4) then
        -- If O button is held, then control the tanks aiming and power
        tank.dx=0 -- stop the tank, don't allow movement while O button is held
        if btn(0) then
            tank.angle += 0.001
            -- if tank.angle < -1 then tank.angle = 0.5 end
        elseif btn(1) then
            tank.angle -= 0.001
        end
    else
        -- If O button is not held, then control the tanks movement
        if btn(0) then 
            tank.sprite_flip=true
            tank.dx = -tank.mspd
        elseif btn(1) then 
            tank.sprite_flip=false
            tank.dx = tank.mspd
        else 
            tank.dx = 0
        end

        -- If the tank's direction has changed, reverse the angle.
        if prev_direction ~= tank.sprite_flip then
            local a = tank.angle
            tank.angle = 1 - a
            tank.angle+=0.5
        end

        if btn(2) then
            tank.dy = -tank.mspd
        elseif btn(3) then
            tank.dy = tank.mspd
        else
            tank.dy = 0
        end
        

    end
    tank.angle%=1
    if tank.angle > 0.5 then tank.angle -=0.5 tank.sprite_flip = not tank.sprite_flip end
    if tank.angle < 0.25 then
        tank.sprite_flip = false
    else
        tank.sprite_flip = true
    end
end

function move_tank(tank)
    tank.x += tank.dx
    tank.y += tank.dy
    if tank.sprite_flip then
        tank.cx = 4
    else
        tank.cx = 3
    end
end
