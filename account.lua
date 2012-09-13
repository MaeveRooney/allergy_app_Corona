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

--load database
require "sqlite3"

local path = system.pathForFile( "test3.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

userTable = {}  -- starts off emtpy




local function goHomeScreen()
    userTable = {} 
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "home", options)
end

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
    local q = [[UPDATE user SET name='Big Bird';]]
    db:exec( q )
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    
    local background = display.newRect(0, 0, w, h)
    background:setFillColor(255, 255, 255)
    group:insert(background)

    --Setup the nav bar
    local navBar = display.newImage("navBar.png", 0, 0, true)
    navBar.x = w*.5
    navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)
    group:insert(navBar)

    local navHeader = display.newText("My Allergy", 0, 0, native.systemFontBold, 16)
    navHeader:setTextColor(255, 255, 255)
    navHeader.x = w*.5 + 30
    navHeader.y = navBar.y
    group:insert(navHeader)

    --Setup the back button
    backBtn = ui.newButton{
        default = "backButton.png",
        over = "backButton_over.png",
        onRelease = goHomeScreen
    }
    backBtn.x = 50
    backBtn.y = navBar.y
    backBtn.alpha = 1
    group:insert(backBtn)

    userText = display.newText("", 0, 0, native.systemFontBold, 24)
    userText:setTextColor(0, 0, 0)
    userText.x = math.floor(w/2)
    userText.y = math.floor(h/5)
    group:insert(userText)

    emailText = display.newText('', 0, 0, native.systemFontBold, 18)
    emailText:setTextColor(0, 0, 0)
    emailText.x = math.floor(w/2)
    emailText.y = math.floor(h/3)
    group:insert(emailText)

    wheatText = display.newText("    Wheat Allergy:", 0, 0, native.systemFontBold, 16)
    wheatText:setTextColor(0, 0, 0)
    wheatText.y = math.floor(h/2)
    group:insert(wheatText)

    wheatBool = display.newText('', 0, 0, native.systemFontBold, 16)
    wheatBool.x = math.floor(w/2) + 50
    wheatBool.y = math.floor(h/2)
    group:insert(wheatBool)


    glutenText = display.newText("    Gluten Allergy:", 0, 0, native.systemFontBold, 16)
    glutenText:setTextColor(0, 0, 0)
    glutenText.y = math.floor(h/2) + 40
    group:insert(glutenText)

    glutenBool = display.newText("", 0, 0, native.systemFontBold, 16)
    glutenBool.x = math.floor(w/2) + 50
    glutenBool.y = math.floor(h/2) + 40
    group:insert(glutenBool)


    dairyText = display.newText("    Dairy Allery:", 0, 0, native.systemFontBold, 16)
    dairyText:setTextColor(0, 0, 0)
    dairyText.y = math.floor(h/2) + 80
    group:insert(dairyText)

    dairyBool = display.newText('', 0, 0, native.systemFontBold, 16)
    dairyBool.x = math.floor(w/2) + 50
    dairyBool.y = math.floor(h/2) + 80
    group:insert(dairyBool)


    tapText = display.newText("Tap Yes/No to change", 0, 0, native.systemFontBold, 12)
    tapText:setTextColor(90, 90, 90)
    tapText.x = math.floor(w/2)
    tapText.y = math.floor(h/2) + 140
    group:insert(tapText)

    saveText = display.newText("Save Changes", 0, 0, native.systemFontBold, 20)
    saveText:setTextColor(0, 0, 180)
    saveText.x = math.floor(w/2)
    saveText.y = math.floor(h/2) + 180
    group:insert(saveText)




    -----------------------------------------------------------------------------
        
    --  CREATE display objects and add them to 'group' here.
    --  Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group= self.view
    print('entering')
    userTable = {}  -- starts off emtpy
	
	for row in db:nrows("SELECT * FROM user where email = 'maeve.rooney@gmail.com'") do
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

    for row in db:nrows("SELECT * FROM user where email = 'maeve.rooney@gmail.com'") do
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

    print(userTable[1].name)

    userText.text="User: "..userTable[1].name
    emailText.text="Email: "..userTable[1].email

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
	


    wheatBool:addEventListener("tap", changeWheatBool)
    dairyBool:addEventListener("tap", changeDairyBool)
    glutenBool:addEventListener("tap", changeGlutenBool)
    saveText:addEventListener("tap", saveChanges)
end


-- Called when scene is about to move offscreen:
function scene:exitScene()
    print('leaving')

    wheatBool:removeEventListener("tap", changeWheatBool)
    dairyBool:removeEventListener("tap", changeDairyBool)
    glutenBool:removeEventListener("tap", changeGlutenBool)
    saveText:removeEventListener("tap", saveChanges)

end

function scene:didExitScene( event )
    storyboard.purgeScene( "account" )
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

scene:addEventListener( "didExitScene", scene)
---------------------------------------------------------------------------------

return scene
