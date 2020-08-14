ProgressBar = Class{}

function ProgressBar:init(def)
  self.x = def.x
  self.y = def.y
  self.width = def.width
  self.height = def.height
  self.color = def.color
  self.value = def.value
  self.maxValue = def.maxValue
end

function ProgressBar:SetMax(maxValue)
  self.maxValue = maxValue
end

function ProgressBar:SetValue(value)
  self.value = value
end

function ProgressBar:render()
  -- multiplier on width based on progress
  local render_width = (self.value / self.maxValue) * self.width
  
  -- draw main bar, with calculated width based on value / maxValue
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
  
  if self.value > 0 then
    love.graphics.rectangle('fill', self.x, self.y, render_width, self.height, 3)
  end
  
  -- draw outline around actual progress bar
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle('line', self.x, self.y, self.width, self.height, 3)
  love.graphics.setColor(1, 1, 1, 1)
end
