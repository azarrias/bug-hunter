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
      
      self:Attack(self.secondMonster, self.firstMonster, self.secondMonsterSprite, self.firstMonsterSprite, self.secondBar, self.firstBar, 
        function()
          
          -- remove the battle message state created within the Attack function
          stateManager:Pop()
          
          -- remove the last attack state from the stack
          stateManager:Pop()
          stateManager:Push(StateBattleMenu(self.battleState))
        end)
    end)
end

function StateBattleTurn:Attack(attacker, defender, attackerSprite, defenderSprite, attackerBar, defenderBar, onEnd)
  
  -- push attack message
  stateBattleMessage = StateBattleMessage(attacker.monsterId .. ' attacks ' .. defender.monsterId .. '!',
    function() end)
  stateBattleMessage.textbox.renderArrow = false
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