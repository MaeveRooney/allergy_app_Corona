----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--import the table view library
local tableView = require("tableView")

--import the button events library
local ui = require("ui")
local tHeight       -- forward reference




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
--initial values
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight



local sceneText, backBtn, userTable
local w,h = display.contentWidth, display.contentHeight -50

local inputFontSize = 18
local inputFontHeight = 30
tHeight = 30

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
local emailField, nameField, emailLabel, nameLabel, bkgd
local fields = display.newGroup()


--load database
require "sqlite3"

local path = system.pathForFile( "test5.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

userTable = {}  -- starts off emtpy


---------------------------------------------------------------------------------
--CHANGE VALUES FOR ALLERGY BOOLS
---------------------------------------------------------------------------------
function changeAllergyBool(label)
    if label.size == 32 then
        label.size = 31
        label.text = 'Yes'
        label:setTextColor(0, 150, 0)
        return 'Yes'
    else
        label.size = 32
        label.text = 'No'
        label:setTextColor(150,0,0)
        return 'No'
    end
end

function changeGlutenBool(event)
    bool = changeAllergyBool(event.target)
    userTable[1].gluten = bool
    print("Gluten " .. userTable[1].gluten)
end

function changeWheatBool(event)
    bool = changeAllergyBool(event.target)
    userTable[1].wheat = bool
    print("Wheat " .. userTable[1].wheat)
end

function changeDairyBool(event)
    bool = changeAllergyBool(event.target)
    userTable[1].dairy = bool
    print("Dairy " .. userTable[1].dairy)
end


function saveChanges(event)
    print('changing')
    tapText.text = 'Changes Saved'
    local q = [[UPDATE user SET name=']]..nameField.text..[[', email=']] ..emailField.text..[[', wheat=']] ..userTable[1].wheat.. [[', gluten=']] ..userTable[1].gluten.. [[', dairy=']] ..userTable[1].dairy.. [[' ;]]
    db:exec( q )
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    -------------------------------------------
    -- *** Add field labels ***
    -------------------------------------------

    local background = display.newRect(0, 0, w, h)
    background:setFillColor(255, 255, 255)
    group:insert(background)

    nameLabel = display.newText( "Name", 10, 60, native.systemFontBold, 24 )
    nameLabel:setTextColor( 0,0,0 )
    group:insert(nameLabel)

    emailLabel = display.newText( "Email", 10, 130, native.systemFontBold, 24 )
    emailLabel:setTextColor( 0,0,0 )
    group:insert(emailLabel)

    -------------------------------------------
    -- *** Create Buttons ***
    -------------------------------------------

    wheatText = display.newText("    Wheat Allergy:", 0, 0, native.systemFontBold, 16)
    wheatText:setTextColor(0, 0, 0)
    wheatText.y = math.floor(h/2) + 10
    group:insert(wheatText)

    wheatBool = display.newText('', 0, 0, native.systemFontBold, 16)
    wheatBool.x = math.floor(w/2) + 50
    wheatBool.y = math.floor(h/2) + 10
    group:insert(wheatBool)


    glutenText = display.newText("    Gluten Allergy:", 0, 0, native.systemFontBold, 16)
    glutenText:setTextColor(0, 0, 0)
    glutenText.y = math.floor(h/2) + 50
    group:insert(glutenText)

    glutenBool = display.newText("", 0, 0, native.systemFontBold, 16)
    glutenBool.x = math.floor(w/2) + 50
    glutenBool.y = math.floor(h/2) + 50
    group:insert(glutenBool)


    dairyText = display.newText("    Dairy Allery:", 0, 0, native.systemFontBold, 16)
    dairyText:setTextColor(0, 0, 0)
    dairyText.y = math.floor(h/2) + 90
    group:insert(dairyText)

    dairyBool = display.newText('', 0, 0, native.systemFontBold, 16)
    dairyBool.x = math.floor(w/2) + 50
    dairyBool.y = math.floor(h/2) + 90
    group:insert(dairyBool)


    tapText = display.newText("Tap Yes/No to change", 0, 0, native.systemFontBold, 12)
    tapText:setTextColor(90, 90, 90)
    tapText.x = math.floor(w/2)
    tapText.y = math.floor(h/2) + 120
    group:insert(tapText)

    local saveButton = ui.newButton{
    default = "assets/buttonBlue.png",
    over = "assets/buttonBlueOver.png",
    onRelease = saveChanges,
    text = "SaveChanges",
    emboss = true
    }
    group:insert(saveButton)
    saveButton.x = 160
    saveButton.y = math.floor(h/2) + 180


    -----------------------------------------------------------------------------
        
    --  CREATE display objects and add them to 'group' here.
    --  Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group= self.view
    print('entering')

    storyboard.state.navHeader.text = "My Account"

    storyboard.state.backBtn.alpha = 1

    userTable = {}  -- starts off emtpy

    for row in db:nrows("SELECT * FROM user") do
    -- create table at next available array index
    userTable[#userTable+1] =
        {
            name = row.name,
            email = row.email,
            wheat = row.wheat,
            gluten = row.gluten,
            dairy = row.dairy
        }
    end

    glutenBool.text=userTable[1].gluten
    if userTable[1].gluten == "Yes" then
        glutenBool.size = 31
        glutenBool:setTextColor(0, 150, 0)
    else
        glutenBool:setTextColor(150, 0, 0)
    end

    wheatBool.text=userTable[1].wheat
    if userTable[1].wheat == "Yes" then
        wheatBool.size = 31
        wheatBool:setTextColor(0, 150, 0)
    else
        wheatBool:setTextColor(150, 0, 0)
    end

    dairyBool.text=userTable[1].dairy
    if userTable[1].dairy == "Yes" then
        dairyBool.size = 31
        dairyBool:setTextColor(0, 150, 0)
    else
        dairyBool:setTextColor(150, 0, 0)
    end


    nameField = native.newTextField( 10, 90, 300, tHeight, fieldHandler )
    nameField.font = native.newFont( native.systemFont, inputFontSize )
    nameField.text = userTable[1].name
    nameField:setTextColor( 100,100,100 )
    fields:insert(nameField)

    emailField = native.newTextField( 10, 160, 300, tHeight, fieldHandler )
    emailField.font = native.newFont( native.systemFont, inputFontSize )
    emailField.inputType = "email"
    emailField.text = userTable[1].email
    emailField:setTextColor(100,100,100)
    fields:insert(emailField)


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


    wheatBool:addEventListener("tap", changeWheatBool)
    dairyBool:addEventListener("tap", changeDairyBool)
    glutenBool:addEventListener("tap", changeGlutenBool)
end


-- Called when scene is about to move offscreen:
function scene:exitScene()
    print('leaving account')

    wheatBool:removeEventListener("tap", changeWheatBool)
    dairyBool:removeEventListener("tap", changeDairyBool)
    glutenBool:removeEventListener("tap", changeGlutenBool)
    
    bkgd:removeEventListener("tap", listener)
    emailField:removeSelf()
    nameField:removeSelf()

    storyboard.removeScene( "account" )
    storyboard.state.previousScene = "account"

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    print ('destroying account')

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

scene:addEventListener( "didExitScene", scene)
---------------------------------------------------------------------------------

return scene
