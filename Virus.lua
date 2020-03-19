Virus = {}
Virus.__index = Virus

function Virus:create()
   local v = {}
	 -- v.scale = 0.2
     v.scale = (w/1280)*(0.05 + 0.35 * math.random())
     v.speed = (w/1280)*0.25 / v.scale
     v.x = math.random(w,w+50) + 30
	 v.y = math.random(h,h+50) + 30

	 v.img = love.graphics.newImage("rona.png")
	 v.w = v.img:getWidth()*v.scale
	 v.h = v.img:getHeight()*v.scale
   return v
end

function Virus:withdraw(amount)
   self.x = self.x - amount
end
