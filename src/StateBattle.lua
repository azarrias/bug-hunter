StateBattle = Class{__includes = tiny.State}

function StateBattle:init(player)
  self.player = player
  self.panel = Panel(0, VIRTUAL_SIZE.y - 64, VIRTUAL_SIZE.x, 64)
end
  
function StateBattle:render()
  love.graphics.clear(214 / 255, 214 / 255, 214 / 255, 1)
  love.graphics.setColor(45 / 255, 184 / 255, 45 / 255, 124 / 255)

  self.panel:render()
end