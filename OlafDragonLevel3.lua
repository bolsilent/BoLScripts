_G.Update = true
local UPDATE_SCRIPT_NAME = "OlafDragon"
local UPDATE_HOST = "bitbucket.org"
local UPDATE_BitBucket_USER = "BoLSilent"
local UPDATE_BitBucket_FOLDER = "Scripts"
local UPDATE_BitBucket_FILE = "OlafDragon.lua"
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


if myHero.charName ~= "Olaf" then return end
local hpid = 2003
local hpslot


function OnLoad()

	-- Config Menu
	Config = scriptConfig("OlafKiller", "BuyMePizza")	
	Config:addParam("HotKeyDown", "Dragon Time", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("P"))
	PrintChat(">> Olaf Dragon Killer by Silent Man -- Current version uses all pots")
end

function OnTick()
	if Config.HotKeyDown then
		DragonTime()
		HPCheck()
	end
	end

function DragonTime()
for i=1, objManager.maxObjects, 1 do
local object = objManager:getObject(i)
if object ~= nil and object.valid and object.name == "SRU_Dragon6.1.1" and not object.dead and object.visible then
CastSpell(_Q, object.x, object.z)
player:Attack(object)
CastSpell(_W)
end
end
end

--[[add check for hp pots]]--

function HPCheck()
	hpslot = GetInventorySlotItem(hpid)
	if hpslot then
		if myHero.health/myHero.maxHealth < 0.25 then
			CastSpell(hpslot)
		end
	end
end
