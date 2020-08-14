StateBattle = Class{__includes = tiny.State}

function StateBattle:init(player)
  -- player
  self.player = player
  self.playerController = player.components['Script']['PlayerController']
  self.playerMonsterId = self.playerController.monster.components['Script']['MonsterController'].monsterId
  self.panel = Panel(0, VIRTUAL_SIZE.y - 64, VIRTUAL_SIZE.x, 64)
  
  -- flag for when the battle can take input, set in the first update call
  self.battleStarted = false
  
  self.playerCircle = tiny.Vector2D(66, VIRTUAL_SIZE.y - 64)
  self.circleRadius = tiny.Vector2D(72, 24)
  
  self.playerSprite = TEXTURES[self.playerMonsterId..'-back']
  self.playerSpritePos = tiny.Vector2D(32, VIRTUAL_SIZE.y - 128)
end
  
function StateBattle:render()
  love.graphics.clear(214 / 255, 214 / 255, 214 / 255, 1)
  love.graphics.setColor(45 / 255, 184 / 255, 45 / 255, 124 / 255)
  love.graphics.ellipse('fill', self.playerCircle.x, self.playerCircle.y, 
    self.circleRadius.x, self.circleRadius.y)
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(TEXTURES[self.playerMonsterId..'-back'], 
    self.playerSpritePos.x, self.playerSpritePos.y)

  self.panel:render()
end