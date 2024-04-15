addEventHandler("onClientRender", getRootElement(), 
function ()
for k,v in ipairs(getElementsByType("player")) do
		if getPlayerTeam(v) == getTeamFromName("HassoN") then
			if v == localPlayer then return end
			dxDrawTextOnElement(v,"HassoN",1,20,0,0,255,255,1,"arial")
		end
	end
end)
