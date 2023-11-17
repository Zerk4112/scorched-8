-- tank.lua
-- object code for a pico-8 remake of scorched earth
-- #include ../../lib/coroutines.lua
tanks = {}
tank_sprites = {1,2,3,4}
function create_tank(x,y)
    local tank = {
        type=0,
        id=#tanks+1,
        x=x,
        y=y,
        dx=0,
        dy=0,
        w=4,
        h=4,
        cx=1,
        cy=0,
        colx=1,
        coly=3,
        colx2=3,
        coly2=3,
        mspd=0.2,
        angle=0,
        fuel=50,
        max_fuel=50,
        falling=false,
        y_started_falling=0,
        -- sprite=tank_sprites[flr(rnd(#tank_sprites)+1)],
        sprite=5,
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
    local x = tank.x
    if tank.sprite_flip then x-=5 end
    if debug then
        local angle
        if tank.sprite_flip then 
            angle = map_range(tank.angle,0.5,0,0,90)
        else    
            angle = map_range(tank.angle,0,0.5,0,90)
        end
        print("fuel: "..tank.fuel,tank.x,tank.y-10,7)
    end

    spr(tank.sprite,x,tank.y,1,1,tank.sprite_flip)
    draw_tank_crosshair(tank)
    pset(tank.x+tank.colx,tank.y+tank.coly,8)
    pset(tank.x+tank.colx2,tank.y+tank.coly2,10)

end

function draw_tank_crosshair(tank)
    local x = tank.x + tank.cx
    local y = tank.y + tank.cy
    local angle = tank.angle
    -- local r = 8
    local x2 = x + cos(angle)*3
    local y2 = y + sin(angle)*3
    line(x,y,x2,y2,1)
    pset(x2,y2,6)
end

function handle_fuel(tank)
    if tank.fuel > 0 then
        tank.fuel -= 0.1
        return true
    else
        tank.fuel = 0
    end
    return false
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
        if not tank.falling then
            if btn(0) and handle_fuel(tank) then 
                tank.sprite_flip=true
                tank.dx = -tank.mspd
            elseif btn(1) and handle_fuel(tank) then 
                tank.sprite_flip=false
                tank.dx = tank.mspd
            else 
                tank.dx = 0
            end
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
            tank.dy = -1
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
    poke_phys(tank)
    if tank.sprite_flip then
        tank.colx2 = -1
    else
        tank.colx2 = 3
    end
end

