local current_folder = (...):gsub('%.Scene$', '') -- "my package path"
local State = require(current_folder .. '.State')
local Scene = Class{__includes = State}

return Scene