--[[ still only 60% finished but now its functioning properly]]--
--[[  ]]--
--[[ rewrite Wardjump ]]--
--[[ rewrite Klokje's Insec ]]--
--[[ add items to combo ]]--
--[[ add orbwalking in combo eventually ]]--
--[[ Silent Man's LeeSin Script ]]--
if myHero.charName ~= "LeeSin" then return end

local efarm = false
local efarmHK = 85
local Assistant
local enemyTable = GetEnemyHeroes()
local informationTable = {}
local spellExpired = true
local qrange = 975
local qwidth = 75
local wrange = 700
local erange = 425
local rrange = 375
local ignite = nil
local BRKSlot, DFGSlot, HXGSlot, BWCSlot, TMTSlot, RAHSlot, RNDSlot, YGBSlot = nil, nil, nil, nil, nil, nil, nil, nil
local QREADY, WREADY, EREADY, RREADY, IREADY = false, false, false, false, false
--[[    Ward Jump       ]]--
local WardTable = {}
local SWard, VWard, SStone, RSStone, Wriggles = 2044, 2043, 2049, 2045, 3154
local SWardSlot, VWardSlot, SStoneSlot, RSStoneSlot, WrigglesSlot = nil, nil, nil, nil, nil
local jumpReady = false
local jumpRange = 540
local wardRange = 600
local jumpDelay = 0

require "VPrediction"
        local VP = nil
require "Collision"
		local collision
col = Collision(1200, 2000, 0.2, 100)
newcol = Collision(1200, 1500, 0.1, 100)

function OnLoad()
VP = VPrediction()
Config = scriptConfig("Lee Sin","vk")
Config:addSubMenu("Basic Settings", "Basic")
Config:addSubMenu("Ult Settings", "ultimate")
Config:addSubMenu("Draw Settings", "Draw")

--> Basic Settings
Config.Basic:addParam("doCombo", "QQE combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
Config.Basic:addParam("doCombo2", "QERQ combo", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("c"))
Config.Basic:addParam("harass", "harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("T"))
--Config.Basic:addParam("wardjump", "Ward Jump", SCRIPT_PARAM_ONKEYDOWN, false, 71)
Config.Basic:addParam("efarm", "EFarm", SCRIPT_PARAM_ONOFF, true)
--Config.Basic:addParam("Insec", "Insec", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("j"))
Config.ultimate:addParam("antigapcloser", "Ult GapClosing Enemies", SCRIPT_PARAM_ONOFF, false)
Config.ultimate:addParam("ultCount", "Enemys in Line+ult", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
Config.ultimate:addParam("autoult", "Ult When Killable", SCRIPT_PARAM_ONOFF, true)
--> Draw Settings
Config.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("calc", "Draw Calculations", SCRIPT_PARAM_ONOFF, true)
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1050, DAMAGE_PHYSICAL, true)
Config:addTS(ts)
for i = 0, objManager.maxObjects, 1 do
                local object = objManager:GetObject(i)
                        if WardCheck(object) then table.insert(WardTable, object) end
end  
PrintChat(" >> Silent Lee Sin Loaded")
end


--[[    Ward Jump       ]]--
function OnCreateObj(object)
  if WardCheck(object) then table.insert(WardTable, object) end
end

function WardCheck(object)
        return object and object.valid and (string.find(object.name, "Ward") ~= nil or string.find(object.name, "Wriggle") ~= nil)
end
 
function JumpReady()
        if jumpReady == true then
                for i,object in ipairs(WardTable) do
                        if object ~= nil and object.valid and math.sqrt((object.x-mousePos.x)^2+(object.z-mousePos.z)^2) < 150 then
                                CastSpell(_W, object)
                                jumpReady = false
                        end
   end
        end
end
 
function JumpCheck()
        local x = mousePos.x
        local z = mousePos.z
        local dx = x - player.x
        local dz = z - player.z
        local rad1 = math.atan2(dz, dx)
       
        SWardSlot = GetInventorySlotItem(SWard)
        VWardSlot = GetInventorySlotItem(VWard)
        SStoneSlot = GetInventorySlotItem(SStone)
        RSStoneSlot = GetInventorySlotItem(RSStone)
        WrigglesSlot = GetInventorySlotItem(Wriggles)
 
        if RSStoneSlot ~= nil and CanUseSpell(RSStoneSlot) == READY then
                wardSlot = RSStoneSlot
        elseif SStoneSlot ~= nil and CanUseSpell(SStoneSlot) == READY then
                wardSlot = SStoneSlot
        elseif SWardSlot ~= nil then
                wardSlot = SWardSlot
        elseif VWardSlot ~= nil then
                wardSlot = VWardSlot
        elseif WrigglesSlot ~= nil then
                wardSlot = WrigglesSlot
        else wardSlot = nil
        end
 
        if wardSlot ~= nil then
                local dx1 = jumpRange*math.cos(rad1)
                local dz1 = jumpRange*math.sin(rad1)
                local x1 = x - dx1
                local z1 = z - dz1
                if WREADY and math.sqrt(dx*dx + dz*dz) <= 600 then
                        CastSpell( wardSlot, x, z )
                        jumpReady = true
                elseif WREADY then player:MoveTo(x1, z1)
                        else myHero:StopPosition()
                end
        end
end
function castR(target)
	rPred = nil
	
	for i, target in pairs(GetEnemyHeroes()) do
		CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.1, 100, 375, 1500, myHero, true)
        if HitChance >= 2 and GetDistance(CastPosition) < 375 then
			local collition = Collision(1200, 2000, 0.2, 100)
			local Enemies = 0
			local maxDistance = myHero + (Vector(rPred) - myHero):normalized()*1000
            local collision, champs = col:GetHeroCollision(myHero, maxDistance, HERO_ENEMY)
			if RREADY and GetDistance(maxDistance, myHero) < 1200 and collision and champs then
				for i, champs in pairs(champs) do
					Enemies = Enemies + 1
				end
				if Enemies >= Config.ultimate.ultCount then CastSpell(_R, target) end
			end
		end
	end
end

--[[function test_castR()
	local bestRtar, bestRenemyOnWay = nil, 0
	local currTarVPredPos, currTarVecPos = nil, nil
	local coll_count = 0
	local can_cast = false	
	for i, currTarget in pairs(GetEnemyHeroes()) do 
		currTarVecPos = nil
		currTarVPredPos = nil, 375, 1500, myHero, true) --calc target position on casttime
		if HitChance >= 2 and GetDistance(CastPosition) <= 375 then --check if valid hitchance + in range
			currTarVecPos = myHero + (Vector(currTarVPredPos) - myHero):normalized()*1000
			local iscollision, enemyInCollision = newcol:GetHeroCollision(myHero, currTarVecPos, HERO_ENEMY)
			if iscollision then
				for i, currCollEnemy in pairs(enemyInCollision) do
		coll_count = 0
		local currTarVPredPos,  HitChance,  Position = VP:GetLineCastPosition(currTarget, 0.1, 100
					coll_count = coll_count + 1
				end
				if coll_count >= bestRenemyOnWay then 
					bestRenemyOnWay = coll_count
					bestRtar = currTarget
					can_cast = true
				end	
			end
		end
	end
if iscollision and RREADY and can_cast and coll_count >= Config.ultimate.ultCount then CastSpell(_R, bestRtar) end
end		
]]--
function OnDraw()
       if ValidTarget(ts.target, rrange) and RREADY then
                        local enemyPos = ts.nextPosition
                        if enemyPos ~= nil then
                                local x1, y1, OnScreen1 = get2DFrom3D(myHero.x, myHero.y, myHero.z)
                                local x2, y2, OnScreen2 = get2DFrom3D(enemyPos.x, enemyPos.y, enemyPos.z)
                                DrawLine(x1, y1, x2, y2, 3, 0xFFFF0000)
                        end
    end
if Config.Basic.wardjump and not myHero.dead then
                DrawCircle(myHero.x, myHero.y, myHero.z, wrange, 0x0000FF)
end
if EREADY and Config.Draw.drawE and not myHero.dead then
                DrawCircle(myHero.x, myHero.y, myHero.z, erange, 0x0000FF)
end
if QREADY and Config.Draw.drawQ and not myHero.dead then
								DrawCircle(myHero.x, myHero.y, myHero.z, qrange, 0x0000FF)
								end
								end
								



		
function CountEnemyHeroInRange(range)
 local enemyInRange = 0
 for i = 1, heroManager.iCount, 1 do
  local enemyheros = heroManager:getHero(i)
  if enemyheros.valid and enemyheros.visible and enemyheros.dead == false and enemyheros.team ~= myHero.team and GetDistance(enemyheros) <= range then
   enemyInRange = enemyInRange + 1
  end
 end
 return enemyInRange
end

function efarm()
                local myE = math.floor((player:GetSpellData(_E).level-1)*33 + 60 + player.damage * 1)
    for k = 1, objManager.maxObjects do
        local minionObjectI = objManager:GetObject(k)
                        if minionObjectI ~= nil and string.find(minionObjectI.name,"Minion_") == 1 and minionObjectI.team ~= player.team and minionObjectI.dead == false then
       if  player:GetDistance(minionObjectI) < 375 and minionObjectI.health <= player:CalcMagicDamage(minionObjectI, myE) and myHero:GetSpellData(_E).name == "BlindMonkEOne" then
                                        CastSpell(_E, minionObjectI)
       end
      end
                end
end

function castQ(target)
	for i, target in pairs(GetEnemyHeroes()) do
            CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.1, 80, qrange, 1500, myHero, true)
            if HitChance >= 2 or 5 and GetDistance(CastPosition) < 1050 then
						local collision = Collision(975, 1500, .1, 80)
                    willCollide = collision:GetMinionCollision(CastPosition, myHero)
                    if QREADY and GetDistance(CastPosition, myHero) < 1050 and minionCollisionWidth == 0 then
                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                    end
										if QREADY and GetDistance(CastPosition, myHero) < 975 and 80 > 0 and not willCollide and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then 
											CastSpell(_Q, CastPosition.x, CastPosition.z)
											if myHero:GetSpellData(_Q).name == "blindmonkqtwo" then
											CastSpell(_Q) 
										end
						
			end
    end
end
end


function castQ2(target)
	for i, target in pairs(GetEnemyHeroes()) do
            CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.1, 80, qrange, 1500, myHero, true)
            if HitChance >= 2 or 5 and GetDistance(CastPosition) < 1050 then
						local collision = Collision(975, 1500, .1, 80)
                    willCollide = collision:GetMinionCollision(CastPosition, myHero)
                    if QREADY and GetDistance(CastPosition, myHero) < 1050 and minionCollisionWidth == 0 then
                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                    end
										if QREADY and GetDistance(CastPosition, myHero) < 975 and 80 > 0 and not willCollide and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then 
											CastSpell(_Q, CastPosition.x, CastPosition.z)
										end
						
			end
    end
end
				

function autoult()
        if RREADY then
                local rDmg = 0    
                for i = 1, heroManager.iCount, 1 do
                        local enemyhero = heroManager:getHero(i)
                        if ValidTarget(enemyhero, (rrange+50)) then
                                rDmg = getDmg("R", enemyhero, myHero)
                                if enemyhero.health <= rDmg then
                                        CastSpell(_R, enemyhero)
                                end
                        end
                end
        end
end

	function Checks()
        BRKSlot, DFGSlot, HXGSlot, BWCSlot, TMTSlot, RAHSlot, RNDSlot, YGBSlot = GetInventorySlotItem(3153), GetInventorySlotItem(3128), GetInventorySlotItem(3146), GetInventorySlotItem(3144), GetInventorySlotItem(3077), GetInventorySlotItem(3074),  GetInventorySlotItem(3143), GetInventorySlotItem(3142)
        QREADY = (myHero:CanUseSpell(_Q) == READY)
        WREADY = (myHero:CanUseSpell(_W) == READY)
        EREADY = (myHero:CanUseSpell(_E) == READY)
        RREADY = (myHero:CanUseSpell(_R) == READY)
        DFGREADY = (DFGSlot ~= nil and myHero:CanUseSpell(DFGSlot) == READY)
        HXGREADY = (HXGSlot ~= nil and myHero:CanUseSpell(HXGSlot) == READY)
        BWCREADY = (BWCSlot ~= nil and myHero:CanUseSpell(BWCSlot) == READY)
        BRKREADY = (BRKSlot ~= nil and myHero:CanUseSpell(BRKSlot) == READY)
        TMTREADY = (TMTSlot ~= nil and myHero:CanUseSpell(TMTSlot) == READY)
        RAHREADY = (RAHSlot ~= nil and myHero:CanUseSpell(RAHSlot) == READY)
        RNDREADY = (RNDSlot ~= nil and myHero:CanUseSpell(RNDSlot) == READY)
        YGBREADY = (YGBSlot ~= nil and myHero:CanUseSpell(YGBSlot) == READY)
        IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
        ts:update()
        end

function UseItems(target)
        if GetDistance(target) < 550 then
                if DFGREADY then CastSpell(DFGSlot, target) end
                if HXGREADY then CastSpell(HXGSlot, target) end
                if BWCREADY then CastSpell(BWCSlot, target) end
                if BRKREADY then CastSpell(BRKSlot, target) end
                if YGBREADY then CastSpell(YGBSlot, target) end
                if TMTREADY and GetDistance(target) < 275 then CastSpell(TMTSlot) end
                if RAHREADY and GetDistance(target) < 275 then CastSpell(RAHSlot) end
                if RNDREADY and GetDistance(target) < 275 then CastSpell(RNDSlot) end
        end
end

 
function qtwo()
if myHero:GetSpellData(_Q).name == "blindmonkqtwo" then
CastSpell(_Q)
end
end

function qrqcombo(target)
if RREADY and GetDistance(ts.target) <= rrange then
CastSpell(_R, ts.target)
end
end
function eecombo(target)
 if EREADY and GetDistance(ts.target) <= erange then 
 CastSpell(_E)
	end
	end

function scriptpick()
	if QREADY then castQ()
	end
	end
	
function comboone(target)
	if QREADY and not target.dead then
		castQ(target)
	end
	if myHero:GetSpellData(_Q).name == "blindmonkqtwo" then
		qtwo()
	end
	if EREADY then
		eecombo()
	end
	if GetDistance(target) < 275 then
		UseItems()
	end
end

function combotwo(target)
	if QREADY and not target.dead then
		castQ2()
	end
	if EREADY then 
		eecombo()
	end
	if GetDistance(target) < 275 then
		UseItems()
	end
	if RREADY then
		qrqcombo()
	end
	if myHero:GetSpellData(_Q).name == "blindmonkqtwo" and not RREADY then
		qtwo()
	end
	end
	


function OnTick()
Checks()
if ts.target then
	if Config.ultimate.ultCount then
		castR()
		--test_castR()
	end
	if Config.Basic.efarm then
		efarm()
	end
	if Config.Basic.doCombo and not target.dead then
		comboone()
	end
	if Config.ultimate.autoult then
		autoult()
	end
	if Config.Basic.doCombo2 and not target.dead then
		combotwo()
	end
	if Config.Basic.harass then
		harass()
	end
    if jumpReady == true then
        JumpReady()
    end
    if Config.Basic.wardjump then
        JumpCheck()
    end
end
end



function OnProcessSpell(unit, spell)
    if not Config.ultimate.antigapcloser then return end
    local jarvanAddition = unit.charName == "JarvanIV" and unit:CanUseSpell(_Q) ~= READY and _R or _Q -- Did not want to break the table below.
    local isAGapcloserUnit = {
--        ['Ahri']        = {true, spell = _R, range = 450,   projSpeed = 2200},
--        ['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
        ['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, }, -- Targeted ability
        ['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, }, -- Targeted ability
        ['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, }, -- Targeted ability
        ['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
--        ['Graves']      = {true, spell = _E,                  range = 425,   projSpeed = 2000, exeption = true },
        ['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
--        ['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, }, -- Targeted ability
        ['JarvanIV']    = {true, spell = jarvanAddition,      range = 770,   projSpeed = 2000, }, -- Skillshot/Targeted ability
--        ['Jax']         = {true, spell = _Q,                  range = 700,   projSpeed = 2000, }, -- Targeted ability
--        ['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, }, -- Targeted ability
        ['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
        ['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
--        ['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
        ['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
        ['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500 + unit.ms},
        ['Maokai']      = {true, spell = _Q,                  range = 600,   projSpeed = 1200, }, -- Targeted ability
--        ['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, }, -- Targeted ability
--        ['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, }, -- Targeted ability
--        ['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, }, -- Targeted ability
        --['Quinn']       = {true, spell = _E,                  range = 725,   projSpeed = 2000, }, -- Targeted ability
--        ['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
        ['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
--        ['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
        ['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
--        ['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
--       ['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, }, -- Targeted ability
    }
    if unit.type == 'obj_AI_Hero' and unit.team == TEAM_ENEMY and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then
        if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) then
            if spell.target ~= nil and spell.target.name == myHero.name or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
--                print('Gapcloser: ',unit.charName, ' Target: ', (spell.target ~= nil and spell.target.name or 'NONE'), " ", spell.name, " ", spell.projectileID)
        CastSpell(_R, unit)
            else
                spellExpired = false
                informationTable = {
                    spellSource = unit,
                    spellCastedTick = GetTickCount(),
                    spellStartPos = Point(spell.startPos.x, spell.startPos.z),
                    spellEndPos = Point(spell.endPos.x, spell.endPos.z),
                    spellRange = isAGapcloserUnit[unit.charName].range,
                    spellSpeed = isAGapcloserUnit[unit.charName].projSpeed,
                    spellIsAnExpetion = isAGapcloserUnit[unit.charName].exeption or false,
                }
            end
        end
    end
    end
function harass()
	castQ2()
	for k, ally in pairs(GetAllyHeroes()) do
		if GetDistance(ally) < wrange and myHero:GetSpellData(_Q).name == "blindmonkqtwo" and myHero:CanUseSpell(_W) == READY then
			qtwo()
			CastSpell(_W, ally)
		end
	end
    for k = 1, objManager.maxObjects do
		local minionObjectI = objManager:GetObject(k)
        if minionObjectI ~= nil and string.find(minionObjectI.name,"Minion_") == 1 and  minionObjectI.team == player.team and minionObjectI.dead == false and myHero:GetDistance(minionObjectI) < 700 and myHero:GetSpellData(_Q).name == "blindmonkqtwo" and myHero:CanUseSpell(_W) == READY then
            qtwo()
			CastSpell(_W, minionObjectI)
        end
    end
       
end