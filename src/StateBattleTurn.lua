StateBattleTurn = Class{__includes=tiny.State}

function StateBattleTurn:init(battleState)
  self.battleState = battleState
  self.playerMonster = battleState.playerMonsterController
  self.opponentMonster = battleState.opponentMonsterController
  
  self.playerMonsterSprite = battleState.playerMonsterSprite
  self.opponentMonsterSprite = battleState.oponentMonsterSprite
  
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
  stateManager:Push(StateBattleMessage(attacker.monsterId .. ' attacks ' .. defender.monsterId .. '!',
    function() end, false))

  Timer.after(2, function()
    onEnd()
  end)
end