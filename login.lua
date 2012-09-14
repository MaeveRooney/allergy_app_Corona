--
-- Project: NativeKeyboard2
--
-- Date: November 30, 2010
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

local ui = require("ui")

local tHeight       -- forward reference

-------------------------------------------
-- General event handler for fields
-------------------------------------------

-- You could also assign different handlers for each textfield

local function fieldHandler( event )

    if ( "began" == event.phase ) then
        -- This is the "keyboard has appeared" event
        -- In some cases you may want to adjust the interface when the keyboard appears.
    
    elseif ( "ended" == event.phase ) then
        -- This event is called when the user stops editing a field: for example, when they touch a different field
    
    elseif ( "submitted" == event.phase ) then
        -- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
        
        -- Hide keyboard
        native.setKeyboardFocus( nil )
    end

end

local listener = function( event )
    -- Hide keyboard
    print("tap pressed")
    native.setKeyboardFocus( nil )
end


-- Predefine local objects for use later
local emailField, passwordField, emailLabel, passwordLabel, bkgd
local fields = display.newGroup()

-------------------------------------------
-- *** Buttons Presses ***
-------------------------------------------

-- Default Button Pressed
local loginButtonPress = function( event )
    storyboard.gotoScene( "home" )
end


-------------------------------------------
-- *** Create native input textfields ***
-------------------------------------------

-- Note: currently this feature works in device builds or Xcode simulator builds only

local inputFontSize = 18
local inputFontHeight = 30
tHeight = 30

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    -------------------------------------------
    -- *** Add field labels ***
    -------------------------------------------

    emailLabel = display.newText( "Email", 200, 195, native.systemFont, 18 )
    emailLabel:setTextColor( 120, 255, 245, 255 )
    group:insert(emailLabel)

    passwordLabel = display.newText( "Password", 200, 235, native.systemFont, 18 )
    passwordLabel:setTextColor( 255, 235, 170, 255 )
    group:insert(passwordLabel)

    -------------------------------------------
    -- *** Create Buttons ***
    -------------------------------------------

    -- "Remove Default" Button
    loginButton = ui.newButton{
        default = "assets/buttonBlue.png",
        over = "assets/buttonBlueOver.png",
        onRelease = loginButtonPress,
        text = "Login",
        emboss = true
    }
    group:insert(loginButton)


    -- Position the buttons on screen
    local s = display.getCurrentStage()

    loginButton.x = s.contentWidth/2; loginButton.y = 300
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view

    emailField = native.newTextField( 10, 190, 180, tHeight, fieldHandler )
    emailField.font = native.newFont( native.systemFontBold, inputFontSize )
    emailField.inputType = "email"
    fields:insert(emailField)

    passwordField = native.newTextField( 10, 230, 180, tHeight, fieldHandler )
    passwordField.font = native.newFont( native.systemFontBold, inputFontSize )
    passwordField.isSecure = true
    fields:insert(passwordField)


    -------------------------------------------
    -- Create a Background touch event
    -------------------------------------------

    bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
    bkgd:setFillColor( 0, 0, 0, 0 )     -- set Alpha = 0 so it doesn't cover up our buttons/fields
    local isSimulator = "simulator" == system.getInfo("environment")
    if system.getInfo( "platformName" ) == "Mac OS X" then isSimulator = false; end

    -- Native Text Fields not supported on Simulator
    --
    if isSimulator then
        msg = display.newText( "Native Text Fields not supported on Simulator!", 0, 280, "Verdana-Bold", 12 )
        msg.x = display.contentWidth/2      -- center title
        msg:setTextColor( 255,255,0 )
    end

    -- Add listener to background for user "tap"
    bkgd:addEventListener( "tap", listener )
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    
    bkgd:removeEventListener("tap", listener)
    emailField:removeSelf()
    passwordField:removeSelf()
    -----------------------------------------------------------------------------
    
    --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
    
    -----------------------------------------------------------------------------
    
    storyboard.removeScene( "account" )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    -----------------------------------------------------------------------------
    
    --  INSERT code here (e.g. remove listeners, widgets, save state, etc.)
    
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

---------------------------------------------------------------------------------

return scene
