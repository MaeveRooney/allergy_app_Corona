----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require "widget"
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
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - 50 - display.viewableContentHeight

table.indexOf = function( t, object )
    local result

    if "table" == type( t ) then
        for i=1,#t do
            if object == t[i] then
                result = i
                break
            end
        end
    end

    return result
end

local sceneText, backBtn, friendStarTable, yummyStarTable, valueStarTable, wheatOptions, glutenOptions, dairyOptions
local w,h = display.contentWidth, display.contentHeight - 50

local restaurantNameDB, reviewTextDB, wheatVoteDB, glutenVoteDB, dairyVoteDB, friendRatingDB, yummyRatingDB, valueRatingDB,
wheatVoteDB = 0
glutenVoteDB = 0
dairyVoteDB = 0

--load database
require "sqlite3"

local path = system.pathForFile( "test3.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local function goHomeScreen()
    userTable = {} 
    local options = {effect = "fade", time = 400 }
    storyboard.gotoScene( "home", options)
end

local function rateFriendliness(event)
    print(table.indexOf(friendStarTable, event.target))
    for i = 1, table.indexOf(friendStarTable, event.target) do
        friendStarTable[i]:setTextColor(200,200,0)
    end
    for i = 5, table.indexOf(friendStarTable, event.target)+1, -1 do
        friendStarTable[i]:setTextColor(150,150,150)
    end
    friendRatingDB = table.indexOf(friendStarTable, event.target)
end

local function rateValue(event)
    print(table.indexOf(valueStarTable, event.target))
    for i = 1, table.indexOf(valueStarTable, event.target) do
        valueStarTable[i]:setTextColor(200,200,0)
    end
    for i = 5, table.indexOf(valueStarTable, event.target)+1, -1 do
        valueStarTable[i]:setTextColor(150,150,150)
    end
    valueRatingDB = table.indexOf(valueStarTable, event.target)
end

local function rateYumminess(event)
    print(table.indexOf(yummyStarTable, event.target))
    for i = 1, table.indexOf(yummyStarTable, event.target) do
        yummyStarTable[i]:setTextColor(200,200,0)
    end
    for i = 5, table.indexOf(yummyStarTable, event.target)+1, -1 do
        yummyStarTable[i]:setTextColor(150,150,150)
    end
    yummyRatingDB = table.indexOf(yummyStarTable, event.target)
end

local function rateWheat(event)
    if event.target.text == "Yes" then
        wheatVoteDB = 2
        event.target:setTextColor(0,150, 0)
        wheatOptions[2]:setTextColor(150,150,150)
        wheatOptions[3]:setTextColor(150,150,150)
    elseif event.target.text == "No" then
        wheatVoteDB = 1
        event.target:setTextColor(150, 0, 0)
        wheatOptions[1]:setTextColor(150,150,150)
        wheatOptions[3]:setTextColor(150,150,150)
    else
        wheatVoteDB = 0
        event.target:setTextColor(0,0, 150)
        wheatOptions[1]:setTextColor(150,150,150)
        wheatOptions[2]:setTextColor(150,150,150)
    end
end

local function rateGluten(event)
    if event.target.text == "Yes" then
        glutenVoteDB = 2
        event.target:setTextColor(0,150, 0)
        glutenOptions[2]:setTextColor(150,150,150)
        glutenOptions[3]:setTextColor(150,150,150)
    elseif event.target.text == "No" then
        glutenVoteDB = 1
        event.target:setTextColor(150, 0, 0)
        glutenOptions[1]:setTextColor(150,150,150)
        glutenOptions[3]:setTextColor(150,150,150)
    else
        glutenVoteDB = 0
        event.target:setTextColor(0,0, 150)
        glutenOptions[1]:setTextColor(150,150,150)
        glutenOptions[2]:setTextColor(150,150,150)
    end
end

local function rateDairy(event)
    if event.target.text == "Yes" then
        dairyVoteDB = 2
        event.target:setTextColor(0,150, 0)
        dairyOptions[2]:setTextColor(150,150,150)
        dairyOptions[3]:setTextColor(150,150,150)
    elseif event.target.text == "No" then
        dairyVoteDB = 1
        event.target:setTextColor(150, 0, 0)
        dairyOptions[1]:setTextColor(150,150,150)
        dairyOptions[3]:setTextColor(150,150,150)
    else
        dairyVoteDB = 0
        event.target:setTextColor(0, 0, 150)
        dairyOptions[1]:setTextColor(150,150,150)
        dairyOptions[2]:setTextColor(150,150,150)
    end
end


function saveChanges(event)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    
    local scrollBox = widget.newScrollView{
        top = 50,
        width = 320, height = 366,
        scrollWidth = w, scrollHeight = 600,
    }   
    
    local background = display.newRect(0, 0, w, h)
    background:setFillColor(255, 255, 255)
    group:insert(background)

    restaurantName = display.newText("", 0, 0, native.systemFontBold, 18)
    restaurantName:setTextColor(0, 0, 0)
    restaurantName.x = math.floor(w/2)
    restaurantName.y = 50
    scrollBox:insert(restaurantName)

    reviewText = display.newText('', 0, 0, native.systemFontBold, 18)
    reviewText:setTextColor(0, 0, 0)
    reviewText.x = math.floor(w/2)
    reviewText.y = 100
    scrollBox:insert(reviewText)

    friendText = display.newText("    Friendliness rating:", 0, 0, native.systemFontBold, 16)
    friendText:setTextColor(0, 0, 0)
    friendText.y = 250
    scrollBox:insert(friendText)

    friendStarTable = {}

    for i = 1, 5 do
        friendStarTable[i] = display.newText('*', 0, 0, native.systemFontBold, 40)
        friendStarTable[i]:setTextColor(150,150,150)
        friendStarTable[i].x = math.floor(w/2) + 40 + 20*i
        friendStarTable[i].y = 258
        scrollBox:insert(friendStarTable[i])
    end

    yummyText = display.newText("    Yumminess Rating:", 0, 0, native.systemFontBold, 16)
    yummyText:setTextColor(0, 0, 0)
    yummyText.y = 290
    scrollBox:insert(yummyText)

    yummyStarTable = {}

    for i = 1, 5 do
        yummyStarTable[i] = display.newText('*', 0, 0, native.systemFontBold, 40)
        yummyStarTable[i]:setTextColor(150,150,150)
        yummyStarTable[i].x = math.floor(w/2) + 40 + 20*i
        yummyStarTable[i].y = 298
        scrollBox:insert(yummyStarTable[i])
    end

    valueText = display.newText("    Value for money:", 0, 0, native.systemFontBold, 16)
    valueText:setTextColor(0, 0, 0)
    valueText.y = 330
    scrollBox:insert(valueText)

    valueStarTable = {}

    for i = 1, 5 do
        valueStarTable[i] = display.newText('*', 0, 0, native.systemFontBold, 40)
        valueStarTable[i]:setTextColor(150,150,150)
        valueStarTable[i].x = math.floor(w/2) + 40 + 20*i
        valueStarTable[i].y = 338
        scrollBox:insert(valueStarTable[i])
    end

    allergyHeader = display.newText("Does this restaurant cater", 0, 0, native.systemFontBold, 18)
    allergyHeader:setTextColor(0, 0, 0)
    allergyHeader.x = math.floor(w/2)
    allergyHeader.y = 400
    scrollBox:insert(allergyHeader)

    allergyHeader2 = display.newText("to the following allergies?", 0, 0, native.systemFontBold, 18)
    allergyHeader2:setTextColor(0, 0, 0)
    allergyHeader2.x = math.floor(w/2)
    allergyHeader2.y = 420
    scrollBox:insert(allergyHeader2)

    wheatText = display.newText("    Wheat:", 0, 0, native.systemFontBold, 16)
    wheatText:setTextColor(0, 0, 0)
    wheatText.y = 460
    scrollBox:insert(wheatText)

    wheatOptions = {}

    wheatOptions[1] = display.newText("Yes", 0, 0, nil,16)
    wheatOptions[1].x = 120
    wheatOptions[2] = display.newText("No", 0, 0, nil,16)
    wheatOptions[2].x = 180
    wheatOptions[3] = display.newText("Not sure", 0, 0, nil,16)
    wheatOptions[3].x = 250

    for i = 1, 3 do
        wheatOptions[i].y = 460
        wheatOptions[i]:setTextColor(150,150,150)
        scrollBox:insert(wheatOptions[i])
    end

    glutenText = display.newText("    Gluten:", 0, 0, native.systemFontBold, 16)
    glutenText:setTextColor(0, 0, 0)
    glutenText.y = 500
    scrollBox:insert(glutenText)

    glutenOptions = {}

    glutenOptions[1] = display.newText("Yes", 0, 0, nil,16)
    glutenOptions[1].x = 120
    glutenOptions[2] = display.newText("No", 0, 0, nil,16)
    glutenOptions[2].x = 180
    glutenOptions[3] = display.newText("Not sure", 0, 0, nil,16)
    glutenOptions[3].x = 250

    for i = 1, 3 do
        glutenOptions[i].y = 500
        glutenOptions[i]:setTextColor(150,150,150)
        scrollBox:insert(glutenOptions[i])
    end

    dairyText = display.newText("    Dairy:", 0, 0, native.systemFontBold, 16)
    dairyText:setTextColor(0, 0, 0)
    dairyText.y = 540
    scrollBox:insert(dairyText)

    dairyOptions = {}

    dairyOptions[1] = display.newText("Yes", 0, 0, nil,16)
    dairyOptions[1].x = 120
    dairyOptions[2] = display.newText("No", 0, 0, nil,16)
    dairyOptions[2].x = 180
    dairyOptions[3] = display.newText("Not sure", 0, 0, nil,16)
    dairyOptions[3].x = 250

    for i = 1, 3 do
        dairyOptions[i].y = 540
        dairyOptions[i]:setTextColor(150,150,150)
        scrollBox:insert(dairyOptions[i])
    end


    saveText = display.newText("Save Changes", 0, 0, native.systemFontBold, 20)
    saveText:setTextColor(0, 0, 180)
    saveText.x = math.floor(w/2)
    saveText.y = 600
    scrollBox:insert(saveText)


    group:insert(scrollBox)


    -----------------------------------------------------------------------------
        
    --  CREATE display objects and add them to 'group' here.
    --  Example use-case: Restore 'group' from previously saved state.
    
    -----------------------------------------------------------------------------
    
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    print('entering')

    storyboard.state.navHeader.text = "       Review An Eatery"

    storyboard.state.backBtn.alpha = 1


    restaurantName.text="Input for restraunt name goes here"
    reviewText.text="Review text input box goes here"

    for i = 1, 5 do
        friendStarTable[i]:addEventListener("tap", rateFriendliness)
    end

    for i = 1, 5 do
        yummyStarTable[i]:addEventListener("tap", rateYumminess)
    end

    for i = 1, 5 do
        valueStarTable[i]:addEventListener("tap", rateValue)
    end
    for i = 1, 3 do
        wheatOptions[i]:addEventListener("tap", rateWheat)
    end
    for i = 1, 3 do
        glutenOptions[i]:addEventListener("tap", rateGluten)
    end
    for i = 1, 3 do
        dairyOptions[i]:addEventListener("tap", rateDairy)
    end
    saveText:addEventListener("tap", saveChanges)


end


-- Called when scene is about to move offscreen:
function scene:exitScene()
    print('leaving')

    for i = 1, 5 do
        friendStarTable[i]:removeEventListener("tap", rateFriendliness)
    end

    for i = 1, 5 do
        yummyStarTable[i]:removeEventListener("tap", rateYumminess)
    end

    for i = 1, 5 do
        valueStarTable[i]:removeEventListener("tap", rateValue)
    end
    for i = 1, 3 do
        wheatOptions[i]:removeEventListener("tap", rateWheat)
    end
    for i = 1, 3 do
        glutenOptions[i]:removeEventListener("tap", rateGluten)
    end
    for i = 1, 3 do
        dairyOptions[i]:removeEventListener("tap", rateDairy)
    end
    saveText:removeEventListener("tap", saveChanges)
        
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
---------------------------------------------------------------------------------

return scene
