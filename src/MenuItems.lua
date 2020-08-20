MenuItems = Class{}

function MenuItems:init(def)
  self.items = def.items
  self.x = def.x
  self.y = def.y

  self.height = def.height
  self.width = def.width
  self.font = def.font or FONTS['small']

  self.gapHeight = self.height / #self.items

  self.currentSelection = 1
end

function MenuItems:update(dt)
end

function MenuItems:render()
  local currentY = self.y

  for i = 1, #self.items do
    local paddedY = currentY + (self.gapHeight / 2) - self.font:getHeight() / 2

    -- draw selection marker if we're at the right index
    if i == self.currentSelection then
      love.graphics.draw(TEXTURES['cursor'], self.x - 8, paddedY)
    end

    love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')

    currentY = currentY + self.gapHeight
  end
end
