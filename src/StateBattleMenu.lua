StateBattleMenu = Class{__includes = tiny.State}

function StateBattleMenu:init(battleState)
  self.battleState = battleState
  
  self.battleMenu = Menu {
    x = VIRTUAL_SIZE.x - 64,
    y = VIRTUAL_SIZE.y - 64,
    width = 64,
    height = 64,
    items = {
      {
        text = 'Fight',
        onSelect = function() 
          stateManager:Pop()
          stateManager:Push(StateBattleTurn(self.battleState))
        end
      },
      {
        text = 'Run',
        onSelect = function() 
          SOUNDS['run']:play()
          
          -- pop battle menu
          stateManager:Pop()
          
          -- push fled message
          stateManager:Push(StateBattleMessage('You fled successfully!',
            function() end, false))
          Timer.after(0.5, 
            function()
              stateManager:Push(StateFade({ 1, 1, 1, 0 }, { 1, 1, 1, 1 }, 1,
                -- pop message and battle state and add fade to go to field
                function()
                  SOUNDS['battle-music']:stop()
                  SOUNDS['field-music']:play()
                  
                  -- pop message state and then battle state
                  stateManager:Pop()
                  stateManager:Pop()
                  
                  stateManager:Push(StateFade({ 1, 1, 1, 1 }, { 1, 1, 1, 0 }, 1,
                    function() 
                      self.battleState.playerController.inEncounter = false
                    end))
                end))
            end)
        end
      }
    }
  }
end

function StateBattleMenu:update(dt)
  self.battleMenu:update(dt)
end

function StateBattleMenu:render()
  self.battleMenu:render()
end