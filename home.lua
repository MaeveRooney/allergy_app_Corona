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
    
local square1, square2, square3, myAccount, searchRestaurants, reviewRestaurants

local w,h = display.contentWidth, display.contentHeight

local function changeScene2(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "scene2", options)
end

local function changeScene3(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "search", options)
end

local function changeScene4(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "scene4", options)
end
    
-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
            
    h,w = display.contentHeight, display.contentWidth   
    
    buttons = {}
    labels = {}
    
    square1 = display.newRect( 0, 0, 3*(w/4), 50 )
    square1:setStrokeColor(0,150,0)
    square1:setFillColor( 0,50,0 )
    myAccount = display.newText("My Allergy",0,0,nil,20)
    myAccount:setTextColor(0,200,0)
    
    square2 = display.newRect( 0, 0, 3*(w/4), 50 )
    square2:setStrokeColor(150,0,0)
    square2:setFillColor( 50,0,0 )
    searchRestaurants = display.newText("Search Eaterys",0,0,nil,20)
    searchRestaurants:setTextColor(200,0,0)

    square3 = display.newRect( 0, 0, 3*(w/4), 50 )
    square3:setStrokeColor(150,150,0)
    square3:setFillColor( 50,50,0 )
    reviewRestaurants = display.newText("Review Eaterys",0,0,nil,20)
    reviewRestaurants:setTextColor(250,250,0)
    
    buttons[1] = square1
    buttons[2] = square2
    buttons[3] = square3
    
    for i=1,#buttons do
        buttons[i].x = (w/2)
        buttons[i].y = i*(h/4)
        buttons[i].strokeWidth = 3
        group:insert(buttons[i])
    end
    
    labels[1] = myAccount
    labels[2] = searchRestaurants
    labels[3] = reviewRestaurants
    
    for i=1,#labels do
        labels[i].x = (w/2)
        labels[i].y = i*(h/4)
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
    
    square1:addEventListener("tap",changeScene2)
    square2:addEventListener("tap",changeScene3)
    square3:addEventListener("tap",changeScene4)
    -----------------------------------------------------------------------------
        
    --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    square1:removeEventListener("tap",changeScene2)
    square2:removeEventListener("tap",changeScene3)
    square3:removeEventListener("tap",changeScene4)
    -----------------------------------------------------------------------------
    
    --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
    
    -----------------------------------------------------------------------------
    
end


function scene:didExitScene( event )
    storyboard.purgeScene( "home" )
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
