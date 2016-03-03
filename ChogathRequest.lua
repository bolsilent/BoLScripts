_G.Update = true
local UPDATE_SCRIPT_NAME = "Chogath"
local UPDATE_HOST = "bitbucket.org"
local UPDATE_BitBucket_USER = "BoLSilent"
local UPDATE_BitBucket_FOLDER = "Scripts"
local UPDATE_BitBucket_FILE = "Chogath.lua"
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



require "UPL"
UPL = UPL()

if myHero.charName ~= "Chogath" then return end

local enemyChamps, allyChamps = GetEnemyHeroes(), GetAllyHeroes()
local enemyCount
local allyCount


function OnLoad()
     enemyCount = #enemyChamps
    allyCount = #allyChamps
 
	skillQ =
    {
	
        range = 950,
		delay = .75,
		radius = 100,
		speed = math.huge
				
    }
	
	skillW =
    {
        range =  650,
		delay = .5,
		radius = 275,
		speed = math.huge
    }
	
	skillE =
    {
        range = 500
    
    }
	
	skillR =
    {
        range = 175
     
    }
	

UPL:AddSpell(_Q, { speed = skillQ.speed, delay = skillQ.delay, range = skillQ.range, width = skillQ.radius, collision = false, aoe = true, type = "circular" })
UPL:AddSpell(_W, { speed = skillW.speed, delay = skillW.delay, range = skillW.range, width = skillW.radius, collision = false, aoe = true, type = "linear" })


Config = scriptConfig("ChoGath","vk")
Config:addSubMenu("Basic Settings", "Basic")
Config:addSubMenu("Draw Settings", "Draw")
Config:addSubMenu("Orbwalker Settings", "Orbwalking")

UPL:AddToMenu(Config)
Config:addParam("hc", "Accuracy:", SCRIPT_PARAM_SLICE, 2,0,3,1)



--> Basic Settings
Config.Basic:addParam("doCombo", "Q W combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
Config.Basic:addParam("useq", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
Config.Basic:addParam("usew", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)

Config.Basic:addParam("autoult", "Use Ult to kill", SCRIPT_PARAM_ONOFF, true)



--> Draw Settings
Config.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
Config.Draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, skillQ.range, DAMAGE_MAGIC, true)
Config:addTS(ts)


player = GetMyHero()
PrintChat(" >> Silent ChoGath v3 Loaded")
DelayAction(CheckOrbwalk, 8)
--ignite = ((myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") and SUMMONER_1) or (myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") and SUMMONER_2) or nil)
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



function Checks()
QREADY = ((myHero:CanUseSpell(_Q) == READY) or (myHero:GetSpellData(_Q).level > 0 and myHero:GetSpellData(_Q).currentCd <= 0.4)) WREADY = ((myHero:CanUseSpell(_W) == READY) or (myHero:GetSpellData(_W).level > 0 and myHero:GetSpellData(_W).currentCd <= 0.4))
EREADY = ((myHero:CanUseSpell(_E) == READY) or (myHero:GetSpellData(_E).level > 0 and myHero:GetSpellData(_E).currentCd <= 0.4))
RREADY = ((myHero:CanUseSpell(_R) == READY) or (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd <= 0.4))
IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)


end

function OnTick()
Checks()
	if Config.Basic.doCombo then
		if Config.Basic.useq then
			Qcast()
		end
		if Config.Basic.usew then
			Wcast()
		end
	end
	if Config.Basic.autoult then
		Ult()
	end

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

function Wcast()
    if not WREADY then return end
        for i = 1, enemyCount do
            local enemy = enemyChamps[i]
            if ValidTarget(enemy, skillW.range) then
			CastPosition, HitChance, HeroPosition = UPL:Predict(_W, myHero, enemy)
				if HitChance >= Config.hc then
					CastSpell(_W, CastPosition.x, CastPosition.z)
				end
            end
        end
end

function Ult()
     local rDmg = 0
for i = 1, enemyCount do
            local enemy = enemyChamps[i]		 
	if ValidTarget(enemy, skillR.range) and Config.Basic.autoult then
		if RREADY then
			    rDmg = getDmg("R", enemy, myHero)
                                if enemy.health <= rDmg then
                                        CastSpell(_R, enemy)
																end
		end
		end
	end
end

function OnDraw()
	if Config.Draw.drawQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, skillQ.range, 0xFFFF0000)
	end
	if Config.Draw.drawW then
		DrawCircle(myHero.x, myHero.y, myHero.z, skillW.range, 0xFFFF0000)
	end
	if Config.Draw.drawR then
		DrawCircle(myHero.x, myHero.y, myHero.z, skillR.range, 0xFFFF0000)
	end
	end
	
