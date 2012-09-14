----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require "widget"
local ui = require("ui")

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

local w,h = display.contentWidth, display.contentHeight - 10 

local function goToAccount(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "account", options)
end

local function goToSearch(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "search", options)
end

local function goToReview(event)
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "review", options)
end
    
-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    print('creating home')

    local background = display.newRect(0, 0, w, h)
    background:setFillColor(255, 255, 255)
    group:insert(background)
 
    buttons = {}
    labels = {}
    
    square1 = display.newRect( 0, 0, 3*(w/4), 50 )
    square1:setStrokeColor(150,150,150)
    square1:setFillColor( 50,50,50 )
    myAccount = display.newText("My Allergy",0,0,nil,20)
    myAccount:setTextColor(255,255,255)
    
    square2 = display.newRect( 0, 0, 3*(w/4), 50 )
    square2:setStrokeColor(150,150,150)
    square2:setFillColor( 50,50,50 )
    searchRestaurants = display.newText("Search Eaterys",0,0,nil,20)
    searchRestaurants:setTextColor(255,255,255)

    square3 = display.newRect( 0, 0, 3*(w/4), 50 )
    square3:setStrokeColor(150,150,150)
    square3:setFillColor( 50,50,50 )
    reviewRestaurants = display.newText("Review Eaterys",0,0,nil,20)
    reviewRestaurants:setTextColor(255,255,255)
    
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

    print("entering home")

    
    -- create a tab-bar and place it at the bottom of the screen
    storyboard.state.demoTabs = widget.newTabBar{
        top=display.contentHeight -50,
        buttons=storyboard.state.tabButtons
    }

    storyboard.state.navBar.x = w*.5


    storyboard.state.navHeader.text = "Home"
    
    square1:addEventListener("tap",goToAccount)
    square2:addEventListener("tap",goToSearch)
    square3:addEventListener("tap",goToReview)
    -----------------------------------------------------------------------------
        
    --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    print('exiting home')
    storyboard.state.previousScene = "home"

    storyboard.state.backBtn.x = 50

    square1:removeEventListener("tap",goToAccount)
    square2:removeEventListener("tap",goToSearch)
    square3:removeEventListener("tap",goToReview)

    storyboard.removeScene( "home" )

    -----------------------------------------------------------------------------
    
    --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
    
    -----------------------------------------------------------------------------
    
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    print('destroying home')
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
