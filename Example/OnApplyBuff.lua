local onHowlingGale = false 


function OnTick()
 if myHero.charName == "Janna" then
 if onHowlingGale == true then CastSpell(_Q)
 end
 end
 end
 


								function OnGainBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
                PrintChat("GAINED: " .. buff.name)
if buff.name == "HowlingGale" then
                        PrintChat("TRUE")
                        onHowlingGale = true
                end 
end
end

function OnLoseBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
                --PrintChat("LOST: " .. buff.name)
                if buff.name == "HowlingGale" then
                        onHowlingGale = false
                end
        end
end 