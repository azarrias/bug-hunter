StateDialogue = Class{__includes = tiny.State}

function StateDialogue:init(text, callback)
  self.textbox = Textbox(6, 6, VIRTUAL_SIZE.x - 6 * 2, 64, text, FONTS['small'])
  self.callback = callback or function() end
end

function StateDialogue:update(dt)
  self.textbox:update(dt)
  
  if self.textbox:isClosed() then
    self.callback()
    stateManager:Pop()
  end
end

function StateDialogue:render()
  self.textbox:render()
end