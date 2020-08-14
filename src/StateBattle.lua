StateBattle = Class{__includes = tiny.State}

function StateBattle:init(player)
  -- player
  self.player = player
  self.playerController = player.components['Script']['PlayerController']
  self.playerMonsterId = self.playerController.monster.components['Script']['MonsterController'].monsterId
  self.playerMonsterSprite = MonsterSprite(self.playerMonsterId..'-back', 32, VIRTUAL_SIZE.y - 128)
  self.playerSprite = TEXTURES[self.playerMonsterId..'-back']
  self.playerCircle = tiny.Vector2D(66, VIRTUAL_SIZE.y - 64)
  
  -- opponent (game object only to hold the monster controller)
  self.opponent = tiny.Entity(0, 0)
  local opponentMonsterController = self.opponent:AddScript('MonsterController')
  self.opponentMonsterSprite = MonsterSprite(opponentMonsterController.monsterId..'-front', 
    VIRTUAL_SIZE.x - 96, 8)
  self.opponentCircle = tiny.Vector2D(VIRTUAL_SIZE.x - 70, 60)
  
  self.panel = Panel(0, VIRTUAL_SIZE.y - 64, VIRTUAL_SIZE.x, 64)
  
  -- flag for when the battle can take input, set in the first update call
  self.battleStarted = false
  
  self.circleRadius = tiny.Vector2D(72, 24)
end
  
function StateBattle:render()
  love.graphics.clear(214 / 255, 214 / 255, 214 / 255, 1)
  love.graphics.setColor(45 / 255, 184 / 255, 45 / 255, 124 / 255)
  love.graphics.ellipse('fill', self.opponentCircle.x, self.opponentCircle.y, 
    self.circleRadius.x, self.circleRadius.y)
  love.graphics.ellipse('fill', self.playerCircle.x, self.playerCircle.y, 
    self.circleRadius.x, self.circleRadius.y)
  
  love.graphics.setColor(255, 255, 255, 255)
  self.opponentMonsterSprite:render()
  self.playerMonsterSprite:render()

  self.panel:render()
end