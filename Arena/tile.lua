--  tile.lua
--  PUC Arena
--  Created by Pietro Ribeiro Pepe
--  Copyright © 2016 Rio PUC Games. All rights reserved.

require "class"

Tile = class_new("tile")

function Tile.load()
  
end

function Tile.setTileSize(size)
  Tile.width = size.width
  Tile.height = size.height
end

function Tile.new(x,y)
  local self = Tile.newObject()
  self.x = x
  self.y = y
  return self
end

function Tile:draw(offset)
  if offset == nil then offset = {x=0,y=0} end
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill",offset.x+self.x,offset.y+self.y,self.width,self.height)
  if config.debugMode then
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line",offset.x+self.x,offset.y+self.y,self.width,self.height)
  end
  love.graphics.setColor(255,255,255)
end

function Tile:tookHit()
  
end