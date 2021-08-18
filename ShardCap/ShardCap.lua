shardcap=5;

function delShards(number) -- Debugging
	i=1; 
	for bag = 0,4,1 do 
		for slot = 1, GetContainerNumSlots(bag), 1 do 
			local name = GetContainerItemLink(bag,slot); 
			if name and string.find(name,"Soul Shard") then 
				if i > number then 
					DEFAULT_CHAT_FRAME:AddMessage("Deleting "..name..". "..i.."-> "..i-1); 	
					PickupContainerItem(bag,slot); 
					DeleteCursorItem(); 
				end; 
				i=i+1; 
			end; 
		end; 
	end; 
end;

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
		delShards(shardcap);
	end
end)
