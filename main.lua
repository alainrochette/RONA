
require "Virus"
require "Me"
require "TP"
require "HS"
require "Proj"


function love.conf(t)
  t.releases = {
    title = "RONA",              -- The project title (string)
    package = "rona",            -- The project command and package name (string)
    -- loveVersion = nil,        -- The project LÖVE version
    -- version = nil,            -- The project version
    author = "alain",             -- Your name (string)
    -- email = nil,              -- Your email (string)
    description = nil,        -- The project description (string)
    -- homepage = nil,           -- The project homepage (string)
    -- identifier = nil,         -- The project Uniform Type Identifier (string)
    excludeFileList = {},     -- File patterns to exclude. (string list)
    releaseDirectory = nil,   -- Where to store the project releases (string)
  }
end


Mask = {}
Mask.__index = Mask

function Mask:create()
   local m = {}
	 m.scale = scale*0.3
     m.x = math.random(1,w)
	 m.y = math.random(1,h)

	 m.img = love.graphics.newImage("mask.png")
	 m.w = m.img:getWidth()*m.scale
	 m.h = m.img:getHeight()*m.scale
   return m
end

Granny = {}
Granny.__index = Granny

function Granny:create()
   local g = {}
	 g.scale = scale*0.2
     g.x = -20
	 g.y = 150

	 g.img = love.graphics.newImage("granny.png")
	 g.w = g.img:getWidth()*g.scale
	 g.h = g.img:getHeight()*g.scale
   return g
end

function love.load()
    success = love.window.setMode(1280,750)
    music = love.audio.newSource("FINAL.mp3", "stream")
    music:play()

     w = love.graphics.getWidth()
     h = love.graphics.getHeight()
     scale = 0.8
     me = Me:create()
     waves = {}
     n_waves = 0

     TPs = {}
     n_TPs = 0
     days = 0

     HSs = {}
     n_HSs = 0

     Masks = {}
     n_Masks = 0

     Grannys = {}
     n_Grannys = 0

     htimer = 0
     timer = 0
     vtimer = 0
     ttimer = 0
     stimer = 0
     mtimer = 0
     gtimer =  0
     cdctimer = 0
     mfriction = 2
     friction = 0.3
     acc =  (w/1280)*10

     virSpeed = 1
     xacc = 0
     yacc = 0

     topspeed =  (w/1280)*1.2


     local f = love.graphics.newFont(30)
     love.graphics.setFont(f)
     love.graphics.setColor(0,0,0,255)
     -- love.graphics.setBackgroundColor(255,100,100)
end

function new_wave()
    v = Virus:create()
    n_waves = n_waves + 1
    table.insert(waves, v)
end

function new_TP()
    tp = TP:create()
    n_TPs = n_TPs + 1
    table.insert(TPs, tp)
end

function new_HS()
    hs = HS:create()
    n_HSs = n_HSs + 1
    table.insert(HSs, hs)
end

function new_Mask()
    m = Mask:create()
    n_Masks = n_Masks + 1
    table.insert(Masks, m)
end

function new_Granny()
    g = Granny:create()
    n_Grannys = n_Grannys + 1
    table.insert(Grannys, g)
end

function love.update(dt)
    if not me.dead then
        -- m = 1
        -- if me.health  >0 then m = me.health end
        music:setPitch(math.min(1.5*me.health, 1))
        -- days = days + dt
        timer = timer + dt
        days = math.floor(timer/2)
        htimer = htimer + dt
        vtimer = vtimer + dt
        ttimer = ttimer + dt
        stimer = stimer + dt
        mtimer = mtimer + dt
        gtimer = gtimer + dt
        if me.coughing >= 1 then me.coughing = me.coughing + dt end
        if me.coughing >= 1.5 then me.coughing = 0 end
        if vtimer > 2 then
            new_wave()
            vtimer = 0
        end
        if ttimer > 2 then
            new_TP()
            ttimer = 0
        end
        if htimer > 5 then
            new_HS()
            htimer = 0
        end
        if stimer > 7 then
            virSpeed = math.min(12,virSpeed * 1.3)
            stimer = 0
        end
        if mtimer > 4.5 then
            new_Mask()
            mtimer = 0
        end
        if gtimer > 14 then
            new_Granny()
            gtimer =  0
        end
        if me.protection > 0 then me.protection = me.protection - dt end
        if me.protection <= 0 then
            me.protection = 0
            me.using_mask = false
        end

    end
end


function update_pos()

    me.y = me.y + yacc
    me.x = me.x + xacc

    if me.y < 0 then
        me.y = 0
        yacc = 0
    end
    if me.y + me.h > h then
        me.y = h - me.h
        yacc = 0
    end
    if me.x < 0 then
        me.x = 0
        xacc = 0
    end
    if me.x + me.w > w then
        me.x = w - me.w
        xacc = 0
    end
    for v = 1 , n_waves do
        vir = waves[v]
        if vir then

            vir.x = vir.x - 0.3*vir.speed*virSpeed
            vir.y = vir.y - 0.6*vir.speed*virSpeed
            if vir.x < -100 then vir.x = w end
            if vir.y < -100 then vir.y = h end
        end
    end

    for p = 1 , me.n_projs do
        proj = me.projs[p]
        if proj then
            proj.x = proj.x + proj.dirx*proj.speed
            proj.y = proj.y + proj.diry*proj.speed
            if proj.x < 0 then proj = nil end
            if proj and proj.y < 0 then proj = nil end
        end
    end

    for g = 1 , n_Grannys do
        gran = Grannys[g]
        if gran then
            if me.has_granny then
                gran.x = me.x
                gran.y = me.y
            else
                gran.x = gran.x + (w/1280)*0.2
                gran.y = gran.y - (w/1280)*0.2
            end
            if me.has_granny and gran.x < 0.5 then
                Grannys[g] = nil
                me.health = me.health + 0.5
                me.has_granny = false
            end
            -- if vir.y < -100 then vir.y = h end
        end
    end
end

function hit(a,b)
    if not a or not b then return false end
    if a.x <= b.x + b.w and a.y <= b.y + b.h and a.x >= b.x and a.y >= b.y or
     a.x + a.w <= b.x + b.w and a.y <= b.y + b.h and a.x + a.w  >= b.x and a.y >= b.y or
     a.x <= b.x + b.w and a.y + a.h <= b.y + b.h and a.x >= b.x and a.y+ a.h >= b.y  or
     a.x + a.w <= b.x + b.w and a.y + a.h <= b.y + b.h and a.x + a.w >= b.x and a.y + a.h  >= b.y then
         return true
    end
    return false
end

function check_if_hit()
    red = (1-math.min(1, me.health))
    love.graphics.setBackgroundColor(1,1-red,1-red)
    for v = 1 , n_waves do
        vir = waves[v]
        if vir and hit(vir, me) and me.protection == 0 then
        -- love.graphics.setBackgroundColor(1,0.8,0.8)
        me.health = me.health - 0.002*virSpeed
        me.Cough()
        end
        for t = 1, n_TPs do
            tp = TPs[t]
            if tp then
                if hit(tp, vir) then TPs[t] = nil end
            end
        end
        for h = 1, n_HSs do
            hs = HSs[h]
            if hs then
                 if hit(hs, vir) then HSs[h] = nil end
            end
        end
        for m = 1, n_Masks do
            mask = Masks[m]
            if mask then
                 if hit(mask, vir) then Masks[m] = nil end
            end
        end
        for g = 1 , n_Grannys do
            gran = Grannys[g]
            if gran and hit(gran, vir) and not (me.has_granny and me.protection > 0) then
                Grannys[g] = nil
                waves[v] = nil
                me.has_granny = false
            end
        end
    end

    for t = 1, n_TPs do
        tp = TPs[t]
        if tp and hit(tp, me) then
            me.tps = me.tps + 1
            newTPs = {}
            for tt = 1 , n_TPs do
                ttp = TPs[tt]
                if not (ttp == tp) then
                    table.insert(newTPs, ttp)
                end
            end
            n_TPs = n_TPs - 1
            TPs = newTPs
        end
    end
    for h = 1, n_HSs do
        hs = HSs[h]
        if hs and hit(hs, me) then
            me.health = me.health + 0.3
            me.squirt()
            newHSs = {}
            for hh = 1 , n_HSs do
                hss = HSs[hh]
                if not (hss == hs) then
                    table.insert(newHSs, hss)
                end
            end
            n_HSs = n_HSs - 1
            HSs = newHSs
        end
    end
    for m = 1 , n_Masks do
        mask = Masks[m]
        if mask and hit(mask, me) then
            me.masks = me.masks + 1
            Masks[m] = nil
        end
    end


    for p = 1, me.n_projs do
        p = me.projs[p]
        if p then
            for v = 1 , n_waves do
                 vir = waves[v]
                 if vir and hit(vir, p) then waves[v] = nil end
            end
        end
    end

    for g = 1 , n_Grannys do
        gran = Grannys[g]
        if gran and hit(gran, me) then
            gran.x = me.x
            gran.y = me.y
            me.has_granny=true
        end
    end

end
--
function draw()
    -- love.graphics.draw(me.aimimg, me.aimx, me.aimy,me.aimr,me.aimscale,me.aimscale)
    love.graphics.draw(me.img, me.x, me.y,0,me.scale,me.scale)
    if me.protection > 0 then
        love.graphics.draw(me.shield, me.x-me.w/4, me.y-me.h/4,0,me.shieldscale, me.shieldscale)
    else
        love.graphics.draw(me.shield, -1000, -1000,0,me.shieldscale, me.shieldscale)
    end
    for v = 1 , n_waves do
         vir = waves[v]
         if vir then love.graphics.draw(vir.img, vir.x, vir.y, 0, vir.scale, vir.scale) end
    end
    onegran  =false
    for g = 1 , n_Grannys do
         gran = Grannys[g]
         if gran then
            love.graphics.draw(gran.img, gran.x, gran.y, 0, gran.scale, gran.scale)
            love.graphics.setColor(0.4,0.4,1)
            love.graphics.rectangle("fill", 0, 0, 20, h )
            love.graphics.setColor(1,1,1,255)
            onegran = true
        end
    end
    for t = 1 , n_TPs do
        tp = TPs[t]
        if tp then  love.graphics.draw(tp.img, tp.x, tp.y, 0, tp.scale, tp.scale) end
    end
    for p = 1 , me.n_projs do
        pro = me.projs[p]
        if pro then love.graphics.draw(pro.img, pro.x, pro.y, pro.r, pro.scale, pro.scale) end
    end
    for h = 1 , n_HSs do
        hs = HSs[h]
        if hs then love.graphics.draw(hs.img, hs.x, hs.y, 0, hs.scale, hs.scale) end
    end
    for m = 1 , n_Masks do
        mask = Masks[m]
        if mask then love.graphics.draw(mask.img, mask.x, mask.y, 0, mask.scale, mask.scale) end
    end
end

function exitgame()
    me.dead = true
    music:stop()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", 0, 0, w, h )
    love.graphics.setColor(0,0,0)
    love.graphics.print("You Survived For", w/2-20,h/2)
    love.graphics.print(days, w/2- 20,h/2 + 30)
    love.graphics.print("Days", w/2-20,h/2 + 60)
end

function love.draw()
    if me.health < 0.08 then
        exitgame()
    else
        me.dirx = 0
        me.diry = 0
        if love.keyboard.isDown("s") then
                me.diry = me.diry + 1
                yacc = me.health*math.min((yacc+acc),topspeed)
        end
        if love.keyboard.isDown("w") then
                me.diry = me.diry - 1
                friction = 0.3
                yacc = me.health*math.max((yacc-acc),-1*topspeed)
        end
        if love.keyboard.isDown("a") then
                me.dirx = me.dirx - 1
                friction = 0.3
                xacc = me.health*math.max((xacc-acc),-1*topspeed)
        end
        if love.keyboard.isDown("d") then
                me.dirx = me.dirx + 1
                friction = 0.3
                xacc = me.health*math.min((xacc+acc),topspeed)
                -- print(me.x, me.y)
        end
        if me.dirx == 1 or me.diry == 1 then
            length = math.sqrt(me.dirx * me.dirx + me.diry * me.diry)
            me.dirx = me.dirx / length
            me.diry = me.diry / length
            -- if me.dirx == 0 and me.diry == 0 then me.dirx = 1 end
        end
        me.aimx = me.x + me.w /2 + me.dirx * 70
        me.aimy = me.y + me.h /2 + me.diry * 70

        -- print(me.aimx, me.aimy)
        -- me.aimr = math.asin((me.dirx * me.x  + me.diry * (me.y-70))/  (math.sqrt(me.dirx*me.dirx+ me.diry*me.diry)+math.sqrt(me.x*me.x + (me.y-70)*(me.y-70))))
        update_pos()
        check_if_hit()
        draw()



         if yacc > 0 then yacc = math.max(0,yacc-acc*friction) end
         if yacc < 0 then yacc = math.min(0,yacc+acc*friction) end
         if xacc > 0 then xacc = math.max(0,xacc-acc*friction) end
         if xacc < 0 then xacc = math.min(0,xacc+acc*friction) end

         draw_stats()
    end
end

function draw_stats()
    love.graphics.setColor(0,0,0,255)
    love.graphics.print("Days " , 10, 10)
    love.graphics.print(days, 130,10)
    love.graphics.print("Health " , 10, 50)
    love.graphics.print(me.health, 130,50)
    love.graphics.print("TPs " , 10, 90)
    love.graphics.print(me.tps, 130,90)
    love.graphics.print("Masks " , 10, 130)
    love.graphics.print(me.masks, 130,130)

    if me.protection > 0 then love.graphics.print(math.floor(me.protection+1), me.x + me.w/2 - 18, me.y - me.h/2) end
    love.graphics.setColor(1,1,1,255)
end

function love.mousepressed(x, y, button)
     if button == 'l' then
        me.x = x -- move image to where mouse clicked
        me.y = y
     end
end

function love.mousereleased(x, y, button)
     if button == 'l' then
            fireSlingshot(x,y) -- this totally awesome custom function is defined elsewhere
     end
end

function love.keypressed(key, unicode)

     if key == 'space' then
                me.shoot()
     elseif key == 'm' then
            me.use_mask()
     end
end

function love.keyreleased(key, unicode)
    if key == "w" or key == "s" or key == "a" or key == "d" then
         friction = mfriction*friction
    end
     if key == 'b' then
            text = "The B key was released."
     elseif key == 'a' then
            a_down = false
     end
end
