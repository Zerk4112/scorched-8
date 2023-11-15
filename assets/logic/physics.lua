-- PICO-8 LUA
-- Physics code

gravity = 0.2
friction = 0.99
terminal_velocity = 5

function poke_phys(obj)
    -- Apply gravity
    obj.dy += gravity

    -- Apply terminal velocity
    if obj.dy > terminal_velocity then
        obj.dy = terminal_velocity
    end

    -- Apply friction
    obj.dx *= friction
    obj.dy *= friction

    -- Apply velocity
    obj.x += obj.dx
    obj.y += obj.dy

    -- Check for collisions
    -- if obj.x < 0 then
    --     obj.x = 0
    --     obj.dx *= -1
    -- end
    -- if obj.x > 128 then
    --     obj.x = 128
    --     obj.dx *= -1
    -- end
    -- if obj.y < 0 then
    --     obj.y = 0
    --     obj.dy *= -1
    -- end
    -- if obj.y > 128 then
    --     obj.y = 128
    --     obj.dy *= -1
    -- end
end