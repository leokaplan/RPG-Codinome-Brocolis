--  arena.lua
--  PUC Arena
--  Created by Pietro Ribeiro Pepe
--  Copyright © 2016 Rio PUC Games. All rights reserved.

require "Arena/solidTile"
require "Arena/freeTile"
require "Arena/arenaBrocolis"
require "Arena/arenaDefault"

arena = {}

local loadDimensions, loadTiles

local tiles = {}
tiles[0] = FreeTile
tiles[1] = SolidTile

function arena.load(row,col)
  arena.nRow = row
  arena.nCol = col
  loadDimensions()
  loadTiles()
  arena.curr = arenaBrocolis
  arenaBrocolis.start(arena)
end

function loadDimensions()
  local w,h = love.graphics.getWidth(), love.graphics.getHeight()
  local ts = math.floor(math.min(w/arena.nCol,h/arena.nRow))
  arena.tileSize = {width=ts,height=ts}
  Tile.setTileSize(arena.tileSize)
  arena.width = arena.tileSize.width*arena.nCol
  arena.height = arena.tileSize.height*arena.nRow
  arena.x = (w-arena.width)/2
  arena.y = (h-arena.height)/2
end

function loadTiles()
  arena.obstacles = {}
  local w = arena.tileSize.width
  local h = arena.tileSize.height
  for i=1,arena.nRow-2 do
    arena.obstacles[i] = {}
    arena.obstacles[i][0] = SolidTile.new(0,i*h,w,h)
    for j=1,arena.nCol-2 do
      arena.obstacles[i][j] = FreeTile.new(j*w,i*h,w,h)
    end
    local j = arena.nCol-1
    arena.obstacles[i][arena.nCol-1] = SolidTile.new(j*w,i*h,w,h)
  end
  local i = arena.nRow-1
  arena.obstacles[0]={}
  arena.obstacles[i]={}
  for j=0,arena.nCol-1 do
    arena.obstacles[0][j] = SolidTile.new(j*w,0,w,h)
    arena.obstacles[i][j] = SolidTile.new(j*w,i*h,w,h)
  end
  
  --arena.testObstacles()
end

function arena.testObstacles()
  local w = arena.tileSize.width
  local h = arena.tileSize.height
  local ind=3
  local endRow = arena.nRow-ind-2
  local endCol = arena.nCol-ind-2
  for i=0, 1 do
    for j=0, 1 do
      --table.remove(arena.obstacles[i+ind][j+ind])
      arena.obstacles[i+ind][j+ind] = SolidTile.new((j+ind)*w,(i+ind)*h,w,h)
      --table.remove(arena.obstacles[i+ind][endCol+j])
      arena.obstacles[i+ind][endCol+j] = SolidTile.new((endCol+j)*w,(i+ind)*h,w,h)
      --table.remove(arena.obstacles[endRow+i][j+ind])
      arena.obstacles[endRow+i][j+ind] = SolidTile.new((j+ind)*w,(endRow+i)*h,w,h)
      --table.remove(arena.obstacles[endRow+i][endCol+j])
      arena.obstacles[endRow+i][endCol+j] = SolidTile.new((endCol+j)*w,(endRow+i)*h,w,h)
    end
  end
end

function arena.start()
  
end

function arena.update(dt,players)
  --arena.handleMovements(dt,players)
  arena.curr.update(dt)
end

function arena.draw()
  local offset = {x=arena.x,y=arena.y}
  for i=0, arena.nRow-1 do
    for j=0, arena.nCol-1 do
      local w = arena.obstacles[i][j]
      --love.graphics.print(w:name(),j*100+10,i*20+10)
      --love.graphics.print(w:superClass():name(),j*100+10,i*20+10)
      --if w:is_a(Tile) then
        w:draw(offset)
      --end
    end
  end
end

function arena.handleMovements(dt,players)
  for i,v in ipairs(players) do
    arena.handleHorizontal(dt,v)
    arena.handleVertical(dt,v)
  end
end

function arena.handleHorizontal(dt,entity)
  local s = math.sign(entity.speed.x)
  local front = entity.x + entity.width/2 + entity.width/2*s
  local dx = front+entity.speed.x*dt
  local col = math.floor(dx/arena.tileSize.width)
  local canMove
  if col>=arena.nCol then
    canMove = false
    col = arena.nCol-1
  elseif col<0 then
    canMove = false
    col = 0
  else
    canMove = true
    local aux = entity.y/arena.tileSize.height
    local firstRow = math.floor(aux)
    local lastRow = math.floor(aux+entity.height/arena.tileSize.height)
    for i=firstRow,lastRow do
      local ob = arena.obstacles[i][col]
      ob:tookHit(entity)
      if not ob:canMove(entity) then
        canMove = false
        break
      end
    end
  end
  if canMove then
    entity.x = entity.x + (dx - front)
  else
    entity.x = (col+0.5)*arena.tileSize.width-entity.width/2 -s*((arena.tileSize.width+entity.width)/2+0.1)
  end
  return canMove
end

function arena.handleVertical(dt,entity)
  local s = math.sign(entity.speed.y)
  local front = entity.y + entity.height/2 + entity.height/2*s
  local dy = front+entity.speed.y*dt
  local row = math.floor(dy/arena.tileSize.height)
  local canMove
  if row>=arena.nRow then
    canMove = false
    row = arena.nRow-1
  elseif row<0 then
    canMove = false
    row = 0
  else
    canMove = true
    local aux = entity.x/arena.tileSize.width
    local firstCol = math.floor(aux)
    local lastCol = math.floor(aux+entity.width/arena.tileSize.width)
    for j=firstCol,lastCol do
      local ob = arena.obstacles[row][j]
      ob:tookHit(entity)
      if not ob:canMove(entity) then
        canMove = false
        break
      end
    end
  end
  if canMove then
    entity.y = entity.y + (dy - front)
  else
    entity.y = (row+0.5)*arena.tileSize.height-entity.height/2 -s*((arena.tileSize.height+entity.height)/2+0.1)
  end
  return canMove
end

function math.sign(num)
  return (num<0 and -1 or 1)
end

function prepareDrawOrder(players)
  local grid = {}
  for i=0,arena.nRow-1 do
    grid[i]={}
  end
  for i,v in ipairs(players) do
    table.insert(grid[math.floor(v.y/arena.tileSize.height)],v)
  end
  return grid
end