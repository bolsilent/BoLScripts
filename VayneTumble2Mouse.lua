
function OnLoad()
Config = scriptConfig("Simple Vayne","vayne")
Config:addSubMenu("Basic Settings", "Basic")
Config.Basic:addParam("tumble", "tumble", SCRIPT_PARAM_ONKEYDOWN, false, 32)
end

function tumble()
	CastSpell(_Q, mousePos.x, mousePos.z)
end

function OnTick()
	if Config.Basic.tumble then
		tumble()
	end
end
