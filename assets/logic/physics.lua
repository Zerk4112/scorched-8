-- PICO-8 LUA
-- Physics code

gravity = 0.6
friction = 0.99
terminal_velocity = 5
enable_collision = false
function poke_phys(obj)
    -- Apply gravity
    obj.dy += gravity

    -- Apply terminal velocity
    if obj.dy > terminal_velocity then
        obj.dy = terminal_velocity
    end

    -- Apply friction
    -- obj.dx *= friction
    -- obj.dy *= friction

    -- Calculate collisions
    if obj.type==0 then
        local newx = obj.x + obj.dx
        local newy = obj.y + obj.dy
        if newx < 3 or newx>125 then
            return false -- dont let the user move off the screen
        end
        local fc,bc,fca,fca2,fcb, bcb = check_terrain_collision(obj)
        -- Check if colliding with wall. If so, negate velocity
        if fc and fca and fca2 then
            obj.dx = 0
        elseif fc and fca and not fca2 then
            obj.dx=0
            obj.y-=2
        elseif fc and not fca then
        -- if there is a collision but not with the front corner, move the object up in the y direction
            obj.y -= 1
        end

        -- if the front corner is colliding with the ground and there is no collision with the back or the back corner, move the character backwards out of the wall
        if fc and fca and not bc then
            obj.dx=0
            if obj.sprite_flip then
                obj.x += 0.1
            else
                obj.x -= 0.1
            end
            printh("backing out of wall.. dx/dy: "..obj.dx.."/"..obj.dy)
        end
        -- Check if colliding with ground or at y==127. If so, negate gravity
        if (fcb or bcb) or newy >= 125 then
            obj.dy = 0
            obj.falling=false
            if (enable_collision) handle_fall(obj)
        elseif not fcb and not bcb and not obj.falling then
            obj.falling=true
            obj.y_started_falling=obj.y
        end
    end

    -- Apply velocity
    obj.x += obj.dx
    obj.y += obj.dy
    
    return true
end

function handle_fall(obj)
    if obj.y_started_falling ~= nil then
        local pixels_fallen = obj.y - obj.y_started_falling
        if pixels_fallen > 10 then
            obj.alive = false
        end
    end
end