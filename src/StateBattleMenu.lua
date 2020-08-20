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
        onSelect = function() end
      },
      {
        text = 'Run',
        onSelect = function() end
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