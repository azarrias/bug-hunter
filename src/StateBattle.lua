StateBattle = Class{__includes = tiny.State}

function StateBattle:init(player)
  self.circleRadius = tiny.Vector2D(72, 24)

  -- player
  self.player = player
  self.playerController = player.components['Script']['PlayerController']
  self.playerMonsterController = self.playerController.monster.components['Script']['MonsterController']
  self.playerMonsterSprite = MonsterSprite(self.playerMonsterController.monsterId .. '-back', 
    -self.circleRadius.x - MONSTER_SIZE.x / 2, VIRTUAL_SIZE.y - 128)
  self.playerCircle = tiny.Vector2D(-self.circleRadius.x, VIRTUAL_SIZE.y - 64)
  
  -- opponent (game object only to hold the monster controller)
  self.opponent = tiny.Entity(0, 0)
  self.opponentMonsterController = self.opponent:AddScript('MonsterController')
  self.opponentMonsterController:SetLevel(math.random(math.max(1, self.playerMonsterController.level - 1), self.playerMonsterController.level + 1))
  self.opponentMonsterSprite = MonsterSprite(self.opponentMonsterController.monsterId..'-front', 
    VIRTUAL_SIZE.x + self.circleRadius.x - MONSTER_SIZE.x / 2, 8)
  self.opponentCircle = tiny.Vector2D(VIRTUAL_SIZE.x + self.circleRadius.x, 60)
  
  -- UI elements
  self.panel = Panel(0, VIRTUAL_SIZE.y - 64, VIRTUAL_SIZE.x, 64)
  
  self.playerHealthBar = ProgressBar {
    x = VIRTUAL_SIZE.x - 160,
    y = VIRTUAL_SIZE.y - 80,
    width = 152,
    height = 6,
    color = { r = 189 / 255, g = 32 / 255, b = 32 / 255 },
    value = self.playerMonsterController.currentHP,
    maxValue = self.playerMonsterController.maxHP
  }
  
  self.playerExpBar = ProgressBar {
    x = VIRTUAL_SIZE.x - 160,
    y = VIRTUAL_SIZE.y - 73,
    width = 152,
    height = 6,
    color = { r = 32 / 255, g = 32 /255, b = 189 / 255 },
    value = self.playerMonsterController.currentExp,
    maxValue = self.playerMonsterController.expToLevelUp
  }
  
  self.opponentHealthBar = ProgressBar {
    x = 8,
    y = 8,
    width = 152,
    height = 6,
    color = { r = 189 / 255, g = 32 / 255, b = 32 / 255 },
    value = self.opponentMonsterController.currentHP,
    maxValue = self.opponentMonsterController.maxHP
  }
  
  -- flag for when the battle can take input, set in the first update call
  self.battleStarted = false
  -- flag for rendering health (and exp) bars, shown after pokemon slide in
  self.renderHealthBars = false
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
  
  love.graphics.setColor(1, 1, 1, 1)
  self.opponentMonsterSprite:render()
  self.playerMonsterSprite:render()
  
  if self.renderHealthBars then
    self.playerHealthBar:render()
    self.playerExpBar:render()
    self.opponentHealthBar:render()
    
    -- render level text
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(FONTS['small'])
    love.graphics.print('LV ' .. tostring(self.playerMonsterController.level),
      self.playerHealthBar.x, self.playerHealthBar.y - 10)
    love.graphics.print('LV ' .. tostring(self.opponentMonsterController.level),
      self.opponentHealthBar.x, self.opponentHealthBar.y + 8)
    love.graphics.setFont(FONTS['medium'])
    love.graphics.setColor(1, 1, 1, 1)
  end

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
      stateManager:Push(StateBattleMessage('Go, ' .. self.playerMonsterController.monsterId .. '!',
        
      -- push a battle menu onto the stack based FSM that has access to the battle state
      function()
        stateManager:Push(StateBattleMenu(self))
      end))
    end))
end