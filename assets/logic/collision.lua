-- PICO-8 LUA
-- Logic to handle collisions between common objects

function pixel_collision(x1, y1, x2, y2)
    return x1 == x2 and y1 == y2
end

function object_collision(obj1, obj2)
    return pixel_collision(obj1.x, obj1.y, obj2.x, obj2.y)
end

function box_collision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x1 + w1 > x2 and
        y1 < y2 + h2 and
        y1 + h1 > y2
end

function object_to_object_box_collision(obj1, obj2)
    return box_collision(obj1.x, obj1.y, obj1.w, obj1.h, obj2.x, obj2.y, obj2.w, obj2.h)
end

function debug_draw_collision_box(x, y, w, h)
    rect(x, y, x + w, y + h, 8)
end

function debug_draw_collision_box_object(obj)
    debug_draw_collision_box(obj.x, obj.y, obj.w, obj.h)
end

function check_terrain_collision(tank, _yo)
    local x = flr(tank.x)+tank.colx
    local y = flr(tank.y)+tank.coly
    local x2 = flr(tank.x)+tank.colx2
    local y2 = flr(tank.y)+tank.coly2
    local front_collision = poke_terrain(test_terrain, x2,y2)==1
    local back_collision = poke_terrain(test_terrain,x,y)==1
    local front_above_collision  = poke_terrain(test_terrain,x2,y2-1)==1
    local front_above_collision2 = poke_terrain(test_terrain,x2,y2-2)==1
    local front_below_collision = poke_terrain(test_terrain,x2,y2+1)==1
    local back_below_collision = poke_terrain(test_terrain,x,y+1)==1
    return front_collision, back_collision, front_above_collision, front_above_collision2, front_below_collision, back_below_collision
end