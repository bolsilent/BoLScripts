if myHero.charName ~= "Karma" then return end


require "UPL"

local qrange = 925
local wrange = 675
local erange = 800
local enemyChamps, allyChamps = GetEnemyHeroes(), GetAllyHeroes()
local enemyCount
local allyCount

function OnLoad()
  enemyCount = #enemyChamps
    allyCount = #allyChamps
UPL = UPL()
UPL:AddSpell(_Q, { speed = 1700, delay = .250, range = qrange, width = 90, collision = true, aoe = false, type = "linear" })


	
Config = scriptConfig("sKarma", "SilentKarma")
Config:addSubMenu("Main Settings", "Basic")
Config.Basic:addParam("doCombo", "Q W combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
Config.Basic:addParam("useult", "Use Ultimate in combo", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
Config.Basic:addParam("usew", "Use W normally", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("useW2", "Use W only if root possible", SCRIPT_PARAM_ONOFF, false)
Config.Basic:addParam("safeadc", "Only use W on enemy with most AD--SOON", SCRIPT_PARAM_ONOFF, false)
Config.Basic:addParam("safeattack", "W if enemy in safe range", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("saferange", "Safe Range:",4,250,150,675,2)



Config:addSubMenu("Draw Settings", "Draw")
Config.Draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("draww", "Draw W", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("drawe", "Draw E", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("drawr", "Draw R", SCRIPT_PARAM_ONOFF, true)

Config:addSubMenu("Orbwalker Settings", "Orbwalking")
DelayAction(CheckOrbwalk, 8)

UPL:AddToMenu(Config)
Config:addParam("hc", "Accuracy:", SCRIPT_PARAM_SLICE, 2,0,3,1)

	ts = TargetSelector(TARGET_LOW_HP, 925, DAMAGE_MAGIC, true)
  Config:addTS(ts)
  


end



function useW2()
for i = 1, enemyCount do
    local enemy = enemyChamps[i]
        if ValidTarget(enemy, Config.Basic.saferange) then
            if GetDistance(enemy, myHero) < 426 then
				CastSpell(_W, enemy)
			end
		end
	end
end

function saferange()
	for i = 1, enemyCount do
    local enemy = enemyChamps[i]
        if ValidTarget(enemy, Config.Basic.saferange) then
            if Config.Basic.saferange < 676 and GetDistance(enemy, myHero) < Config.Basic.saferange then
				CastSpell(_W, enemy)
			end
		end
	end
end


    
function OnDraw()
	Checks()
	if QREADY then
		DrawCircle(myHero.x, myHero.y, myHero.z, qrange, 0x19A712)
		else DrawCircle(myHero.x, myHero.y, myHero.z, qrange, 0x992D3D)
	end
	
	if WREADY then 
		DrawCircle(myHero.x, myHero.y, myHero.z, wrange, 0x19A712)
		
		else DrawCircle(myHero.x, myHero.y, myHero.z, wrange, 0x992D3D)
	end
	
	if EREADY then
		DrawCircle(myHero.x, myHero.y, myHero.z, erange, 0x19A712)
		else DrawCircle(myHero.x, myHero.y, myHero.z, erange, 0x992D3D)
	end
end

function OnTick()
Checks()
	if Config.Basic.safeattack then
		saferange()
	end
	if Config.Basic.harass and Config.Basic.useult and ValidTarget(enemy, qrange) then
		CastR()
		CastQ()
	end
	if Config.Basic.harass and not Config.Basic.useult then
		CastQ()
	end
	if Config.Basic.doCombo then
		if Config.Basic.useW2 then
			useW2()
		end
		if not Config.Basic.useW2 then
			CastW()
		end
		if not Config.Basic.useult then
			CastQ()
		end
		if Config.Basic.useult then
			CastR()
			CastQ()
		end

	end
end

function CastQ()
	if not QREADY then return end
    for i = 1, enemyCount do
        local enemy = enemyChamps[i]
        if ValidTarget(enemy, qrange) then
		CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, enemy)
			if HitChance >= Config.hc then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
        end
    end
end

function CastW()
	if not WREADY then return end
	if Config.Basic.usew then
		for i = 1, enemyCount do
			local enemy = enemyChamps[i]
			if ValidTarget(enemy, 675) then
				CastSpell(_W, enemy)
			end			
		end
	end
end

function CastR()
	if RREADY then 
		CastSpell(_R)
	end
end



function Checks()
if myHero.dead then return end
    QREADY = (myHero:CanUseSpell(_Q) == READY)
    WREADY = (myHero:CanUseSpell(_W) == READY)
    EREADY = (myHero:CanUseSpell(_E) == READY)
    RREADY = (myHero:CanUseSpell(_R) == READY)
ts:update()
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
