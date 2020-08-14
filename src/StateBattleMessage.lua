StateBattleMessage = Class{__includes = tiny.State}

function StateBattleMessage:init(msg, onClose, canInput)
  self.textbox = Textbox(0, VIRTUAL_SIZE.y - 64, VIRTUAL_SIZE.x, 64, msg, FONTS['medium'])

  -- function to be called once this message is popped
  self.onClose = onClose or function() end

  -- whether we can detect input with this or not; true by default
  self.canInput = canInput

  -- default input to true if nothing was passed in
  if self.canInput == nil then self.canInput = true end
end

function StateBattleMessage:update(dt)
  if self.canInput then
    self.textbox:update(dt)

    if self.textbox:isClosed() then
      stateManager:Pop()
      self.onClose()
    end
  end
end

function StateBattleMessage:render()
  self.textbox:render()
end