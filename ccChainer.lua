_G.Update = true
local UPDATE_SCRIPT_NAME = "cc Chainer"
local UPDATE_HOST = "bitbucket.org"
local UPDATE_BitBucket_USER = "BoLSilent"
local UPDATE_BitBucket_FOLDER = "Scripts"
local UPDATE_BitBucket_FILE = "cc Chainer.lua"
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
local champTable = {
        ["Aatrox"] = {
                [_Q] = { speed = 1000, delay = .3, range = 650, width = 100, minionCollisionWidth = 0, skillshot = true },
                [_E] = { speed = 1000, delay = .3, range = 1000, width = 1, minionCollisionWidth = 0, skillshot = true }
        },
       
        ["Amumu"] = {
                [_R] = { speed = 1000, delay = .5, range = 550, width = 100, minionCollisionWidth = 0, skillshot = false }
        },
       ["Anivia"] = {
                [_Q] = { speed = 1595, delay = .625, range = 950, width = 90, minionCollisionWidth = 0, skillshot = true }
        },
        ["Ashe"] = {
                [_R] = { speed = 1595, delay = 0.265, range = 3500, width = 100, minionCollisionWidth = 0, skillshot = true},
        },
        ["ChoGath"] = {
                [_Q] = { speed = 1595, delay = .625, range = 950, width = 10, minionCollisionWidth = 0, skillshot = true},
                [_W] = { speed = 1000, delay = .3, range = 700, width = 200, minionCollisionWidth = 0, skillshot = true}
								},
		["Cassiopeia"] = {
                [_W] = { speed = 1000, delay = .535, range = 850, width = 75, minionCollisionWidth = 0, skillshot = false }
        },
		["Blitzcrank"] = {
				[_Q] = { speed = 1800, delay = 0.250, range = 1050, minionCollisionWidth =  90, skillshot = true}
		},
        ["Draven"] = {
                [_E] = { speed = 1000, delay = .3, range = 1050, width = 10, minionCollisiionWidth = 0, skillshot = true}
        },
		["Caitlyn"] = {
                [_W] = { speed = 2000, delay = .250, range = 1000, width = 80, minionCollisionWidth = 0, skillshot = false }
        },
		["Elise"] = {
			[_E] = { speed = 1450, delay = 0.250, range = 975, minionCollisionWidth = 80, skillshot = true}
		},
        ["Fiddlesticks"] = {
                [_Q] = { speed = 2000, delay = .3, range = 575, width = 0, minionCollisionWidth = 0, skillshot = false},
                [_E] = { speed = 2000, delay = .3, range = 750, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Jinx"] = {
                [_E] = { speed = 1000, delay = .7, range = 900, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Karma"] = {
                [_W] = { speed = 1000, delay = .3, range = 650, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Karthus"] = {
                [_W] = { speed = 1000, delay = .3, range = 1000, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Kassadin"] = {
                [_Q] = { speed = 1000, delay = .3, range = 650, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
		["KhaZix"] = {
                [_W] = { speed = 1000, delay = .2, range = 700, width = 0, minionCollisionWidth = 80, skillshot = true}
        },
        ["Kayle"] = {
                [_Q] = { speed = 1000, delay = .3, range = 650, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Leona"] = {
                [_E] = { speed = 1000, delay = .5, range = 700, width = 0, minionCollisionWidth = 0, skillshot = true},
                [_R] = { speed = 1000, delay = .635, range = 1200, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Lissandra"] = {
                [_W] = { speed = 1000, delay = .3, range = 450, width = 0, minionCollisionWidth = 0, skillshot = false},
                [_R] = { speed = 1000, delay = .5, range = 550, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Lulu"] = {
                [_W] = { speed = 1000, delay = .3, range = 650, width = 0, minionCollisionWidth = 0, skillshot = false},
				[_Q] = { speed = 1000, delay = .3, range = 850, width = 80, minionCollisionWidth = 0, skillshot = true}
        },
		["Lux"] = {
        [_Q] = { speed = 1200, delay = 0.245, range = 1300, minionCollisionWidth = 50, skillshot = true},
        [_E] = { speed = 1400, delay = 0.245, range = 1100, minionCollisionWidth = 0, skillshot = true},
        [_R] = { speed = math.huge, delay = 0.245, range = 3500, minionCollisionWidth = 0, skillshot = true}
		},
        ["Malphite"] = {
                [_R] = { speed = 1000, delay = .3, range = 1000, width = 0, minionCollisionWidth = 0, skillshot = true },
								[_Q] = { speed = 1000, delay = .1, range = 550, width = 0, minionCollisionWidth = 0, skillshot = false }
        },
        ["Malzahar"] = {
                [_Q] = { speed = 1000, delay = .5, range = 900, width = 0, minionCollisionWidth = 0, skillshot = true },
                [_R] = { speed = 1000, delay = .3, range = 700, width = 0, minionCollisionWidth = 0, skillshot = false }
        },
        ["Maokai"] = {
                [_W] = { speed = 1000, delay = .3, range = 650, width = 0, minionCollisionWidth = 0, skillshot = false},
                [_Q] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
		["Morgana"] = {
				[_Q] = { speed = 1200, delay = 0.250, range = 1300, minionCollisionWidth = 80, skillshot = true}
		},
		["DrMundo"] = {
				[_Q] = { speed = 2000, delay = 0.250, range = 1050, minionCollisionWidth = 80, skillshot = true}
		},
        ["Nami"] = {
                [_Q] = { speed = 1000, delay = .3, range = 875, width = 0, minionCollisionWidth = 0, skillshot = true},
                [_R] = { speed = 1000, delay = .5, range = 2750, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Nasus"] = {
                [_W] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Nautilus"] = {
				[_Q] = { speed = 2000, delay = 0.250, range = 1080, minionCollisionWidth = 100, skillshot = true},
                [_E] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = false},
                [_R] = { speed = 1000, delay = .5, range = 825, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Nocturne"] = {
                [_E] = { speed = 1000, delay = .3, range = 425, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Nunu"] = {
                [_E] = { speed = 1000, delay = .3, range = 550, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Olaf"] = {
                [_Q] = { speed = 1000, delay = .625, range = 1000, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Pantheon"] = {
                [_W] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Rammus"] = {
                [_E] = { speed = 1000, delay = .3, range = 325, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Riven"] = {
                [_W] = { speed = 1000, delay = .3, range = 125, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Ryze"] = {
                [_W] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Sejuani"] = {
                [_R] = { speed = 1000, delay = .5, range = 1175, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Shaco"] = {
                [_E] = { speed = 1000, delay = .3, range = 625, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Shen"] = {
                [_E] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Singed"] = {
                [_W] = { speed = 1000, delay = .3, range = 1000, width = 0, minionCollisionWidth = 0, skillshot = true},
                [_E] = { speed = 1000, delay = .1, range = 125, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Sion"] = {
                [_Q] = { speed = 1000, delay = .3, range = 550, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Skarner"] = {
                [_E] = { speed = 1000, delay = .3, range = 1000, width = 0, minionCollisionWidth = 0, skillshot = true},
                [_R] = { speed = 1000, delay = .3, range = 350, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Sona"] = {
                [_R] = { speed = 1000, delay = .5, range = 1000, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Soraka"] = {
                [_E] = { speed = 1000, delay = .3, range = 725, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Swain"] = {
                [_Q] = { speed = 1000, delay = .3, range = 625, width = 0, minionCollisionWidth = 0, skillshot = false},
                [_W] = { speed = 1000, delay = .625, range = 900, width = 0, minionCollisionWidth = 0, skillhot = true}
        },
        ["Taric"] = {
                [_E] = { speed = 1000, delay = .5, range = 625, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Thresh"] = {
                [_E] = { speed = 1000, delay = .3, range = 400, width = 100, minionCollisionWidth = 0, skillshot = true},
				[_Q] = { speed = 1000, delay = .250, range = 1050, width = 80, minionCollisionWidth = 80, skillshot = true}
        },
        ["Trundle"] = {
                [_W] = { speed = 1000, delay = .3, range = 900, width = 0, minionCollisionWidth = 0, skillshot = false},
                [_E] = { speed = 1000, delay = .3, range = 1000, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Varus"] = {
                [_E] = { speed = 1000, delay = .3, range = 925, width = 0, minionCollisionWidth = 0, skillshot = true},
                [_R] = { speed = 1000, delay = .3, range = 1075, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Viktor"] = {
                [_W] = { speed = 1000, delay = .5, range = 625, width = 0, minionCollisionWidth = 0, skillshot = true},
                [_R] = { speed = 1000, delay = .3, range = 700, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
        ["Warwick"] = {
                [_R] = { speed = 1000, delay = .3, range = 700, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["MonkeyKing"] = {
                [_R] = { speed = 1000, delay = .3, range = 162.5, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["XinZhao"] = {
                [_E] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Yorick"] = {
                [_W] = { speed = 1000, delay = .3, range = 600, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
		["Urgot"] = {
                [_R] = { speed = 2000, delay = 1, range = 700, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
        ["Zilean"] = {
                [_E] = { speed = 1000, delay = .3, range = 700, width = 0, minionCollisionWidth = 0, skillshot = false}
        },
		["Ziggs"] = {
                [_E] = { speed = 1000, delay = .3, range = 700, width = 300, minionCollisionWidth = 0, skillshot = true},
				[_W] = { speed = 1000, delay = .3, range = 700, width = 300, minionCollisionWidth = 0, skillshot = true}
        },
        ["Zyra"] = {
                [_E] = { speed = 1000, delay = .5, range = 1100, width = 0, minionCollisionWidth = 0, skillshot = true},
                [_R] = { speed = 1000, delay = .3, range = 700, width = 0, minionCollisionWidth = 0, skillshot = true}
        },
}

if champTable[myHero.charName] == nil then return end
require "VPrediction"
local VP = nil
local access



 
function OnLoad()
	if champTable[myHero.charName] == nil then return end
	access = champTable[myHero.charName]
	VP = VPrediction()
	CrowdControlConfig = scriptConfig("Crowd Controller", "Crowd Controller V0.1")
	CrowdControlConfig:addParam("useUlts", "Use Ultimates to CC", SCRIPT_PARAM_ONOFF, true)
	CrowdControlConfig:addParam("useCC", "Always try to CC", SCRIPT_PARAM_ONOFF, true)
	CrowdControlConfig:addParam("usecollision", "Use Collision Skills", SCRIPT_PARAM_ONOFF, true)
	CrowdControlConfig:addParam("usemec", "Use MEC", SCRIPT_PARAM_ONOFF, true)
	CrowdControlConfig:addParam("mec",  "AutoMEC", SCRIPT_PARAM_LIST, 1, { "No", ">0 hit", ">1 hit", ">2 hit", ">3 hit", ">4 hit" })
	PrintChat("CC Chainer Loaded")
end 


function usemec()
local Mintargets = CrowdControlConfig.mec - 1
		for index, target in pairs(GetEnemyHeroes()) do
			for i = 0, 3 do
				if not access[i] then goto continue end
				AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, access[i].delay, access[i].width, access[i].range, access[i].speed, myHero)
				if nTargets >= Mintargets and GetDistance(CastPosition) < access[i].range then
					if i == 3 and not CrowdControlConfig.useUlts then return end -- ult opt, return because _R == 3 (end of loop)
					if access[i].skillshot then
						CastSpell(i, AOECastPosition.x, AOECastPosition.z)
					else
						CastSpell(i, target)
					end
				end
				::continue::
			end
		end
	end

function OnCollision()
if CrowdControlConfig.useCC then
		for index, target in pairs(GetEnemyHeroes()) do
			for i = 0, 3 do
				if not access[i] then goto continue end
				if access[i].minionCollisionWidth > 1 then return end
				CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, access[i].delay, access[i].width, access[i].range, access[i].speed, myHero, true)
				if HitChance >= 4 and GetDistance(CastPosition) < access[i].range then
					if i == 3 and not CrowdControlConfig.useUlts then return end -- ult opt, return because _R == 3 (end of loop)
					if access[i].skillshot then
						CastSpell(i, CastPosition.x, CastPosition.z)
					else
						CastSpell(i, target)
					end
				end
				::continue::
			end
		end
	end
end



function OnTick()
	if CrowdControlConfig.useCC then
		NoCollision()
	end
	if CrowdControlConfig.useCC and CrowdControlConfig.usecollision then
		OnCollision()
	end
	if CrowdControlConfig.useCC and CrowdControlConfig.usemec then
		usemec()
end
end
function NoCollision()
		for index, target in pairs(GetEnemyHeroes()) do
			for i = 0, 3 do
				if not access[i] then goto continue end
				CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, access[i].delay, access[i].width, access[i].range, access[i].speed, myHero)
				if HitChance >= 4 and GetDistance(CastPosition) < access[i].range then
					if i == 3 and not CrowdControlConfig.useUlts then return end -- ult opt, return because _R == 3 (end of loop)
					if access[i].skillshot then
						CastSpell(i, CastPosition.x, CastPosition.z)
					else
						CastSpell(i, target)
					end
				end
				::continue::
			end
		end
	end


function OnDraw()
	for i = 0, 3 do
		if access[i] then DrawCircle(myHero.x,myHero.y,myHero.z, access[i].range, ARGB(255,255,0,0)) end
	end
end