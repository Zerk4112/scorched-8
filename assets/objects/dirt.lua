-- PICO-8 LUA
-- Dirt Object Code

dirtpile = {}

function create_dirt(x,y)
    local d = {
        type = 1,
        x=x,
        y=y,
        dx=0,
        dy=0,
        w=1,
        h=1,
        color=7,
        update = make_cr(update_dirt),
        draw = make_cr(draw_dirt,aroutines),
        alive = true,
        moving = false,
    }
    poke_cr(d.update,d)
    poke_cr(d.draw,d)
    add(dirtpile,d)
    return d
end

function toggle_dirt_movement()
    for d in all(dirtpile) do
        d.moving = not d.moving
    end
end

function update_dirt(dirt)
    while dirt.moving do
        if not poke_phys(dirt) then
            dirt.moving=false
        end
        yield()
    end
end

function draw_dirt(dirt)
    while dirt.alive do
        pset(dirt.x,dirt.y,7)
        yield()
    end
end

function find_dirt_by_xy(x,y)
    for d in all(dirtpile) do
        if flr(d.x)==flr(x) and flr(d.y)==flr(y) then
            return d
        end
    end
    return nil
end