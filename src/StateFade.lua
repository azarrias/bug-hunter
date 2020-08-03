StateFade = Class{__includes = tiny.State}

function StateFade:init(fromColor, toColor, transitionTime, onFadeComplete)
  self.r = fromColor[1]
  self.g = fromColor[2]
  self.b = fromColor[3]
  self.a = fromColor[4] or 1
  
  Timer.tween(transitionTime, {
    [self] = { r = toColor[1], g = toColor[2], b = toColor[3], a = toColor[4] or 1 }
  })
  :finish(function()
    stateManager:Pop()
    onFadeComplete()
  end)
end

function StateFade:render()
  love.graphics.setColor(self.r, self.g, self.b, self.a)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_SIZE.x, VIRTUAL_SIZE.y)
  
  love.graphics.setColor(1, 1, 1, 1)
end