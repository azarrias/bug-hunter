StatePlay = Class{__includes = tiny.State}

function StatePlay:init()
  self.level = Level()
end

function StatePlay:update(dt)
  self.level:update(dt)
end

function StatePlay:render()
  self.level:render()
end