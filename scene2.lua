----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local sceneText, dialog
local w,h = display.contentWidth, display.contentHeight

-- Touch event listener for background image
local function changeScene(event)
	local options = {effect = "fade", time = 400 }
	if event.phase == "began" then
		storyboard.gotoScene( "scene1", options)
		return true
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local ask = dialog.CreateDialog("Test Dialog")
	ask.Bool = dialog.AddCheckbox("True Or False", true)
	ask.OK = dialog.AddButton("OK", 1)
	ask.Cancel = dialog.AddButton("Cancel", 0)
	group:insert(ask)
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	Runtime:addEventListener("touch", changeScene)
end


-- Called when scene is about to move offscreen:
function scene:exitScene()
	Runtime:removeEventListener("touch", changeScene)
end

function scene:didExitScene( event )
	storyboard.purgeScene( "scene2" )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

scene:addEventListener( "didExitScene", scene)
---------------------------------------------------------------------------------

return scene