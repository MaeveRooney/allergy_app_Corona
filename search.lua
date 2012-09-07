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
    
local button1, button2, button4, searchValue, searchTasty, backHome

local w,h = display.contentWidth, display.contentHeight

local function changeScene2(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "Rating", options)
end

local function changeScene3(event)
    local options = {}
    storyboard.gotoScene( "Yummy", options)
end

local function changeScene4(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "Value", options)
end

local function changeScene5(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "home", options)
end
    
-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
            
    h,w = display.contentHeight, display.contentWidth   
    
    buttons = {}
    labels = {}
    
    button1 = display.newRect( 0, 0, 3*(w/4), 50 )
    searchRating = display.newText("Search by Overall Rating",0,0,nil,15)
    
    button2 = display.newRect( 0, 0, 3*(w/4), 50 )
    searchTasty = display.newText("Search by Yumminess",0,0,nil,15)
    
    button3 = display.newRect( 0, 0, 3*(w/4), 50 )
    searchValue = display.newText("Search by Value",0,0,nil,15)

    button4 = display.newRect( 0, 0, 3*(w/4), 50 )
    backHome = display.newText("Home Page",0,0,nil,20)
    
    buttons[1] = button1
    buttons[2] = button2
    buttons[3] = button3
    buttons[4] = button4
    
    for i=1,#buttons do
        buttons[i].x = (w/2)
        buttons[i].y = i*(h/5)
        buttons[i].strokeWidth = 3
        buttons[i]:setStrokeColor(150,150,150)
        buttons[i]:setFillColor( 50,50,50 )
        group:insert(buttons[i])
    end
    
    labels[1] = searchRating
    labels[2] = searchTasty
    labels[3] = searchValue
    labels[4] = backHome
    
    for i=1,#labels do
        labels[i].x = (w/2)
        labels[i].y = i*(h/5)
        labels[i]:setTextColor(250,250,250)
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
    
    button1:addEventListener("tap",changeScene2)
    button2:addEventListener("tap",changeScene3)
    button3:addEventListener("tap",changeScene4)
    button4:addEventListener("tap",changeScene5)
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
    button4:removeEventListener("tap",changeScene5)
    -----------------------------------------------------------------------------
    
    --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
    
    -----------------------------------------------------------------------------
    
end


function scene:didExitScene( event )
    storyboard.purgeScene( "search" )
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


scene:addEventListener( "didExitScene", scene)
---------------------------------------------------------------------------------

return scene
