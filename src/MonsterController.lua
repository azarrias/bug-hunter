MonsterController = Class{__includes = tiny.Script}

function MonsterController:init()
  tiny.Script.init(self, 'MonsterController')
  self.monsterId = MONSTER_IDS[math.random(#MONSTER_IDS)]
  self.maxHP = MONSTER_DEFS[self.monsterId].baseHP
  self.currentHP = self.maxHP
  self.currentExp = 0
  self.expToLevelUp = nil
  self.level = nil
end

function MonsterController:RandomizeMonsterId()
  self.monsterId = MONSTER_IDS[math.random(#MONSTER_IDS)]
  self.maxHP = MONSTER_DEFS[self.monsterId].baseHP
  self.currentHP = self.maxHP
end

function MonsterController:SetLevel(level)
  self.level = level
  self.expToLevelUp = level * level * 5 * 0.75
end
  