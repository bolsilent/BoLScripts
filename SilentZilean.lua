--[[ Zilean by tivia ]]--

if myHero.charName ~= "Zilean" then return end


local QRange = 700
local ERange = 700
local RRange = 900
local QREADY, WREADY, EREADY, RREADY = false, false, false, false 



function OnLoad()

	sZileanConfig = scriptConfig("sZilean - Main","sZilean")
	sZileanConfig:addSubMenu("Basic Settings", "Basic")
	sZileanConfigUltimate = scriptConfig("sZilean - Ultimate", "sZileanUlt")
	sZileanConfig:addSubMenu("Draw Settings", "Draw")
	sZileanConfig.Basic:addParam("supportmode", "Support Mode", SCRIPT_PARAM_ONOFF, false)
	sZileanConfig.Basic:addParam("combo","QWQ Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	sZileanConfig.Basic:addParam("harass", "Q Harass", SCRIPT_PARAM_ONOFF, true, 67)
	
	sZileanConfigUltimate:addParam("autoUlt", "Auto Ultimate", SCRIPT_PARAM_ONOFF, true)
	sZileanConfig.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	sZileanConfig.Draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
	sZileanConfig.Draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, RRange, DAMAGE_PHSYCAL, true)
	sZileanConfig:addTS(ts)


	player = GetMyHero()
	PrintChat(" >> Silent Zilean V2 Loaded")


	for _, ally in ipairs(GetAllyHeroes()) do
		sZileanConfigUltimate:addParam(ally.charName, ally.charName, SCRIPT_PARAM_ONOFF, true)
	end

end

function OnTick()
Checks()
	if ts.target then
			if sZileanConfig.Basic.combo then 
				combo() 
			end
			if sZileanConfig.Basic.harass then
				harass()
			end
			if sZileanConfigUltimate.autoUlt then
				autoUlt()
			end
			if sZileanConfig.Basic.supportmode then
				supportmode()
			end
	end
end

function Checks()
QREADY = ((myHero:CanUseSpell(_Q) == READY) or (myHero:GetSpellData(_Q).level > 0 and myHero:GetSpellData(_Q).currentCd <= 0.4)) WREADY = ((myHero:CanUseSpell(_W) == READY) or (myHero:GetSpellData(_W).level > 0 and myHero:GetSpellData(_W).currentCd <= 0.4))
EREADY = ((myHero:CanUseSpell(_E) == READY) or (myHero:GetSpellData(_E).level > 0 and myHero:GetSpellData(_E).currentCd <= 0.4))
RREADY = ((myHero:CanUseSpell(_R) == READY) or (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd <= 0.4))
IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
ts:update()
end

function castq()
	for i = 1, enemyCount do
    local enemy = enemyChamps[i]
        if ValidTarget(enemy, QRange) then
			if QREADY then 
				CastSpell(_Q, enemy.x, enemy.z)
			end
		end
	end
end

function caste()
 for k, ally in pairs(GetAllyHeroes()) do
				if GetDistance(ally) < ERange then
					CastSpell(_E, ally)
				end
	end
end

function caste2()
    for i = 1, enemyCount do
    local enemy = enemyChamps[i]
        if ValidTarget(enemy, ERange) then
			if EREADY then 
				CastSpell(_E, enemy)
			end
		end
	end
end

function supportmode(target)
Checks()
castq()
caste()
	end



		

function combo()
Checks()
caste2()
castq()
if WREADY and (myHero:CanUseSpell(_Q) == COOLDOWN) then CastSpell(_W) end
castq()
	end


		
function harass()
Checks()
castq()
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
	if myHero.health / myHero.maxHealth < 0.4 and CountEnemies(1000, myHero) > 0 then
		ultTarget = myHero
	end
	for _, ally in ipairs(GetAllyHeroes()) do
		if sZileanConfigUltimate[ally.charName] and ally.health / ally.maxHealth < 0.3 and GetDistance(ally) <= RRange and CountEnemies(1000, ally) > 0 then
			if not ultTarget or ultTarget.health > ally.health then
				ultTarget = ally
			end
		end
	end
	if ultTarget then CastSpell(_R, ultTarget) end
end

function OnDraw()
	if myHero.dead then return end
	if QREADY and sZileanConfig.Draw.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0x80408000) end
	if EREADY and sZileanConfig.Draw.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x80408000) end
	if RREADY and sZileanConfig.Draw.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0x80408000) end
	end
	
	