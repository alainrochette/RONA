
Me = {}
Me.__index = Me

function Me:create()
    local m = {}
    m.scale = scale*(w/1280)*0.15
    m.x = math.random(10,w/2)
    m.y = math.random(10,h/2)
    m.tps = 0
    m.masks = 0
    m.dirx = 0
    m.diry = 0
    m.projs = {}
    m.n_projs = 0
    m.health = 1
    m.dead = false
    m.wcough = 4
    m.coughing = 0
    m.aimscale = (w/1280)*0.015
    m.protection = 0
    m.using_mask = false
    m.aimx = m.x
    m.aimy = m.y
    m.aimr = 0
    m.has_granny = false

    m.shield = love.graphics.newImage("circle.png")
    m.shieldscale =scale*(w/1280)* 0.25
    m.img = love.graphics.newImage("me2.png")
    m.aimimg = love.graphics.newImage("circle.png")
    m.w = m.img:getWidth()*m.scale
    m.h = m.img:getHeight()*m.scale

    function m.Cough()
    	if m.coughing == 0 then

		which = "cough" .. m.wcough .. ".mp3"
    		m.wcough = m.wcough + 1
    		if m.wcough == 5 then m.wcough = 1 end
    		sound = love.audio.newSource(which, "stream")
            sound:setVolume(0.3)
    		sound:play()
    		m.coughing = 1
    		end
    end

    function m.yeet()
    	sound = love.audio.newSource("yeet.mp3", "stream")
    	sound:setVolume(0.1)
    	sound:play()
    end

    function m.squirt()
    	sound = love.audio.newSource("squirt.mp3", "stream")
    	sound:setVolume(1.4)
    	sound:play()
    end


    function m.shoot()
    	if m.tps > 0 then
    		p = Proj:create("tp.png")
    		m.yeet()
    	end
    end

    function m.use_mask()
    	if m.masks > 0 and not m.using_mask  then
            m.masks = m.masks - 1
            if m.health < 1 then
                m.using_mask = true
                m.protection = 3
            else
                p = Proj:create("mask.png")
                m.yeet()
            end

    		-- p = Proj:create()
    		-- m.yeet()
    	end
    end

    return m
end
