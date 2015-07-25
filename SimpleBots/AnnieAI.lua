local LevelSequence = {_W,_Q,_W,_E,_Q,_R,_W,_E,_Q,_E,_R,_E,_E,_W,_Q,_R,_Q,_W} -- order to level abilities
local AnnieLevel = 0
local Recall = false
local qrange, wrange, rrange, tibbersTargetRange = 625, 625, 600, 2000
local shopList = {1052, 3108, 1001, 1058, 3158, 3028, 3128, 3222, 1011, 3067, 3116, 1028, 3105, 3190, 3108, 3023, 3028, 3110}
local nextbuyIndex = 1
local wardBought = 0
local firstBought = false
local lastBuy = 0
local buyDelay = 100

function doStealFarm()
	-- Get Cannon Minion
	cannonMinionSteal:update()
	local targetCannonMinion = nil
	for _, minion in pairs(cannonMinionSteal.objects) do
		if minion.dead == false and (minion.charName == "Blue_Minion_MechCannon" or minion.charName == "Red_Minion_MechCannon") then
			targetCannonMinion = minion
		end
	end
	-- If minion found
	if targetCannonMinion ~= nil then
		-- Check if infuse will do enough damage to steal it
		local qDamage = getDmg("Q", targetCannonMinion, player)	
		-- If target is stealable and in range, Q it
		if targetCannonMinion.health < qDamage and player:GetDistance(targetCannonMinion) < qrange then
			CastSpell(_Q, targetCannonMinion)
		end
	end
	end
	
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
if player.level > AnnieLevel then
		LevelSpell(LevelSequence[player.level])
		AnnieLevel = player.level
	end
	if Config.PrepStun then
		prepstun()
	end
	if Config.Harass then
		harass()
	end
	if Config.Ultimate then
		tibbers()
	end
	if Config.BigMinions then
		doStealFarm()
	end
end

function tibbers()
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
				
		if exsistTibbers then
		attackWithTibbers()
	end
end

		
function OnLoad()
    if GetInventorySlotIsEmpty(ITEM_1) == false then
		firstBought = true
	end
	startingTime = GetTickCount()
	
    player = GetMyHero()
	-- Config Menu
	Config = scriptConfig("Annie Slack", "Annie slack")	

	Config:addParam("PrepStun", "Prepare Stun", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("Harass", "Harass enemys", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("Ultimate", "Ultimate enemies", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("BigMinions", "Steal Big Farms", SCRIPT_PARAM_ONOFF, true)
cannonMinionSteal = minionManager(MINION_ENEMY, qrange, player, MINION_SORT_MAXHEALTH_DEC)
	end

	
	

	function harass()
	for i=1, heroManager.iCount do -- Scan all champions in the game
		local enemy = heroManager:getHero(i) -- Assign a local variable for the champions.
		if enemy ~= nil then
		UseItems(enemy)
        if ValidTarget(enemy, qrange) then
			CastSpell(_Q, enemy)
		end
		if ValidTarget(enemy, 575) then
			CastSpell(_W, enemy.x, enemy.z)
		end
	end
end
end

function attackWithTibbers()
        if existTibbers and tibbersTarget ~= nil then
                CastSpell(_R, tibbersTarget)
        end
end

function prepstun()
	if InFountain() and not stunReady then
		CastSpell(_W, myHero.x, myHero.z)
		CastSpell(_E)
	end
	if not stunReady and not Recall then
		CastSpell(_E)
	end
end


	
	function OnCreateObj(object)
        if object.name == "StunReady.troy" then
                stunReady = true
        end
        if object.name == "BearFire_foot.troy" then
                existTibbers = true
        end
				if object.name == "TeleportHome.troy" then
				if GetDistance(object, myHero) <= 70 then
				Recall = true
				end
		end
	end
 
function OnDeleteObj(object)
        if object.name == "StunReady.troy" then
                stunReady = false
        end
        if object.name == "BearFire_foot.troy" then
                existTibbers = false
        end
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