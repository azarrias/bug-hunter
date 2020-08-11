MonsterController = Class{__includes = tiny.Script}

function MonsterController:init()
  tiny.Script.init(self, 'MonsterController')
  self.monsterId = nil
end

function MonsterController:GetRandomMonsterSprite()
  self.monsterId = MONSTER_IDS[math.random(#MONSTER_IDS)]
  local sprite_name = MONSTER_DEFS[self.monsterId].battleSpriteFront
  return tiny.Sprite(TEXTURES[sprite_name])
end