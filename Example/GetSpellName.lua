j = 0
function OnWndMsg(msg,key)
if key == 32 and msg == KEY_DOWN then
j=j+1
CastSpell(_Q)
print(" "..myHero:GetSpellData(_Q).name)
end
end