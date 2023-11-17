-- PICO-8 LUA
-- terrain.lua contains logic for generating terrain into a table for the purpose of rendering this 'image' to the screen and having it available for collision detection and other game logic

function init_terrain(h,w)
    local terrain = {}
    for i=1,h do
        terrain[i] = {}
        for j=1,w do
            terrain[i][j] = 0
        end
    end
    return terrain
end

function save_to_sprite_sheet(terrain)
    local w = #terrain
    local h = #terrain[1]
    printh("saving to sprite sheet")
    for i=1,w do
        for j=h,1,-1 do
            local x = i
            local y = j
            local isDirt = terrain[i][j] == 1

            if isDirt then
                sset(x,y,5)
            end
        end
    end

end

function generate_terrain(w, h)
    printh("generating terrain")
    local terrain = init_terrain(h,w)
    for x = 1, w do
        terrain[x] = {}
        local hill_height = flr(40 + 60 * rnd())

        for y = h,1, -1 do
            terrain[x][y] = y > hill_height and 1 or 0
        end
    end
    -- add a random amount of hills in random x offsets
    for i=1,flr(10+rnd(10)) do
        local x = flr(rnd(w))
        local radius = flr(10+rnd(10))
        local mode = flr(rnd(2))
        edit_terrain(terrain, x,nil, radius, mode)
    end
    settle_terrain(terrain, 10)
    return smooth_terrain(terrain)
    -- return terrain
end

function smooth_terrain(terrain)
    local smoothedTerrain = {}
    
    for x = 1, #terrain do
        smoothedTerrain[x] = {}
        
        for y = 1, #terrain[x] do
            local sum = 0
            local count = 0
            
            -- Simple average over a larger neighborhood
            for dx = -3, 3 do
                for dy = -3, 3 do
                    if terrain[x + dx] and terrain[x + dx][y + dy] then
                        sum = sum + terrain[x + dx][y + dy]
                        count = count + 1
                    end
                end
            end
            
            -- Set the smoothed value as the average
            smoothedTerrain[x][y] = flr(sum / count) or 0 
        end
    end
    
    return smoothedTerrain
end

function settle_terrain(terrain)
    local changed = true

    while changed do
        changed = false

        for x = 1, #terrain do
            for y = 1, #terrain[x] do
                if terrain[x][y] == 1 and terrain[x][y + 1] == 0 then
                    -- Move dirt down if there's empty space below
                    terrain[x][y] = 0
                    terrain[x][y + 1] = 1
                    changed = true
                end
            end
        end
    end
end



function edit_terrain(terrain, centerX, centerY, radius, mode)
    local mode = mode or 0
    local cy = centerY
    if (cy==nil) cy=get_terrain_y(terrain, centerX) 
    -- local cy = get_terrain_y(terrain, centerX)
    if (mode==1) cy+=radius
    for x = 1, #terrain do
        for y = 1, #terrain[x] do
            local dist_sq = (x - centerX)^2 + (y - cy)^2
            if dist_sq <= radius^2 then
                terrain[x][y] = mode
            end
        end
    end
end

function get_terrain_y(terrain,_x)
    local found_y = 128
    for x = 1, #terrain do
        for y = 1, #terrain[x] do
            if terrain[x][y] == 1 and x==_x then
                if (y<found_y) found_y = y
            end
        end
    end
    return found_y
end

function poke_terrain(terrain, x, y)
    return terrain[flr(x)][flr(y)]
end
