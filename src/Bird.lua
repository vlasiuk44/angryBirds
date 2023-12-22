-- Bird.lua:
Bird = Class {}

function Bird:init(world, sprite, x, y)
    self.x = x
    self.y = y
    self.world = world
    self.sprite = sprite

    self.birds = {'bird1', 'bird2'}
    self.randomIndex = math.random(1, #self.birds)
    self.randomElement = self.birds[self.randomIndex]
    self.width = 1
    self.height = 1

    self.body = love.physics.newBody(self.world, self.x, self.y, 'dynamic')
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData('Bird')

end

function Bird:draw()
    love.graphics.draw(all_textures[self.randomElement],
                       all_frames[self.randomElement][0],
                       math.floor(self.body:getX()),
                       math.floor(self.body:getY()), 0, scale_x * 0.3,
                       scale_y * 0.3,
                       all_textures[self.randomElement]:getWidth(),
                       all_textures[self.randomElement]:getHeight())
end
