-- Obstacle.lua:
Obstacle = Class {}

function Obstacle:init(world, shape, x, y)
    self.world = world
    self.shape = shape or 'horizontal'
    self.start_x = x
    self.start_y = y

    if self.shape == 'horizontal' then
        self.width = 110
        self.height = 35
        self.frame = 2
    elseif self.shape == 'vertical' then
        self.width = 35
        self.height = 110
        self.frame = 4
    end

    self.body = love.physics.newBody(self.world, self.start_x, self.start_y,
                                     'dynamic')
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 0.5)

    self.body:setUserData('false')
    self.fixture:setUserData('Obstacle')

end

function Obstacle:draw()

    if self.body:getUserData() == 'true' then
        love.graphics.draw(all_textures['wood'],
                           all_frames['wood'][self.frame - 1],
                           math.floor(self.body:getX()),
                           math.floor(self.body:getY()), self.body:getAngle(),
                           1, 1, self.width / 2, self.height / 2)
    else

        love.graphics.draw(all_textures['wood'], all_frames['wood'][self.frame],
                           math.floor(self.body:getX()),
                           math.floor(self.body:getY()), self.body:getAngle(),
                           1, 1, self.width / 2, self.height / 2)
    end

end

