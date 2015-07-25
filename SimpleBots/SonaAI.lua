if myHero.charName ~= "Sona" then return end
local LevelSequence = {_Q,_W,_W,_E,_Q,_R,_W,_E,_Q,_E,_R,_E,_E,_W,_Q,_R,_Q,_W} -- order to level abilities
local SonaLevel = 0
local Recall = false
local qrange, wrange, erange, rrange = 700, 1000, 1000, 1000
local shopList = {1006, 3301, 3096, 1001, 1028, 3158, 3067, 3069, 1028, 3105, 3190, 1028, 3010, 3027, 3065}
local nextbuyIndex = 1
local wardBought = 0
local firstBought = false
local lastBuy = 0
local buyDelay = 100

function OnTick()
    if firstBought == false and GetTickCount() - startingTime > 2000 then
		BuyItem(2044) -- stealth ward (green)
		BuyItem(2044)
		BuyItem(1004) -- Faerie Charm
		BuyItem(2004) -- Mana Potion
		BuyItem(2004)
		BuyItem(2004)
		BuyItem(2003) -- Health Potion
		BuyItem(3340) -- warding totem (trinket)
		firstBought = true
	end
	if InFountain() then
		-- Continuous ward purchases
		if GetTickCount() - wardBought > 30000 and GetTickCount() - startingTime > 8000 and GetInventorySlotItem(2044) == nil then
			BuyItem(2044) -- stealth ward (green)
			wardBought = GetTickCount()
		end
		
		-- Item purchases
		if GetTickCount() - startingTime > 5000 then	
			if GetTickCount() > lastBuy + buyDelay then
				if GetInventorySlotItem(shopList[nextbuyIndex]) ~= nil then
					--Last Buy successful
					nextbuyIndex = nextbuyIndex + 1
				else
					--Last Buy unsuccessful (buy again)
					BuyItem(shopList[nextbuyIndex])
					lastBuy = GetTickCount()
				end
			end
		end
	end
local targets = nil
if player.level > SonaLevel then
		LevelSpell(LevelSequence[player.level])
		SonaLevel = player.level
	end
	if Config.PrepPowerChord then
		preppowerchord()
	end
	if Config.Harass then
		harass()
	end
	if Config.Ultimate then
		ultimate()
	end
	if Config.heal then
		CastW()
	end
end

function ultimate()
      for i=1, heroManager.iCount do -- Scan all champions in the game
      local enemy = heroManager:getHero(i) -- Assign a local variable for the champions.
      local damage = getDmg("R", enemy, myHero) -- Calculate the Q damage
        if ValidTarget(enemy, rrange) and damage > enemy.health then -- ValidTarget checks if the target is valid and within the specified range. Next we check if the damage is higher than the enemy's health.
          CastSpell(_R, enemy.x, enemy.z)
					end
				end
			for i=1, heroManager.iCount do -- Scan all champions in the game
      local enemy = heroManager:getHero(i) -- Assign a local variable for the champions.
      local damage = getDmg("R", enemy, myHero) -- Calculate the Q damage
			 if ValidTarget(enemy, rrange) and enemy.health/enemy.maxHealth<=.5 then
			 CastSpell(_R, enemy.x, enemy.z)
			 end
			 end
				

	end
		
function CastW()
local HealAmount = myHero.ap*0.25
	local LowestHealth = nil

	for a = 1, heroManager.iCount do
		Ally = heroManager:GetHero(a)

		if LowestHealth and LowestHealth.valid and Ally and Ally.valid then
			if Ally.health < LowestHealth.health and wrange >= myHero:GetDistance(Ally) and (Ally.health + HealAmount) <= Ally.maxHealth then
				LowestHealth = Ally
			end
		else
			LowestHealth = Ally
		end
		end
	if LowestHealth.health/LowestHealth.maxHealth <= Config.healthperc then
		CastSpell(_W)
	end
end

function OnLoad()
    if GetInventorySlotIsEmpty(ITEM_1) == false then
		firstBought = true
	end
	startingTime = GetTickCount()
	
    player = GetMyHero()
	-- Config Menu
	Config = scriptConfig("Sona Slack", "Sona")	
	Config:addParam("heal", "Heal Allys", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("preppowerchord", "Prepare PowerChord", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("Harass", "Harass enemys", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("Ultimate", "Ultimate enemies", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("healthperc","% of Health before healing",4,0.7,0,1,2)
	end

	
	

function harass()
	for i=1, heroManager.iCount do -- Scan all champions in the game
		local enemy = heroManager:getHero(i) -- Assign a local variable for the champions.
		if enemy ~= nil then
		UseItems(enemy)
        if ValidTarget(enemy, qrange) then
			CastSpell(_Q)
		end
		if ValidTarget(enemy, 750) and powerchord then
			myHero:Attack(enemy)
		end
	end
end
end



function preppowerchord()
	if InFountain() and not powerchord then
		CastSpell(_W)
		CastSpell(_E)
		CastSpell(_Q)
	end
	if not powerchord and not Recall then
		CastSpell(_W)
	end
end

function OnGainBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
        --PrintChat("GAINED: " .. buff.name)
		if buff.name == "sonapowerchord" then
            powerchord = true
        end
		if buff.name == "sonahymnofvalorauraself" then
            valor = true
        end
		if buff.name == "SonaAuraofPerserveranceAuraSelf" then
            perserverance = true
        end
		if buff.name == "sonasongofdiscordauraself" then
            discord = true
        end
end
end

function OnLoseBuff(unit, buff)
        if unit == nil or buff == nil then return end
        if unit.isMe and buff then
                --PrintChat("LOST: " .. buff.name)
                if buff.name == "sonapowerchord" then
                    powerchord = false
                end
				if buff.name == "sonahymnofvalorauraself" then
                    valor = false
                end
				if buff.name == "SonaAuraofPerserveranceAuraSelf" then
                    perserverance = false
                end
				if buff.name == "sonasongofdiscordauraself" then
                    discord = false
                end
        end
end 
	
function OnCreateObj(object)
	if object.name == "TeleportHome.troy" then
		if GetDistance(object, myHero) <= 70 then
			Recall = true
		end
	end
end
 
function OnDeleteObj(object)
	if object.name == "TeleportHome.troy" then
		Recall = false
	end
end

	function Checks()
        BRKSlot, DFGSlot, HXGSlot, BWCSlot, TMTSlot, RAHSlot, RNDSlot, YGBSlot = GetInventorySlotItem(3153), GetInventorySlotItem(3128), GetInventorySlotItem(3146), GetInventorySlotItem(3144), GetInventorySlotItem(3077), GetInventorySlotItem(3074),  GetInventorySlotItem(3143), GetInventorySlotItem(3142)
        QREADY = (myHero:CanUseSpell(_Q) == READY)
        WREADY = (myHero:CanUseSpell(_W) == READY)
        EREADY = (myHero:CanUseSpell(_E) == READY)
        RREADY = (myHero:CanUseSpell(_R) == READY)
        DFGREADY = (DFGSlot ~= nil and myHero:CanUseSpell(DFGSlot) == READY)
        HXGREADY = (HXGSlot ~= nil and myHero:CanUseSpell(HXGSlot) == READY)
        BWCREADY = (BWCSlot ~= nil and myHero:CanUseSpell(BWCSlot) == READY)
        BRKREADY = (BRKSlot ~= nil and myHero:CanUseSpell(BRKSlot) == READY)
        TMTREADY = (TMTSlot ~= nil and myHero:CanUseSpell(TMTSlot) == READY)
        RAHREADY = (RAHSlot ~= nil and myHero:CanUseSpell(RAHSlot) == READY)
        RNDREADY = (RNDSlot ~= nil and myHero:CanUseSpell(RNDSlot) == READY)
        YGBREADY = (YGBSlot ~= nil and myHero:CanUseSpell(YGBSlot) == READY)
        IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
		tibbersTarget = GetBestTarget(tibbersTargetRange)
        ts:update()
        end

function UseItems(target)
        if GetDistance(target) < 550 then
                if DFGREADY then CastSpell(DFGSlot, target) end
                if HXGREADY then CastSpell(HXGSlot, target) end
                if BWCREADY then CastSpell(BWCSlot, target) end
                if BRKREADY then CastSpell(BRKSlot, target) end
                if YGBREADY then CastSpell(YGBSlot, target) end
                if TMTREADY and GetDistance(target) < 275 then CastSpell(TMTSlot) end
                if RAHREADY and GetDistance(target) < 275 then CastSpell(RAHSlot) end
                if RNDREADY and GetDistance(target) < 275 then CastSpell(RNDSlot) end
        end
end