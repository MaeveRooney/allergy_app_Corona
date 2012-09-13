----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
--
--  NOTE:
--
--  Code outside of listener functions (below) will only be executed once,
--  unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local button1, button2, button4, searchValue, searchTasty

local w,h = display.contentWidth, display.contentHeight - 10

local function changeScene2(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "rating", options)
end

local function changeScene3(event)
    storyboard.gotoScene( "yummy" )
end

local function changeScene4(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "value", options)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    local background = display.newRect(0, 0, w, h)
    background:setFillColor(255, 255, 255)
    group:insert(background)

    buttons = {}
    labels = {}

    button1 = display.newRect( 0, 0, 3*(w/4), 50 )
    searchRating = display.newText("Search by Overall Rating",0,0,nil,18)

    button2 = display.newRect( 0, 0, 3*(w/4), 50 )
    searchTasty = display.newText("Search by Yumminess",0,0,nil,18)

    button3 = display.newRect( 0, 0, 3*(w/4), 50 )
    searchValue = display.newText("Search by Value",0,0,nil,18)

    buttons[1] = button1
    buttons[2] = button2
    buttons[3] = button3

    for i=1,#buttons do
        buttons[i].x = (w/2)
        buttons[i].y = i*(h/4)
        buttons[i].strokeWidth = 3
        buttons[i]:setStrokeColor(150,150,150)
        buttons[i]:setFillColor( 50,50,50 )
        group:insert(buttons[i])
    end

    labels[1] = searchRating
    labels[2] = searchTasty
    labels[3] = searchValue

    for i=1,#labels do
        labels[i].x = (w/2)
        labels[i].y = i*(h/4)
        labels[i]:setTextColor(255,255,255)
        group:insert(labels[i])
    end



-----------------------------------------------------------------------------

    --  CREATE display objects and add them to 'group' here.
    --  Example use-case: Restore 'group' from previously saved state.

    -----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view

    storyboard.state.navHeader.text = "Search Eateries"

    storyboard.state.backBtn.alpha = 1
    
    button1:addEventListener("tap",changeScene2)
    button2:addEventListener("tap",changeScene3)
    button3:addEventListener("tap",changeScene4)
    -----------------------------------------------------------------------------

    --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)

    -----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    button1:removeEventListener("tap",changeScene2)
    button2:removeEventListener("tap",changeScene3)
    button3:removeEventListener("tap",changeScene4)

    storyboard.purgeScene( "search" )
    storyboard.state.previousScene = "search"

    -----------------------------------------------------------------------------

    --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

    -----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
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


---------------------------------------------------------------------------------

return scene
