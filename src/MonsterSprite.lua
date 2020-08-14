MonsterSprite = Class{}

function MonsterSprite:init(texture, x, y)
  self.texture = texture
  self.position = tiny.Vector2D(x, y)
  self.opacity = 1
  self.blinking = false
  
  -- https://love2d.org/forums/viewtopic.php?t=79617
  -- white shader that will turn a sprite completely white when used; allows us
  -- to brightly blink the sprite when it's acting
  self.whiteShader = love.graphics.newShader[[
    extern float WhiteFactor;

    vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
    {
      vec4 outputcolor = Texel(tex, texcoord) * vcolor;
      outputcolor.rgb += vec3(WhiteFactor);
      return outputcolor;
    }
  ]]
end

function MonsterSprite:render()
  love.graphics.setColor(1, 1, 1, self.opacity)
  
  -- if blinking is set to true, we'll send 1 to the white shader, which will
  -- convert every pixel of the sprite to pure white
  love.graphics.setShader(self.whiteShader)
  self.whiteShader:send('WhiteFactor', self.blinking and 1 or 0)

  love.graphics.draw(TEXTURES[self.texture], self.position.x, self.position.y)

  -- reset shader
  love.graphics.setShader()
end
