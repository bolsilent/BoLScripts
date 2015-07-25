if myHero.charName ~= "Soraka" then return end
local qrange = 520
local erange = 725
local aarange = 550
local QREADY, EREADY = false, false
local ts = TargetSelector(TARGET_LOW_HP_PRIORITY,550,DAMAGE_MAGIC)
function OnLoad()
  sorakaConfig = scriptConfig("Soraka Config", "Soraka_Config")
  sorakaConfig:addParam("usee", "autoe", SCRIPT_PARAM_ONOFF, true)
  sorakaConfig:addParam("useq", "autoq", SCRIPT_PARAM_ONOFF, true)
  sorakaConfig:addParam("useaa", "autoaa", SCRIPT_PARAM_ONOFF, false)
  sorakaConfig:addParam("drawcircles", "drawcircles", SCRIPT_PARAM_ONOFF, true)
  if sorakaConfig.useq then sorakaConfig:permaShow("UseSorakaQ") end
  if sorakaConfig.usee then sorakaConfig:permaShow("UseSorakaE") end
  if sorakaConfig.useaa then sorakaConfig:permaShow("useSorakaAA") end
        ts.name = "Soraka"
        sorakaConfig:addTS(ts)
end

function OnDraw()
  if myHero.dead then return end
  if sorakaConfig.drawcircles and not myHero.dead then
    if QREADY then DrawCircle(myHero.x, myHero.y, myHero.z, qrange, 0x19A712)
       else DrawCircle(myHero.x, myHero.y, myHero.z, qrange, 0x992D3D) end
         if EREADY then DrawCircle(myHero.x, myHero.y, myHero.z, erange, 0x19A712)
         else DrawCircle(myHero.x, myHero.y, myHero.z, erange, 0x992D3D) end
       end
     end
 function OnTick()
   ts:update()
           QREADY = (myHero:CanUseSpell(_Q) == READY)
        EREADY = (myHero:CanUseSpell(_E) == READY)
        if sorakaConfig.useq and ts.target then
          if QREADY and GetDistance(ts.target)<510 then CastSpell(_Q) end
        end
        if sorakaConfig.usee and ts.target then
          if EREADY and GetDistance(ts.target)<720 then CastSpell(_E, ts.target) end
        end
        if sorakaConfig.useaa and ts.target then
          if GetDistance(ts.target)<550 then player:Attack(ts.target)
          end
        end
      end
