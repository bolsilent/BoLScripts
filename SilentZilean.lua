

require "UPL"
UPL = UPL()

if myHero.charName ~= "Zilean" then return end



local enemyChamps, allyChamps = GetEnemyHeroes(), GetAllyHeroes()
local enemyCount
local allyCount


function OnLoad()

 enemyCount = #enemyChamps
    allyCount = #allyChamps
    
	
	skillQ =
    {
	
        range = 900,
				delay = .5,
				radius = 150,
				speed = math.huge,
        dmg = function() return (20 + (GetSpellData(0).level*55) + (myHero.ap*0.90)) end
				
    }
	
	skillW =
    {
        range =  1200
    }
	
	skillE =
    {
        range = 550
    
    }
	
	skillR =
    {
        range = 900
     
    }
	
	UPL:AddSpell(_Q, { speed = skillQ.speed, delay = skillQ.delay, range = skillQ.range, width = skillQ.radius, collision = false, aoe = true, type = "circular" })
	

	Config = scriptConfig("Silent Zil", "workdammit")
	Config:addSubMenu("Basic Settings", "Basic")

	Config.Basic:addParam("supportmode", "supportmode", SCRIPT_PARAM_ONOFF, false)
	Config.Basic:addParam("harass", "harass", SCRIPT_PARAM_ONOFF, true, 67)

	Config.Basic:addParam("combo","combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		UPL:AddToMenu(Config)
	Config:addParam("hc", "Accuracy:", SCRIPT_PARAM_SLICE, 2,0,3,1)
	Config:addSubMenu("Orbwalker Settings", "Orbwalking")
	
		Config:addSubMenu("Ult", "Ult")

	Config.Ult:addParam("autoUlt", "autoUlt", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Draw", "Draw")
	Config.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)


			ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, skillW.range, DAMAGE_MAGIC, true)
		Config:addTS(ts)



	
	for i = 1, allyCount do
    local ally = allyChamps[i]
	Config.Ult:addParam(ally.charName, ally.charName, SCRIPT_PARAM_ONOFF, true)
	end
	

DelayAction(CheckOrbwalk, 8)
	end
	
function Qcast()
    if not QREADY then return end
        for i = 1, enemyCount do
            local enemy = enemyChamps[i]
            if ValidTarget(enemy, skillQ.range) then
			CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, enemy)
				if HitChance >= Config.hc then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
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

function Wcast()
if not EREADY then return end
CastSpell(_W)
end


function Ecast()
if not EREADY then return end
	for i = 1, allyCount do
    local ally = allyChamps[i]
	if GetDistance(ally) < ERange then
					CastSpell(_E, ally)
				end
				end
end

function Ecast2()
if not EREADY then return end
        for i = 1, enemyCount do
            local enemy = enemyChamps[i]
            if ValidTarget(enemy, skillE.range) then
				CastSpell(_E, enemy)
            end
        end

end


function Checks()
QREADY = ((myHero:CanUseSpell(_Q) == READY) or (myHero:GetSpellData(_Q).level > 0 and myHero:GetSpellData(_Q).currentCd <= 0.4)) WREADY = ((myHero:CanUseSpell(_W) == READY) or (myHero:GetSpellData(_W).level > 0 and myHero:GetSpellData(_W).currentCd <= 0.4))
EREADY = ((myHero:CanUseSpell(_E) == READY) or (myHero:GetSpellData(_E).level > 0 and myHero:GetSpellData(_E).currentCd <= 0.4))
RREADY = ((myHero:CanUseSpell(_R) == READY) or (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd <= 0.4))
IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
  

end


function CountEnemies(range, unit)
    local Enemies = 0
	for i = 1, enemyCount do
    local Enemy = enemyChamps[i]
        if ValidTarget(Enemy) and GetDistance(Enemy, unit) < (range or math.huge) then
            Enemies = Enemies + 1
        end
    end
    return Enemies
end

function autoUlt()
	if not myHero:CanUseSpell(_R) == READY then return end
	local ultTarget
	if myHero.health / myHero.maxHealth < 0.4 and CountEnemies(700, myHero) > 0 then
		ultTarget = myHero
	end
	for i = 1, allyCount do
    local ally = allyChamps[i]
		if Config.Ult[ally.charName] and ally.health / ally.maxHealth < 0.4 and GetDistance(ally) <= skillR.range and CountEnemies(700, ally) > 0 then
			if not ultTarget or ultTarget.health > ally.health then
				ultTarget = ally
			end
		end
	end
	if ultTarget then CastSpell(_R, ultTarget) end
end

function OnDraw()
	if myHero.dead then return end
	if QREADY and Config.Draw.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0x80408000) end
	if EREADY and Config.Draw.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, 550, 0x80408000) end
	if RREADY and Config.Draw.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0x80408000) end
	end
	
function supportmode(target)
Checks()
Qcast()
Ecast()
	end


function OnTick()
Checks()

			if Config.Basic.combo then 
				combo() 
			end
			if Config.Basic.harass then
				harass()
			end
			if Config.Ult.autoUlt then
				autoUlt()
			end
			if Config.Basic.supportmode then
				supportmode()
			end

end
		

function combo()
Checks()
Ecast2()
Qcast()
if WREADY and (myHero:CanUseSpell(_Q) == COOLDOWN) then CastSpell(_W) end
Qcast()
	end


		
function harass()
Checks()
Qcast()
end
