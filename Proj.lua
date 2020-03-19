
Proj = {}
Proj.__index = Proj

function Proj:create(which)
   local p = {}

	 if which == "tp.png" then p.scale = scale*0.2 else p.scale = scale*0.3 end
     p.x = me.x
	 p.y = me.y
	 p.dirx = me.dirx
	 p.diry = me.diry
     if p.dirx == 0 and p.diry == 0 then p.dirx = 1 end
     p.r = math.cos(math.atan(p.dirx/p.diry))

	 p.speed = (w/1280)*me.health*1.6
	 me.n_projs = me.n_projs + 1
	 if which == "tp.png" then me.tps = me.tps - 1 end
	 p.img = love.graphics.newImage(which)
	 p.w = p.img:getWidth()*p.scale
	 p.h = p.img:getHeight()*p.scale
	 if p.dirx == 0 and p.diry == 0 then p = nil end
	 table.insert(me.projs, p)

   return p
end
