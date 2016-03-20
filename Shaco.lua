require "VPrediction"

local VP = nil
--local radius = 400
local enemyChamps, allyChamps = GetEnemyHeroes(), GetAllyHeroes()
local enemyCount
local allyCount
local iSlot
local smiterange = 760
local SmiteSlot = nil
local QREADY, WREADY, EREADY, RREADY  = false, false, false, false
local BRKSlot, DFGSlot, HXGSlot, BWCSlot, TMTSlot, RAHSlot, RNDSlot, YGBSlot = nil, nil, nil, nil, nil, nil, nil, nil
local BRKREADY, DFGREADY, HXGREADY, BWCREADY, TMTREADY, RAHREADY, RNDREADY, YGBREADY = false, false, false, false, false, false, false, false

function OnLoad()

PrintChat(">> Loaded Silent Shaco V0.3 by Tivia.")
    enemyCount = #enemyChamps
    allyCount = #allyChamps
		--LoadEvade()
VP = VPrediction()
Config = scriptConfig("Silent Shaco V0.3", "BasicShaco")

Config:addSubMenu("Basic Settings", "Basic")
Config:addSubMenu("Draw Settings", "Draw")

Config.Basic:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
Config.Basic:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
Config.Basic:addParam("UseW", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("UseE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("dontE", "Don't E when Stealthed", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("ignite", "Ignite", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("smite", "Smite Enemys", SCRIPT_PARAM_ONOFF, true)

Config.Draw:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("DrawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("DrawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("DrawRRange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("info", "-", SCRIPT_PARAM_INFO)
Config.Draw:addParam("DrawQ2", "Draw Q Damage", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("DrawE2", "Draw E Damage", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("DrawI", "Draw Ignite Damage", SCRIPT_PARAM_ONOFF, true)
 if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then iSlot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then iSlot = SUMMONER_2
    else iSlot = nil
    end
		if myHero:GetSpellData(SUMMONER_1).name:lower():find("smite") then SmiteSlot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("smite") then SmiteSlot = SUMMONER_2
	else SmiteSlot = nil
	end
DelayAction(CheckOrbwalk, 8)
end

--[[
 function LoadEvade()
      Config:addSubMenu("Evade", "Evade")
      DelayAction(function()
        if _G.Evadeee_Loaded == nil and _G.Evade == nil and _G.Evading == nil and _G.evade == nil and _G.evading == nil and ShacoAvoider then
          Config.Evade:addParam("activate", "Activate the chosen one", SCRIPT_PARAM_ONOFF, false)
          Config.Evade:setCallback("activate", function(var) if var then LoadEvade2() else UnloadEvade() end end)
          Config.Evade.activate then LoadEvade2() end
        else
         Config.Evade:addParam("info", "Inbuilt Evade disabled!", SCRIPT_PARAM_INFO, "")
        end
      end, 10)
]]--


local stealth = nil

function smiteChamp()
if Config.Basic.smite and Config.Basic.combo then
	local smiteDmg = 0		
	if SmiteSlot ~= nil and myHero:CanUseSpell(SmiteSlot) == READY then
		for i = 1, heroManager.iCount, 1 do
		local target = heroManager:getHero(i)
			if ValidTarget(target) then
			smiteDmg = 15 + 3 * myHero.level
				if target ~= nil and target.team ~= myHero.team and not target.dead and target.visible and GetDistance(target) < 760 then
					CastSpell(SmiteSlot, target)
				end
					
			end
		end
	end
end
end

function SmiteKS()

                local smiteDmg = 0         
                if SmiteSlot ~= nil and myHero:CanUseSpell(SmiteSlot) == READY then
                        for i = 1, heroManager.iCount, 1 do
                                local target = heroManager:getHero(i)
                                if ValidTarget(target) then
                                        smiteDmg = 15 + 3 * myHero.level
                                        if target ~= nil and target.team ~= myHero.team and not target.dead and target.visible and GetDistance(target) < 700 and target.health < smiteDmg then CastSpell(SmiteSlot, target)
                                                end
                                        end
                                end
                        end
                end


 function CheckOrbwalk()
	 if _G.Reborn_Loaded and not _G.Reborn_Initialised then
        DelayAction(CheckOrbwalk, 1)
    elseif _G.Reborn_Initialised then
        sacused = true
		Config.Orbwalking:addParam("info11","SAC Detected", SCRIPT_PARAM_INFO, "")
    elseif _G.MMA_Loaded then
		Config.Orbwalking:addParam("info11","MMA Detected", SCRIPT_PARAM_INFO, "")
		mmaused = true
	else
		require "SxOrbWalk"
		SxOrb:LoadToMenu(Config.Orbwalking, false) 
		sxorbused = true
		SxOrb:RegisterAfterAttackCallback(MyAfterAttack)
		DelayAction(function()		
			if SxOrb.Version < 2.3 then
				Print("Your SxOrbWalk library is outdated, please get the latest version!")
			end
		end, 5)
	end
end
function OnTick()
	if not myHero.dead then
		Checks()
	end
	if Config.Basic.combo then
		CastQ()
	end
	if Config.Basic.UseW and Config.Basic.combo then
		CastW()
	end
	if Config.Basic.UseE and Config.Basic.combo and Config.Basic.dontE and not stealth then	
		CastE()
	end
		if Config.Basic.UseE and Config.Basic.combo and not Config.Basic.dontE then	
		CastE()
	end
	ignite()
	SmiteKS()
--Qspots()
end

function OnDraw()
Qcrit()
drawDamage()
if Config.Draw.DrawQ then
	if stealth and os.clock()-stealth<3.5 then
		local radius=(1-(os.clock()-stealth)/3.5)*525
		DrawCircle3D(myHero.x, myHero.y, myHero.z,radius+125, 1, RGB(255, 255, 255)) 
	end
end	

if Config.Draw.DrawW and WREADY then
DrawCircle(myHero.x, myHero.y, myHero.z, 425, 0xFFFF0000)
end

if Config.Draw.DrawE and EREADY then
DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0xFFFF0000)
end

if Config.Draw.DrawR and RACTIVE then
DrawCircle(myHero.x, myHero.y, myHero.z, 1125, 0xFFFF0000)
end


	 -- blue team red buff
	 -- into red
		DrawCircle3D(8510, 52, 4698, 100, 1, RGB(255, 255, 255)) 
		
		--out of red
		DrawCircle3D(8044, 52, 4264, 100, 1, RGB(255, 255, 255)) 
		
		--blue team bot side out of base
		DrawCircle3D(5424, 52, 2956, 100, 1, RGB(255, 255, 255)) 
		
		--blue team bottom jungle into tower
		DrawCircle3D(5864, 52, 4354, 100, 1, RGB(255, 255, 255)) 
		
		-- blue team bottom wraiths into mid
		DrawCircle3D(6978, 52, 5618, 100, 1, RGB(255, 255, 255)) 
		
		--mid lane river to red tower 
		DrawCircle3D(8606, 52, 6766, 100, 1, RGB(255, 255, 255)) 
		
		--red team blue to mid
		DrawCircle3D(11010, 52, 6376, 100, 1, RGB(255, 255, 255)) 
		
		-- red team mid to blue
		DrawCircle3D(10438, 52, 6494, 100, 1, RGB(255, 255, 255)) 
		
		--bot lane gank near red tower
		DrawCircle3D(12472, 52, 4508, 100, 1, RGB(255, 255, 255)) 
		
		--bot lane gank near blue tower
		DrawCircle3D(10998, 52, 2526, 100, 1, RGB(255, 255, 255)) 
		
		--
	--fuckme()
--action1 = tostring(action1)
--action2 = tostring(action2)

  --DrawText(action1, 20, 100, 100, 0xFF00FFFF)
 -- DrawText(action2, 20, 100, 200, 0xFF00FFFF)

end
function OnProcessSpell(object,spell)
    if object.isMe and spell.name == "Deceive" then
    	stealth = os.clock()
    else
      stealth = nil
    end
 end
 
 function Checks()
    QREADY = ((myHero:CanUseSpell(_Q) == READY) or (myHero:GetSpellData(_Q).level > 0 and myHero:GetSpellData(_Q).currentCd <= 0.4))
    WREADY = ((myHero:CanUseSpell(_W) == READY) or (myHero:GetSpellData(_W).level > 0 and myHero:GetSpellData(_W).currentCd <= 0.4))
    EREADY = ((myHero:CanUseSpell(_E) == READY) or (myHero:GetSpellData(_E).level > 0 and myHero:GetSpellData(_E).currentCd <= 0.4))
    RREADY = ((myHero:CanUseSpell(_R) == READY) or (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd <= 0.4))
end
 
 function CastQ()
 if not QREADY then return end
 for i, target in pairs(GetEnemyHeroes()) do
	if ValidTarget(target, 425) and GetDistance(myHero, target) < 625 then
		CastSpell(_Q, target.x, target.z)
	end
	end
		CastSpell(_Q, mousePos.x, mousePos.z)
	end

 
 function CastE()
 for i, target in pairs(GetEnemyHeroes()) do
	if ValidTarget(target, 400) and GetDistance(myHero, target) < 500 then
		CastSpell(_E, target)
	end
end
end
		
		
 

function CastW()
for i, target in pairs(GetEnemyHeroes()) do
		if ValidTarget(target, 425) then
		
	local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, 200, 300, 425, math.huge, myHero)
	
	if MainTargetHitChance >= 2 and nTargets > 0 then
		CastSpell(_W, AOECastPosition.x, AOECastPosition.z)
	end
end
end
end

function ignite()
    if Config.Basic.ignite and Config.Basic.comboa and not stealth then
        local iDmg = 0
        if iSlot ~= nil and myHero:CanUseSpell(iSlot) == READY then
            for i = 1, heroManager.iCount, 1 do
                local target = heroManager:getHero(i)
                if ValidTarget(target) then
                    iDmg = 50 + 20 * myHero.level
                    if target ~= nil and target.team ~= myHero.team and not target.dead and target.visible and GetDistance(target) < 600 then
                        CastSpell(iSlot, target)
                    end
                end
            end
        end
    end
	end

function drawDamage()
Qcrit()
             for i = 1, enemyCount do
			local enemy = enemyChamps[i]
        if enemy.visible == true and enemy.dead == false then
            local framePos = GetAbilityFramePos(enemy)
            if OnScreen(framePos, framePos) then
							if Config.Draw.DrawQ2 then
                if QREADY then
                    local damageQ = function() return (myHero.totalDamage*critvalue) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageQ()) - 5
                    DrawOverheadHUD(enemy, framePos, 0, newDamage, "Q", TARGB({255,255,40,255}))
                end
							end
							if Config.Draw.DrawE2 then
                if EREADY then
                    local damageE = function() return (10 + (GetSpellData(2).level*40) + (myHero.ap) + (myHero.totalDamage)) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageE()) - 5
                    DrawOverheadHUD(enemy, framePos, 30, newDamage, "E", TARGB({255,255,255,255}))
                end
							end
							
							if Config.Draw.DrawI then
                local iDmg = 0
                if iSlot ~= nil and myHero:CanUseSpell(iSlot) == READY then
                    iDmg = 50 + 20 * myHero.level
                    DrawOverheadHUD(enemy, framePos, 52, iDmg, "Ignite", TARGB({255,255,0,0}))
                end
							end
							if Config.Draw.drawCombo then
							
                if QREADY and WREADY and EREADY and RREADY then
                    local damageQ = function() return (40 + (GetSpellData(0).level*40) + (myHero.ap*0.65)) end


                    local damageE = function() return (35 + (GetSpellData(2).level*35) + (myHero.ap*0.55)) end
                
                    newDamage = myHero:CalcMagicDamage(enemy, damageQ()+damageE()+iDmg()) - 5
                    DrawOverheadHUD(enemy, framePos, 58, newDamage, "E+Q+Ignite", TARGB({255,255,100,100}))
                end
end


            end
        end
    end
end
function DrawOverheadHUD(unit, framePos, Textheight, newDamage, str, color)
    local barPos = Point(framePos.x, framePos.y - 18)
    healthMissing = (unit.maxHealth - unit.health)
    offset = -105 * (newDamage/unit.maxHealth + healthMissing/unit.maxHealth)
    barPos = Point(framePos.x + 105, framePos.y - 26)

    if offset <= (-105) then
        DrawText(str, 40, barPos.x + - 100, barPos.y - 23, color)
        DrawText("Kill the bitch", 20, barPos.x + - 100, barPos.y - 40, color)
    else
        DrawText(str, 14, barPos.x + offset + 5, (barPos.y - 15) - Textheight , color)
        DrawRectangle(barPos.x + offset - 1, barPos.y - Textheight, 2, 15 + Textheight, color)
        DrawRectangle(barPos.x + offset - 1, barPos.y - 2 - Textheight, 15, 2, color)
    end

end

function GetAbilityFramePos(unit)
    local barPos = GetUnitHPBarPos(unit)
    local barOffset = GetUnitHPBarOffset(unit)

    do -- For some reason the x offset never exists
    local t = {
        ["Darius"] = -0.05,
        ["Renekton"] = -0.05,
        ["Sion"] = -0.05,
        ["Thresh"] = 0.03,
    }
    barOffset.x = t[unit.charName] or 0
    end

    return Point(barPos.x - 69 + barOffset.x * 150, barPos.y + barOffset.y * 50 + 12.5)
end

function TARGB(colorTable)
    do return ARGB(colorTable[1], colorTable[2], colorTable[3], colorTable[4])
    end
end

function isFacing(source, target, lineLength)
local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
local sourcePos = Vector(source.x, source.z)
sourceVector = (sourceVector-sourcePos):normalized()
sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
end

--DRAW COOLDOWNS
function fuckme()

--action1 = ("X Position:"     ..myHero.x) 
--action2 = ("Q Crit:"     ..myHero.totalDamage*critvalue) 
--print(""..myHero.totalDamage*critvalue)

end

function Qcrit()
        if myHero:GetSpellData(_Q).level == 1 then
            critvalue = 1.4
        end
        if myHero:GetSpellData(_Q).level == 2 then
            critvalue = 1.6
        end
        if myHero:GetSpellData(_Q).level == 3 then
            critvalue = 1.8
        end
        if myHero:GetSpellData(_Q).level == 4 then
            critvalue = 2
        end
        if myHero:GetSpellData(_Q).level == 5 then
            critvalue = 2.2
        end
end

function Qspots()
--if QREADY then
--blueteam red bush into red
--myHero:MoveTo(8510, 4698)
--if myHero.x == 8510 and myHero.z == 4698 then
	--CastSpell(_Q, 8044, 4262)
--end
--blue team red into bush
--myHero:MoveTo(8044, 4264)
 --if myHero.x == 8044 and myHero.z == 4264 then
	--CastSpell(_Q, 8510, 4698)
	--end
	
	--blue team bottom base into jungle
	--myHero:MoveTo(5424, 2956)
	--if myHero.x == 5424 and myHero.z == 2956 then
	--CastSpell(_Q, 6060, 3148)
	--end
	
	--blue team jungle to tower
	--myHero:MoveTo(5864, 4354)
	--if myHero.x == 5864 and myHero.z == 4354 then
	--CastSpell(_Q, 5440, 4842)
	--end
	-- blue team wraiths to mid
		--myHero:MoveTo(6978, 5618)
	if myHero.x == 6978 and myHero.z == 5618 then
	CastSpell(_Q, 7024, 6108)
	end
	-- mid lane river to red side tower
	--myHero:MoveTo(8606, 6766)
	if myHero.x == 8606 and myHero.z == 6766 then
	CastSpell(_Q, 8810, 7348)
	end
	--red team blue to mid   
		--myHero:MoveTo(11010, 6376)
	if myHero.x == 11010 and myHero.z == 6376 then
		CastSpell(_Q, 10438, 6594)
	end
	
	--red team mid to blue
		--myHero:MoveTo(10438, 6594)
	if myHero.x == 10438 and myHero.z == 6594 then
		CastSpell(_Q, 11010, 6376)
	end
	-- bot lane gank near red tower    -- reverse cordinates later
		--myHero:MoveTo(12472, 4508)
	if myHero.x == 12472 and myHero.z == 4508 then
		CastSpell(_Q, 13072, 4008)
	end
	
	-- bot lane gank near blue tower
	--myHero:MoveTo(10998, 2526)
	if myHero.x == 10998 and myHero.z == 2526 then
		CastSpell(_Q, 11564, 2950)
	end
	--blue team top side into jungle
		--myHero:MoveTo(3574, 5258)
	if myHero.x == 3574 and myHero.z == 5258 then
		CastSpell(_Q, 3806, 5784)
	end
	--blue team top side jungle into base
		--myHero:MoveTo(3806, 5784)
	if myHero.x == 3806 and myHero.z == 5784 then
		CastSpell(_Q, 3574, 3574)
	end
	-- blue team river into blue buff
		--myHero:MoveTo(4324, 8306)
	if myHero.x == 4324 and myHero.z == 8306 then
		CastSpell(_Q, 3790, 8488)
	end
	--blue team gank near blue tower
		--myHero:MoveTo(2324, 10306)
	if myHero.x == 2324 and myHero.z == 10306 then
		CastSpell(_Q, 1788, 10844)
	end
	-- baron pit towards red team tower
	--myHero:MoveTo(4724, 10856)
	if myHero.x == 4724 and myHero.z == 10856 then
		CastSpell(_Q, 4492, 11440)
	end
	--red team red into red buff
	--myHero:MoveTo(6298, 10162)
	if myHero.x == 6298 and myHero.z == 10162 then
		CastSpell(_Q, 6800, 10636)
	end
	--red team red out of red buff
	--myHero:MoveTo(6800, 10636)
	if myHero.x == 6800 and myHero.z == 10636 then
		CastSpell(_Q, 6298, 10162)
	end
	--red team wraiths into mid lane
	--myHero:MoveTo(7822, 9306)
	if myHero.x == 7822 and myHero.z == 9306 then
		CastSpell(_Q, 7784, 8818)
	end
	--red team top base into jungle
	--myHero:MoveTo(9422, 11856)
	if myHero.x == 9422 and myHero.z == 11856 then
		CastSpell(_Q, 8842, 11674)
	end
	--red team bottom jungle into base
		--myHero:MoveTo(11172, 9056)
	if myHero.x == 11172 and myHero.z == 9056 then
		CastSpell(_Q, 11358, 9590)
	end
	--red team bottom base into jungle
	--myHero:MoveTo(11358, 9590)
	if myHero.x == 11358 and myHero.z == 9590 then
		CastSpell(_Q, 11172, 9056)
	end
--end
end

--[[
function ShadowVayne:WallTumble()
    if myHero:CanUseSpell(_Q) ~= 0 then
        self.Menu.keysetting.MidTumble = false
        self.Menu.keysetting.DrakeTumble = false
        return
    end
    if self.Menu.keysetting.MidTumble then
        if myHero.x == 6962 and myHero.z == 8952 then
            self.Menu.keysetting.MidTumble = false
            CastSpell(_Q,6667.3271484375,8794.64453125)
        else
            myHero:MoveTo(6962, 8952)
        end
    end
    if self.Menu.keysetting.DrakeTumble then
        if myHero.x == 12060 and myHero.z == 4806 then
            self.Menu.keysetting.DrakeTumble = false
            CastSpell(_Q,11745.198242188,4625.4379882813)
        else
            myHero:MoveTo(12060, 4806)
        end
    end
end]]--
