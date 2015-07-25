_G.Update = true
local UPDATE_SCRIPT_NAME = "SilentKennen"
local UPDATE_HOST = "bitbucket.org"
local UPDATE_BitBucket_USER = "BoLSilent"
local UPDATE_BitBucket_FOLDER = "Scripts"
local UPDATE_BitBucket_FILE = "SilentKennen.lua"
local UPDATE_PATH = "/"..UPDATE_BitBucket_USER.."/"..UPDATE_BitBucket_FOLDER.."/raw/master/"..UPDATE_BitBucket_FILE
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local ServerData
if _G.Update then
	GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
	function update()
		if ServerData ~= nil then
			local ServerVersion
			local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
			if sstart then
				send, tmp = string.find(ServerData, "\"", sstart+1)
			end
			if send then
				ServerVersion = tonumber(string.sub(ServerData, sstart+1, send-1))
			end

			if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
				DownloadFile(UPDATE_URL.."?nocache"..myHero.charName..os.clock(), UPDATE_FILE_PATH, function () print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. ("..version.." => "..ServerVersion..")</font>") end)     
			elseif ServerVersion then
				print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
			end		
			ServerData = nil
		end
	end
	AddTickCallback(update)
end

if myHero.charName ~= "Kennen" then return end




require "VPrediction"
require "SOW"
local qrange, wrange, rrange = 1050, 800, 550
local qrat, wrat, erat, rrat, rratsingle = 0.75, 0.55, 0.6, 0.4, 1.2 -- AP Ratio
local myChamp = GetMyHero()
local Kennen = GetMyHero()
local MOS1Time, MOS2Time = 0, 0
local enemyhaveMOS1, enemyhaveMOS2 = false, false
local turrets
local range = 801

function OnLoad()
    
    VP = VPrediction()
    Config = scriptConfig("Kennen ","vk")
    Config:addSubMenu("Basic Settings", "Basic")
    Config:addSubMenu("Ultimate Settings", "Ultimate")
    Config:addSubMenu("Drawing Settings", "Draw")
	Config:addSubMenu("Orbwalker", "orbwalker")
    Config.Basic:addParam("doCombo", "Q W combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Config.Basic:addParam("escape", "Escape" , SCRIPT_PARAM_ONKEYDOWN, false, 71)
	Config.Basic:addParam("harass", "Auto Q", SCRIPT_PARAM_ONOFF, true)
    Config.Basic:addParam("autow", "AutoW MOTS", SCRIPT_PARAM_ONOFF, true)
    Config.Ultimate:addParam("Ultcount", "Enemys B4 Using R", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
    Config.Ultimate:addParam("Ultrange", "auto Ultimate Range", SCRIPT_PARAM_SLICE, 450, 0, 550, 0)

    -- Draw Menu
    Config.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawStun", "Draw Stun", SCRIPT_PARAM_ONOFF, true) -- Check if enemy got 2 stacks of the debuff and you got the autoattack rdy for stun or spell
    Config.Draw:addParam("killable", "Draw Killable", SCRIPT_PARAM_ONOFF, true)
    PrintChat(" >> Kennen the Stupid Rat v3: Addeed SOW for orbwalking")
	turrets = GetTurrets()
    for name, tower in pairs(turrets) do
        if tower.object then      
    end
	end
	VP = VPrediction(true)
	SOW = SOW(VP)
	SOW:LoadToMenu(Config.orbwalker)
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, range, DAMAGE_MAGIC, true)
	Config:addTS(ts)

end

function OnTick()
	if Config.Basic.doCombo then
		combo()
	end
	if Config.Basic.escape then
		escape()
	end
	if Config.Ultimate.Ultcount then
		AutoUlt()
	end
	if Config.Basic.autow then
		enemytower()
	end	
	if Config.Basic.harass then
		q()
	end
end

function enemytower()
    for name, tower in pairs(turrets) do
	for i, enemy in ipairs(GetEnemyHeroes()) do
        if tower.object ~= nil then
            if tower.object.team == TEAM_ENEMY and GetDistance(tower.object) <= range and enemy~= nil and enemy.visible and ValidTarget(enemy) then
				if IsMarked(enemy) then
					CastSpell(_W)
				end
			end
		end
	end
	end
end

function q()
    for i, target in pairs(GetEnemyHeroes()) do
        local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.2, 75, qrange, 1200, myHero, true)
        if HitChance >= 2 and GetDistance(CastPosition) < qrange and target.visible and ValidTarget(target) and not target.dead then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
    end
end
	
function combo()
useq()
enemytower()
CastEMoveBehindEnemy()
useq()
autow()
useq()
end

--[[function offensivee()
for i, target in pairs(GetEnemyHeroes()) do
            local Position, HitChance    = VPrediction:GetPredictedPos(target, 0.1, 0.1, myHero, false)
            if HitChance >= 0 and GetDistance(Position) < 500 and CountEnemyHeroInRange(900) then
                CastSpell(_E, Position.x, Position.z)
				--Kennen:MoveTo(Position.x, Position.z)
			end
end
end]]--

function useq()
    for i, target in pairs(GetEnemyHeroes()) do
        local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.2, 75, qrange, 1250, myHero, true)
        if HitChance >= 2 and GetDistance(CastPosition) < qrange and target.visible and ValidTarget(target) and not target.dead then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
    end
end

function autow()
for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy~= nil and enemy.visible and ValidTarget(enemy) then
			if IsMarked(enemy) then
				CastSpell(_W)
			end
		end
	end
end

function CastEMoveBehindEnemy(unit)
if not ValidTarget(unit) then return end
local DistanceToUnit = GetDistance(unit)
local NewSpeed = myHero.ms + 210
local moveToPos = myHero + (Vector(unit) - myHero):normalized() * DistanceToUnit + 50
if (DistanceToUnit / NewSpeed) < 1.8 then--we can reach the enemy
	CastSpell(_E)
	Kennen:MoveTo(moveToPos.x, moveToPos.z)
end
end

function SkillReady(skill)
        if myChamp:CanUseSpell(skill) == READY then
                return true
        else
                return false
        end
        
end

function escape()
    if SkillReady(_E) and Config.Basic.escape and myHero:GetSpellData(_E).name == "KennenLightningRush" then
        CastSpell(_E)
				Kennen:MoveTo(mousePos.x,mousePos.z)
    end
end


function AutoUlt()
        if Config.Ultimate.Ultcount then
                if SkillReady(_R) and CountEnemyHeroInRange(Config.Ultimate.Ultrange) >= Config.Ultimate.Ultcount then
                        CastSpell(_R)
                end
        end
end

--blocks R if no enemys are in range
function OnSendPacket(p)
 if SkillReady(_R) and p.header == Packet.headers.S_CAST
  then
   local packet = Packet(p)
   if packet:get('spellId') == _R then
    local hitnumber, hit = CheckHitEnemys()
    if hitnumber == 0 then p:Block() end
   end
 end
end
-- Check how many enemys get hit by R --
function CheckHitEnemys()
 local enemieshit = {}
 for i, enemy in ipairs(GetEnemyHeroes()) do
  local position = VP:GetPredictedPos(enemy, 0.1, 0.1)
  if ValidTarget(enemy) and GetDistance(enemy, position) <= 550 and GetDistance(enemy, myHero) <= rrange-10 then
   table.insert(enemieshit, enemy)
  end
 end
 return #enemieshit, enemieshit
end

function isFacing(source, target, lineLength)
local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
local sourcePos = Vector(source.x, source.z)
sourceVector = (sourceVector-sourcePos):normalized()
sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
end

function drawmark()
	for i = 1, heroManager.iCount, 1 do
		local hero = heroManager:getHero(i)
		if hero and hero.valid and hero.team == TEAM_ENEMY and IsMarked(hero) then PrintFloatText(hero, 0, "Stun") end
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

function IsMarked(unit)
if unit == nil or not ValidTarget(unit) then return end
        for i = 1, unit.buffCount, 1 do
                local tBuff = unit:getBuff(i)
                if BuffIsValid(tBuff) then
                        if tBuff.name == "kennenmarkofstorm" then
                                return true
                        end
                end
        end
  return false
end



function OnDraw()
    if SkillReady(_Q) and Config.Draw.drawQ then
        DrawCircle(myHero.x, myHero.y, myHero.z, qrange, 0x3Cff000F)
    end
    
    if SkillReady(_W) and Config.Draw.drawW then
        DrawCircle(myHero.x, myHero.y, myHero.z, wrange, 0x3cff000F)
    end
    
    if SkillReady(_R) and Config.Draw.drawR then
        DrawCircle(myHero.x, myHero.y, myHero.z, rrange, 0x3cff000F)
    end
    if Config.Draw.drawStun then
		drawmark()
	end
end