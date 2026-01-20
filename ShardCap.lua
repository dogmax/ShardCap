SHARDCAP_CAP_VALUE=5;
SHARDCAP_SPAM=false; 

function delShards(number) -- Debugging
	i=1; 
	for bag = 4,0,-1 do 
		for slot = 1, GetContainerNumSlots(bag), 1 do 
			if shardTest(bag, slot) then
				--DEFAULT_CHAT_FRAME:AddMessage("found a shard");
				if i > number then
					if SHARDCAP_SPAM == true then
						DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Deleting "..GetContainerItemLink(bag, slot).." #"..i.." from bag: "..bag.." slot: "..slot);
					end 
					PickupContainerItem(bag,slot); 
					DeleteCursorItem();
				end 
				i=i+1;
			end 	
		end; 
	end; 
end;

function shardTest(b, s)
	-- Soul Shards have itemID = 6265
	local shardID = 6265;
	
	-- GetContainerItemLink returns a long string, where the item's ID is part of the string. 
	-- Returns "nil" if empty bag slot, which we don't like, since we save it to local itemLink 
	-- So we have to handle that
	local itemLink
	
	if GetContainerItemLink(b,s) == nil then
		itemLink = 'noitem'
	else
		itemLink = GetContainerItemLink(b,s)
	end 
		
	-- Test if a given item is a shard with LUA's string.find(x,y) function.
	if string.find(itemLink, shardID) then
		--DEFAULT_CHAT_FRAME:AddMessage("------> Is shard: " .. itemLink .. "<------")
		return true
	else
		--DEFAULT_CHAT_FRAME:AddMessage("Not shard: " .. itemLink)
		return false
	end
end

-- Events to listen for:
local f = CreateFrame'Frame'
f:RegisterEvent'BAG_UPDATE'
f:RegisterEvent'PLAYER_REGEN_ENABLED'

-- Check if something is in the bags and check if player exited combat.
local combat, bag = nil, nil
f:SetScript('OnEvent', function()
	-- DEFAULT_CHAT_FRAME:AddMessage("registered")
	if event == "BAG_UPDATE" then
		bag = true
	elseif event == "PLAYER_REGEN_ENABLED" then
		combat = true
	end

	if bag and combat then
		bag, combat = nil, nil
		delShards(SHARDCAP_CAP_VALUE);
	end
end)

function ShardCap_IsInteger(n)
	-- Returns true if n is an integer.
	if tonumber(n) ~= math.floor(tonumber(n)) then
		return false
	else
		return true
	end
end

function ShardCap_PrintCap()
	-- Correct spelling of shard/shards in case the user sets the cap to 1.
	-- xD smiley face.
	str = "ShardCap - Current cap is "..SHARDCAP_CAP_VALUE.." shard";
	if SHARDCAP_CAP_VALUE ~= 1 then 
		str = str.."s"
	end 
	DEFAULT_CHAT_FRAME:AddMessage(str..".");
end

function ShardCap_PrintInfo()
	DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Change cap: /shardcap <number> ... For example: /shardcap 5");
	DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Show cap: /shardcap");
	DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Notifications: /shardcap spam");
	DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Manual delete: /shardcap delete");
	DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Deletes when you exit combat. Deletes from backpack first. Put your soulbag in your last bag slot, like a normal person. Cheers.");
	DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Website: www.github.com/dogmax/ShardCap");
end

function ShardCap_ToggleSpam()
	local msg ="ShardCap - Notifications ";

	if SHARDCAP_SPAM == true then 
		SHARDCAP_SPAM = false; 
		msg = msg.."disabled."; 
	else 
		SHARDCAP_SPAM = true; 
		msg = msg.."enabled.";
	end 
	DEFAULT_CHAT_FRAME:AddMessage(msg.." To change it: /shardcap spam");
end

function ShardCap(parameter) 
	if parameter == '' then
		ShardCap_PrintCap();
		DEFAULT_CHAT_FRAME:AddMessage("ShardCap - Change cap: /shardcap <number> ... For example: /shardcap 5");
		DEFAULT_CHAT_FRAME:AddMessage("ShardCap - More information type: /shardcap info");
	end

	if parameter == "info" then
		DEFAULT_CHAT_FRAME:AddMessage("--- --- --- --- --- ---");
		ShardCap_PrintInfo();
	end
	
	-- toggle spam 
	if parameter == "spam" then
		ShardCap_ToggleSpam();
	end 
	
	-- check if parameter is a number (this if clause seems weird, but it's not)
	if type(tonumber(parameter)) == "number" then
		-- If parameter is a number, check for integer
		if ShardCap_IsInteger(parameter) then
			-- If it IS an integer, we set the new value for SHARDCAP_CAP_VALUE..., account for negative numbers. 
			SHARDCAP_CAP_VALUE = math.abs(parameter); 
			ShardCap_PrintCap();
		else 
			-- If it is NOT and integer, we tell them to type /shardcap info for more information or something... 
			DEFAULT_CHAT_FRAME:AddMessage("ShardCap - You must use an integer for example 1 or 5 or 28.");
		end 
	end
	
	if parameter == "delete" then
		delShards(SHARDCAP_CAP_VALUE)
	end
end

SLASH_SHARDCAP1 = '/shardcap'
SlashCmdList["SHARDCAP"] = ShardCap
