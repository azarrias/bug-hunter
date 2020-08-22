MonsterController = Class{__includes = tiny.Script}

function MonsterController:init()
  tiny.Script.init(self, 'MonsterController')
  self.monsterId = MONSTER_IDS[math.random(#MONSTER_IDS)]
  
  -- level 0 monster stats
  self.baseHP = MONSTER_DEFS[self.monsterId].baseHP
  self.baseAttack = MONSTER_DEFS[self.monsterId].baseAttack
  self.baseDefense = MONSTER_DEFS[self.monsterId].baseDefense
  self.baseSpeed = MONSTER_DEFS[self.monsterId].baseSpeed
  
  -- Individual Value stats, used to compare against dice rolls when leveling up
  self.HPIV = MONSTER_DEFS[self.monsterId].HPIV
  self.attackIV = MONSTER_DEFS[self.monsterId].attackIV
  self.defenseIV = MONSTER_DEFS[self.monsterId].defenseIV
  self.speedIV = MONSTER_DEFS[self.monsterId].speedIV
  
  -- current monster stats
  self.maxHP = self.baseHP
  self.currentHP = self.maxHP
  self.attack = self.baseAttack
  self.defense = self.baseDefense
  self.speed = self.baseSpeed
  
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
  