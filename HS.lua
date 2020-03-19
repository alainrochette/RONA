
HS = {}
HS.__index = HS

function HS:create()
   local hs = {}
	 hs.scale = scale*0.1
   hs.x = math.random(10,w) + 30
	 hs.y = math.random(10,h) + 30

	 hs.img = love.graphics.newImage("HS.png")
	 hs.w = hs.img:getWidth()*hs.scale
	 hs.h = hs.img:getHeight()*hs.scale
   return hs
end
