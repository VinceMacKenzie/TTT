local spawnX, spawnY, spawnZ = 5,5,5
function joinHandler()
	spawnPlayer(source, spawnX, spawnY, spawnZ)
	fadeCamera(source, true)
	setCameraTarget(source, source)
end
addEventHandler("onPlayerJoin", getRootElement(), joinHandler)

addEventHandler( "onPlayerWasted", root,
	function()
		setTimer( spawnPlayer, 2000, 1, source, 0, 0, 3 )
	end
)