local StackFSM = Class{}

function StackFSM:init()
    self.states = {}
end

function StackFSM:update(dt)
    self.states[#self.states]:update(dt)
end

function StackFSM:render()
    for i, state in ipairs(self.states) do
        state:render()
    end
end

function StackFSM:Clear()
    self.states = {}
end

function StackFSM:Push(state)
    table.insert(self.states, state)
    state:enter()
end

function StackFSM:Pop()
    self.states[#self.states]:exit()
    table.remove(self.states)
end

return StackFSM