MenuItems = Class{}

function MenuItems:init(def)
  self.items = def.items
  self.x = def.x
  self.y = def.y

  self.height = def.height
  self.width = def.width
  self.font = def.font or FONTS['medium']

  self.gapHeight = self.height / #self.items

  self.currentSelection = 1
end

function MenuItems:update(dt)
  if love.keyboard.keysPressed['up'] then
    if self.currentSelection == 1 then
      self.currentSelection = #self.items
    else
      self.currentSelection = self.currentSelection - 1
    end
    SOUNDS['blip']:stop()
    SOUNDS['blip']:play()

  elseif love.keyboard.keysPressed['down'] then
    if self.currentSelection == #self.items then
      self.currentSelection = 1
    else
      self.currentSelection = self.currentSelection + 1
    end
    SOUNDS['blip']:stop()
    SOUNDS['blip']:play()

  elseif love.keyboard.keysPressed['return'] or love.keyboard.keysPressed['enter'] then
    self.items[self.currentSelection].onSelect()
    SOUNDS['blip']:stop()
    SOUNDS['blip']:play()
  
  elseif love.mouse.buttonPressed[1] then
    local x, y = push:toGame(love.mouse.getPosition())
    
    local currentY = self.y + math.floor(self.gapHeight / 2)
    for i = 1, #self.items do
      local paddedY = currentY - self.font:getHeight() / 2
      
      if x and x > 0 and y and y > 0 then
        if x >= self.x and x <= self.x + self.width and y >= paddedY and y <= paddedY + self.font:getHeight() then
          self.items[i].onSelect()
          SOUNDS['blip']:stop()
          SOUNDS['blip']:play()
          break
        end
      end
      
      currentY = currentY + self.gapHeight
    end
  end
end

function MenuItems:render()
  love.graphics.setFont(self.font)
  
  local currentY = self.y + math.floor(self.gapHeight / 2)

  for i = 1, #self.items do
    local paddedY = currentY - self.font:getHeight() / 2

    -- draw selection marker if we're at the right index
    if i == self.currentSelection then
      love.graphics.draw(TEXTURES['cursor'], self.x - 8, paddedY)
    end

    love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')
    
    currentY = currentY + self.gapHeight
  end
--[[ debugging mouse position
  local x, y = push:toGame(love.mouse.getPosition())
  x = math.min(math.max(-1, x), WINDOW_SIZE.x)
  y = math.min(math.max(-1, y), WINDOW_SIZE.y)
  love.graphics.printf("Mouse Position: (" .. tostring(x) .. ", " .. tostring(y) .. ")", 10, 10, VIRTUAL_SIZE.x)
]]
end
