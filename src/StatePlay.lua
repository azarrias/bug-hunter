StatePlay = Class{__includes = tiny.State}

function StatePlay:init(monster)
  self.level = Level(monster)
  SOUNDS['field-music']:setLooping(true)
  SOUNDS['field-music']:play()
end

function StatePlay:update(dt)
  self.level:update(dt)
end

function StatePlay:render()
  self.level:render()
end