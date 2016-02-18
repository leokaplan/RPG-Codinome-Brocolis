buttons = {}

local direction = {
   horizontal = 0,
   vertical = 1
  }
function buttons.load()
  
end

function buttons.start()
  buttons.remove()
  buttons.create(2, direction.vertical, 500, 350, 200, 50)
  buttons.color = {{255, 255, 255}}
  for i=1, #buttons do
    --buttons[i].imageNormal = love.graphics.newImage("Menu/button_normal_"..i..".png")
    --buttons[i].imageSelected = love.graphics.newImage("Menu/button_select_"..i..".png")
    --buttons[i].imageCurrent = buttons[i].imageNormal 
    buttons[i].color = {255, 255, 255}
  end
  buttons.select(1)
end

function buttons.update(dt)
  
end

function buttons.draw()
  love.graphics.print(buttons.pressed, 200, 300)
  for i, but in ipairs(buttons) do
    love.graphics.setColor(but.color)
    love.graphics.rectangle("fill", but.x, but.y, but.width, but.height)
    --love.graphics.draw(but.imageCurrent, but.x, but.y)
  end
  --love.graphics.draw(buttons.image.selected[buttons.pressed], buttons[buttons.pressed].x, buttons[buttons.pressed].y)
end

function buttons.keypressed(key)
  if key == "s" then
    local index = buttons.pressed%#buttons+1
    buttons.select(index)
  end
end

function buttons.create(n, tipo, but1_pos_x, but1_pos_y, but1_w, but1_h)
  local spacing = 75
  if tipo == 0 then
    for i=1, n do
      table.insert(buttons, {x = but1_pos_x +(spacing + but1_w)*(i-1), y = but1_pos_y, width = but1_w, height = but1_h})
    end
  else
    for i=1, n do
      table.insert(buttons, {x = but1_pos_x , y = but1_pos_y + (spacing + but1_h)*(i-1), width = but1_w, height = but1_h})
    end
  end
end
function buttons.select(index)
  if buttons.pressed ~= nil then
    local b = buttons[buttons.pressed]
    --b.imageCurrent = b.imageNormal
    b.color = {255, 255, 255}
  end
  buttons.pressed = index
  local b = buttons[buttons.pressed]
  --b.imageCurrent = b.imageSelected
  b.color = {255, 0, 0}
end

function buttons.remove()
  while #buttons > 0 do
    table.remove(buttons)
  end
end