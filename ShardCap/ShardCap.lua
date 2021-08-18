shardcap=5;

function delShards(number) -- Debugging
	i=1; 
	for bag = 0,4,1 do 
		for slot = 1, GetContainerNumSlots(bag), 1 do 
			local name = GetContainerItemLink(bag,slot); 
			if name and string.find(name,"Soul Shard") then 
				if i > number then 
					DEFAULT_CHAT_FRAME:AddMessage("Deleting "..name.." "..i); 	
					PickupContainerItem(bag,slot); 
					DeleteCursorItem(); 
				end; 
				i=i+1; 
			end; 
		end; 
	end; 
end;

local f = CreateFrame'Frame'
f:RegisterEvent'BAG_UPDATE'

f:SetScript('OnEvent', function()
	-- DEFAULT_CHAT_FRAME:AddMessage("BAG_UPDATE registered")
	delShards(shardcap);
end)
