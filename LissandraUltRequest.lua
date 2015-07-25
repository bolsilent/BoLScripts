--[[Silent Man was here ]]-- 

if myHero.charName ~= "Lissandra" then return end

function OnLoad()
    Config = scriptConfig("Liss Ultr", "lult")    
    Config:addParam("healthperc","% of Health before Ulting",4,0.7,0,1,2)
end

function OnTick()
if (myHero:CanUseSpell(_R) == READY) and myHero.health/myHero.maxHealth <= Config.healthperc then
CastSpell(_R, myHero)
end
end
