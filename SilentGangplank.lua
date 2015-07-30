

if myHero.charName ~= "Gangplank" then return end

require "AoE_Skillshot_Position"
local ts
local ImTeleporting
myHero = GetMyHero()


function OnLoad()

	Config = scriptConfig("Moneyplank", "Money")
	
	Config:addSubMenu("Parrrley Settings" , "comboConfig")
	Config.comboConfig:addParam("autoQE", "Auto Q Enemy", SCRIPT_PARAM_ONOFF, true)
	Config.comboConfig:addParam("autoQM", "Auto Q Minion", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Heal Settings" , "healSettings")
	Config.healSettings:addParam("autoHealP", "Heal under %", 4,0.7,0,1,2)
	Config.healSettings:addParam("autoHealS", "Auto Heal on Stun", SCRIPT_PARAM_ONOFF, true)
	
	--Config.esettings:addParam("enumber", "Auto E #", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
	
	Config:addSubMenu("Ultimate Settings", "ultsettings")
	Config.ultsettings:addParam("UltKS", "Ult to Killsteal", SCRIPT_PARAM_ONOFF, true)
	Config.ultsettings:addParam("ultnumber", "Use Mec Ult", SCRIPT_PARAM_LIST, 1, { "None", ">0 hit", ">1 hit", ">2 hit", ">3 hit", ">4 hit" })
	
    Config:addSubMenu("Draw Circles", "drawcircle")
	Config.drawcircle:addParam("qrange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, math.huge, DAMAGE_PHYSICAL)
	enemyMinions = minionManager(MINION_ENEMY, 625, MyHero, MINION_SORT_HEALTH_ASC)
	Config:addTS(ts)
	
	
	PrintChat("MoneyPlank v3: Changed auto ult, fixed auto ult ks, fixed heal, added q chase")
end 

function Checks()
QREADY = ((myHero:CanUseSpell(_Q) == READY) or (myHero:GetSpellData(_Q).level > 0 and myHero:GetSpellData(_Q).currentCd <= 0.4)) WREADY = ((myHero:CanUseSpell(_W) == READY) or (myHero:GetSpellData(_W).level > 0 and myHero:GetSpellData(_W).currentCd <= 0.4))
EREADY = ((myHero:CanUseSpell(_E) == READY) or (myHero:GetSpellData(_E).level > 0 and myHero:GetSpellData(_E).currentCd <= 0.4))
RREADY = ((myHero:CanUseSpell(_R) == READY) or (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd <= 0.4))
ts:update()
end
function OnDraw()
Checks()
	if Config.drawcircle.qrange and QREADY then
		DrawCircle(myHero.x, myHero.y, myHero.z, 625, 0xFFFF0000)
	end
	
end

function OnTick()
Checks()
QHarass()
QFarm()

ultcount()
ultKS()
autoheal()
autoheals()
end

--[[function CountEnemyHeroInRange(range)
local enemyInRange = 0
	for i = 1, heroManager.iCount, 1 do
	local enemyheros = heroManager:getHero(i)
		if enemyheros.valid and enemyheros.visible and enemyheros.dead == false and enemyheros.team ~= myHero.team and GetDistance(enemyheros) <= range then
			enemyInRange = enemyInRange + 1
		end
	end
 return enemyInRange
end]]--

function CountAllyHeroInRange(range)
local allyInRange = 0
 for i = 1, heroManager.iCount, 1 do
                local ally = heroManager:getHero(i)
                                if GetDistance(ally) <= 1300 then
                                        allyInRange = allyInRange + 1
                                end
 end
 return allyInRange
end

function QHarass()
	
	Checks()
		if Config.comboConfig.autoQE then
		if ValidTarget(ts.target, 700) then
			if QREADY then
				CastSpell(_Q, ts.target)
			end
		end
	end
	end


function QFarm()
	enemyMinions:update()
	if Config.comboConfig.autoQM then
		for index, minion in pairs(enemyMinions.objects) do
			if GetDistance(minion, myHero) <= 625 then
				if (myHero:CanUseSpell(_Q) == READY) then
				local qDmg = getDmg("Q",minion, myHero) + getDmg("AD",minion, myHero)
					if qDmg>minion.health then
						CastSpell(_Q, minion)
					end
				end
			end
		end
	end
end

	
function autoE()
	if Config.esettings.AutoE then
		for k, ally in pairs(GetAllyHeroes()) do
				if GetDistance(ally) <= 1250 then
            CastSpell(_E)
		end
	end
end
end
function CountEnemyHeroInRange(range)
local enemyInRange = 0
	for i = 1, heroManager.iCount, 1 do
	local enemyheros = heroManager:getHero(i)
		if enemyheros.valid and enemyheros.team ~= myHero.team and GetDistance(enemyheros) <= 9999999999 then
			enemyInRange = enemyInRange + 1
		end
	end
 return enemyInRange
end

function ultcount()
ts:update()
	if RREADY and CountEnemyHeroInRange(ultPos) > Config.ultsettings.ultnumber and ts.target then
		local ultPos = GetAoESpellPosition(600, ts.target)
		--if CountEnemyHeroInRange(ultPos) > Config.ultsettings.ultnumber then
		--if ultPos and GetDistance(ultPos) <= math.huge then
				CastSpell(_R, ultPos.x, ultPos.z)
				PrintChat("Casting Ultimate in best possible position")
			--end
			--elseif GetDistance(ts.target) <= math.huge then
			--CastSpell(_R, ts.target.x, ts.target.z)
			--end
		end
	end



function ultKS()
if Config.ultsettings.UltKS then
                local rDmg = 0    
                for i = 1, heroManager.iCount, 1 do
                        local enemyhero = heroManager:getHero(i)
                        if ValidTarget(enemyhero, math.huge) then
                                rDmg = getDmg("R", enemyhero, myHero)
                                if enemyhero.health <= rDmg*5.5 then
                                        CastSpell(_R, enemyhero.x, enemyhero.z)
                                end
                        end
                end
        end
	end




function autoheals()
	if Config.healSettings.autoHealS then
			if (myHero.canMove == false) and ImTeleporting == false then
				CastSpell(_W)
			end
	end
end



function autoheal()
	if WREADY and myHero.health/myHero.maxHealth <= Config.healSettings.autoHealP then
		CastSpell(_W)
	end
end	


function OnGainBuff(unit,buff)
	if unit.isMe and buff.name == "summonerteleport" then  
		ImTeleporting = true 
	end 
end 

function OnLoseBuff(unit,buff)
	if unit.isMe and buff.name == "summonerteleport" then  
		ImTeleporting = false 
	end 
end
