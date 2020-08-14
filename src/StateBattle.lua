StateBattle = Class{__includes = tiny.State}

function StateBattle:init(player)
  self.circleRadius = tiny.Vector2D(72, 24)
  self.panel = Panel(0, VIRTUAL_SIZE.y - 64, VIRTUAL_SIZE.x, 64)
 
  -- player
  self.player = player
  self.playerController = player.components['Script']['PlayerController']
  self.playerMonsterId = self.playerController.monster.components['Script']['MonsterController'].monsterId
  self.playerMonsterSprite = MonsterSprite(self.playerMonsterId..'-back', -self.circleRadius.x - MONSTER_SIZE.x / 2, VIRTUAL_SIZE.y - 128)
  --self.playerSprite = TEXTURES[self.playerMonsterId..'-back']
  self.playerCircle = tiny.Vector2D(-self.circleRadius.x, VIRTUAL_SIZE.y - 64)
  
  -- opponent (game object only to hold the monster controller)
  self.opponent = tiny.Entity(0, 0)
  self.opponentMonsterController = self.opponent:AddScript('MonsterController')
  self.opponentMonsterSprite = MonsterSprite(self.opponentMonsterController.monsterId..'-front', 
    VIRTUAL_SIZE.x + self.circleRadius.x - MONSTER_SIZE.x / 2, 8)
  self.opponentCircle = tiny.Vector2D(VIRTUAL_SIZE.x + self.circleRadius.x, 60)
  
  -- flag for when the battle can take input, set in the first update call
  self.battleStarted = false  
end

function StateBattle:update(dt)
  -- this will trigger the first time this state is actively updating on the stack
  if not self.battleStarted then
    self:TriggerSlideIn()
  end
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

function StateBattle:TriggerSlideIn()
  self.battleStarted = true

  -- slide the sprites and circles in from the edges, then trigger first dialogue boxes
  Timer.tween(1, {
    [self.playerMonsterSprite.position] = { x = 32 },
    [self.opponentMonsterSprite.position] = { x = VIRTUAL_SIZE.x - 96 },
    [self.playerCircle] = { x = 66 },
    [self.opponentCircle] = { x = VIRTUAL_SIZE.x - 70 }
  })
  :finish(function()
    self:TriggerStartDialogue()
    self.renderHealthBars = true
  end)
end

function StateBattle:TriggerStartDialogue()
  -- display a dialogue first for the pokemon that appeared, then the one being sent out
  stateManager:Push(StateBattleMessage('A wild ' .. self.opponentMonsterController.monsterId ..
    ' appeared!',
    -- callback for when the battle message is closed
    function()
      stateManager:Push(StateBattleMessage('Go, ' .. self.playerMonsterId .. '!'))
    end))
end