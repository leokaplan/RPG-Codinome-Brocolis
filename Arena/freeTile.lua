--  freeTile.lua
--  PUC Arena
--  Created by Pietro Ribeiro Pepe
--  Copyright © 2016 Rio PUC Games. All rights reserved.

require "Arena/tile"

FreeTile = class_extends(Tile,"freeTile")
FreeTile.color = {255,255,255}

function FreeTile.new(x,y)
  local self = FreeTile.newObject(x,y)
  return self
end

function FreeTile:canMove(entity)
  return true
end