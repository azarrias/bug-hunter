MonsterController = Class{__includes = tiny.Script}

function MonsterController:init()
  tiny.Script.init(self, 'MonsterController')
  self.monsterId = MONSTER_IDS[math.random(#MONSTER_IDS)]
end

function MonsterController:RandomizeMonsterId()
  self.monsterId = MONSTER_IDS[math.random(#MONSTER_IDS)]
end