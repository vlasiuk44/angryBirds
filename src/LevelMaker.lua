-- LevelMaker.lua:
LevelMaker = Class {}

function LevelMaker.createMap(world, level, d)
    local all_obstacles = {}

    if level == 1 then

        all_obstacles[1] = createHouse(world, WINDOW_WIDTH * 0.8,
                                       WINDOW_HEIGHT * 0.9)
        all_obstacles[2] = {
            Pig(world, WINDOW_WIDTH * 0.8 + 55, WINDOW_HEIGHT * 0.7)
        }
    end

    if level == 2 then
        all_obstacles[1] = createHouse(world, WINDOW_WIDTH * 0.7,
                                       WINDOW_HEIGHT * 0.9)
        obstacles = {}
        obstacles[0] = Obstacle(world, 'vertical', WINDOW_WIDTH * 0.75,
                                WINDOW_HEIGHT * 0.6)

        all_obstacles[2] = obstacles

        all_obstacles[3] = {
            Pig(world, WINDOW_WIDTH * 0.7 + 55, WINDOW_HEIGHT * 0.4),
            Pig(world, WINDOW_WIDTH * 0.95, WINDOW_HEIGHT * 0.95)
        }
    end

    if level == 3 then
        all_obstacles[1] = createHouse(world, WINDOW_WIDTH * 0.8,
                                       WINDOW_HEIGHT * 0.9)
        obstacles = {}
        obstacles[0] = Obstacle(world, 'vertical', WINDOW_WIDTH * 0.85,
                                WINDOW_HEIGHT * 0.6)
        obstacles[1] = Obstacle(world, 'horizontal', WINDOW_WIDTH * 0.85,
                                WINDOW_HEIGHT * 0.6)

        all_obstacles[2] = obstacles

        all_obstacles[3] = {
            Pig(world, WINDOW_WIDTH * 0.8 + 55, WINDOW_HEIGHT * 0.3),
            Pig(world, WINDOW_WIDTH * 0.95, WINDOW_HEIGHT * 0.95),
            Pig(world, WINDOW_WIDTH * 0.6 + 55, WINDOW_HEIGHT * 0.7)
        }

        all_obstacles[4] = createHouse(world, WINDOW_WIDTH * 0.6,
                                       WINDOW_HEIGHT * 0.9)

    end

    return all_obstacles
end

function createHouse(world, x, y)

    obstacles = {}

    obstacles[1] = Obstacle(world, 'vertical', x, y)

    obstacles[2] = Obstacle(world, 'vertical', x + 100, y)

    obstacles[3] = Obstacle(world, 'horizontal', x + 50, y - 100)

    return obstacles
end

