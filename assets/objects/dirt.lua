-- PICO-8 LUA
-- Dirt Object Code

dirtpile = {}

function create_dirt(x,y)
    local d = {
        x=x,
        y=y,
        dx=0,
        dy=0,
        color=7,
        update = make_cr(update_dirt),
        draw = make_cr(draw_dirt,aroutines),
        alive = true
    }
    poke_cr(d.update,d)
    poke_cr(d.draw,d)
    add(dirtpile,d)
    return d
end

function update_dirt(dirt)
    while dirt.alive do
        poke_phys(dirt)
        yield()
    end
end

function draw_dirt(dirt)
    while dirt.alive do
        pset(dirt.x,dirt.y,7)
        yield()
    end
end

