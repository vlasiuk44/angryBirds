-- Pig.lua:
Pig = Class {}

function Pig:init(world, x, y, sprite)
    self.x = x
    self.y = y
    self.world = world
    self.monsters = {'monster1', 'monster2', 'monster3'}
    self.randomIndex = math.random(1, #self.monsters)
    self.randomElement = self.monsters[self.randomIndex]

    self.body = love.physics.newBody(self.world, self.x, self.y, 'dynamic')
    self.shape = love.physics.newCircleShape(18 * scale_x)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData('Pig')

end

function Pig:update(dt) end

function Pig:draw()
    love.graphics.draw(all_textures[self.randomElement],
                       all_frames[self.randomElement][0],
                       math.floor(self.body:getX()),
                       math.floor(self.body:getY()), self.body:getAngle(),
                       0.3 * scale_x, 0.3 * scale_y,
                       all_textures[self.randomElement]:getWidth() / 2,
                       all_textures[self.randomElement]:getHeight() / 2)
end
