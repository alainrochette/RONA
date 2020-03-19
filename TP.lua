
TP = {}
TP.__index = TP

function TP:create()
   local tp = {}
	 tp.scale = scale*0.2
     tp.x = math.random(10,w) + 30
	 tp.y = math.random(10,h) + 30

	 tp.img = love.graphics.newImage("tp.png")
	 tp.w = tp.img:getWidth()*tp.scale
	 tp.h = tp.img:getHeight()*tp.scale
   return tp
end
