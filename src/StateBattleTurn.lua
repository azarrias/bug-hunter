StateBattleTurn = Class{__includes=tiny.State}

function StateBattleTurn:init(battleState)
  self.battleState = battleState
  self.playerMonster = battleState.playerMonsterController
  self.opponentMonster = battleState.opponentMonsterController
  
  self.playerMonsterSprite = battleState.playerMonsterSprite
  self.opponentMonsterSprite = battleState.opponentMonsterSprite
  
  -- check which monster is faster, since it gets to attack first
  if self.playerMonster.speed > self.opponentMonster.speed then
    self.firstMonster = self.playerMonster
    self.secondMonster = self.opponentMonster
    self.firstMonsterSprite = self.playerMonsterSprite
    self.secondMonsterSprite = self.opponentMonsterSprite
    self.firstBar = self.battleState.playerHealthBar
    self.secondBar = self.battleState.opponentHealthBar
  else
    self.firstMonster = self.opponentMonster
    self.secondMonster = self.playerMonster
    self.firstMonsterSprite = self.opponentMonsterSprite
    self.secondMonsterSprite = self.playerMonsterSprite
    self.firstBar = self.battleState.opponentHealthBar
    self.secondBar = self.battleState.playerHealthBar
  end  
end
  
function StateBattleTurn:enter(params)
  self:Attack(self.firstMonster, self.secondMonster, self.firstMonsterSprite, self.secondMonsterSprite, self.firstBar, self.secondBar,
    function()
      
      -- remove the battle message state created within the Attack function
      stateManager:Pop()
      
      -- check if any of the monsters are dead
      if self:CheckDeaths() then
        stateManager:Pop()
        return
      end
      
      self:Attack(self.secondMonster, self.firstMonster, self.secondMonsterSprite, self.firstMonsterSprite, self.secondBar, self.firstBar, 
        function()
          
          -- remove the battle message state created within the Attack function
          stateManager:Pop()
          
          -- check if any of the monsters are dead
          if self:CheckDeaths() then
            stateManager:Pop()
            return
          end
          
          -- remove the last attack state from the stack and push a new one
          stateManager:Pop()
          stateManager:Push(StateBattleMenu(self.battleState))
        end)
    end)
end

function StateBattleTurn:Attack(attacker, defender, attackerSprite, defenderSprite, attackerBar, defenderBar, onEnd)
  
  -- push attack message
  stateBattleMessage = StateBattleMessage(attacker.monsterId .. ' attacks ' .. defender.monsterId .. '!',
    function() end, false)
  stateManager:Push(stateBattleMessage)

  -- pause for 0.5s, then play attack animation and attack sfx
  Timer.after(0.5, function()
    SOUNDS['powerup']:stop()
    SOUNDS['powerup']:play()
    
    -- blink the attacker sprite (toggle blinking 6 times)
    Timer.every(0.1, function()
      attackerSprite.blinking = not attackerSprite.blinking
    end)
    :limit(6)
    :finish(function()
      -- play hit sound and flash the opacity of the defender for 3 times
      SOUNDS['hit']:stop()
      SOUNDS['hit']:play()
      
      Timer.every(0.1, function()
        defenderSprite.opacity = defenderSprite.opacity == 64 / 255 and 1 or 64 / 255
      end)
      :limit(6)
      :finish(function()
          
        -- apply damage depending on the monsters stats and tween the defender's health bar
        local dmg = math.max(1, attacker.attack - defender.defense)
        
        Timer.tween(0.5, {
          [defenderBar] = { value = defender.currentHP - dmg }
        })
        :finish(function()
          defender.currentHP = defender.currentHP - dmg
          onEnd()
        end)
      end)
    end)
  end)
end

function StateBattleTurn:CheckDeaths()
  if self.playerMonster.currentHP <= 0 then
    self:Lose()
    return true
  elseif self.opponentMonster.currentHP <= 0 then
    self:Win()
    return true
  end
  
  return false
end

function StateBattleTurn:Lose()
  -- drop player's monster sprite down below the window and restore it's health
  Timer.tween(0.2, {
    [self.playerMonsterSprite.position] = { y = VIRTUAL_SIZE.y }
  })
  :finish(function()
    
    stateManager:Push(StateBattleMessage('You lost!',
      function()
        self.playerMonster.currentHP = self.playerMonster.maxHP
    
        SOUNDS['battle-music']:stop()
        SOUNDS['field-music']:play()
        self.battleState.playerController.inEncounter = false
        
        -- pop the last battle state and go back to the field
        stateManager:Pop()
      end))
  end)
end

function StateBattleTurn:TweenPlayerBars(finishCallback)
  self.battleState.playerExpBar.value = 0
  self.playerMonster.currentExp = self.playerMonster.currentExp - self.playerMonster.expToLevelUp
  self.playerMonster:SetLevel(self.playerMonster.level + 1)
  self.playerMonster.currentHP = self.playerMonster.maxHP
  self.battleState.playerExpBar.maxValue = self.playerMonster.expToLevelUp
  SOUNDS['levelup']:play()
  
  Timer.tween(0.5, {
    [self.battleState.playerExpBar] = { value = math.min(self.playerMonster.currentExp, self.playerMonster.expToLevelUp) },
    [self.battleState.playerHealthBar] = { value = self.playerMonster.currentHP }
  })
  :finish(function()
    if self.playerMonster.currentExp > self.playerMonster.expToLevelUp then
      self:TweenPlayerBars(function() end)
      finishCallback()
    else
      finishCallback()
    end
  end)
end

function StateBattleTurn:Win()
  -- drop the opponent's monster sprite down below the window
  Timer.tween(0.5, {
    [self.opponentMonsterSprite.position] = { y = VIRTUAL_SIZE.y }
  })
  :finish(function()
    -- play victory music and push victory message
    SOUNDS['battle-music']:stop()
    SOUNDS['victory-music']:play()
        
    stateManager:Push(StateBattleMessage('Victory!',
      function()
        -- calculate XP points
        local exp = (self.opponentMonster.HPIV + self.opponentMonster.attackIV +
          self.opponentMonster.defenseIV + self.opponentMonster.speedIV) * self.opponentMonster.level
        
        stateManager:Push(StateBattleMessage('You earned ' .. tostring(exp) .. ' experience points!',
          function() end, false))
      
        Timer.after(1.5, function()
          SOUNDS['exp']:play()
          
          -- tween the XP bar filling up
          Timer.tween(0.5, {
            [self.battleState.playerExpBar] = { value = math.min(self.playerMonster.currentExp + exp, self.playerMonster.expToLevelUp) }
          })
          :finish(function()
            -- pop exp message off
            stateManager:Pop()
            self.playerMonster.currentExp = self.playerMonster.currentExp + exp
            
            -- level up if won xp is enough
            if self.playerMonster.currentExp > self.playerMonster.expToLevelUp then
              self:TweenPlayerBars(function()
                stateManager:Push(StateBattleMessage('Congratulations! Level Up!',
                  function()
                    self:TransitionWinToField()
                  end))
              end)
            else
              self:TransitionWinToField()
            end
          end)
        end)
      end))
  end)
end

function StateBattleTurn:TransitionWinToField()
  -- fade in
  stateManager:Push(StateFade({ 1, 1, 1, 0 }, { 1, 1, 1, 1 }, 1, function()
    -- resume field music
    SOUNDS['victory-music']:stop()
    SOUNDS['field-music']:play()
    
    -- pop off the battle state and push fade out
    stateManager:Pop()
    stateManager:Push(StateFade({ 1, 1, 1, 1 }, { 1, 1, 1, 0 }, 1, function()
      self.battleState.playerController.inEncounter = false
    end))
  end))
end
