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

local sceneText, backBtn, friendStarTable, yummyStarTable, valueStarTable, friendRating, tastyRating, valueRating
local w,h = display.contentWidth, display.contentHeight - 50 

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
    friendRating = table.indexOf(friendStarTable, event.target)
end

local function rateValue(event)
    print(table.indexOf(valueStarTable, event.target))
    for i = 1, table.indexOf(valueStarTable, event.target) do
        valueStarTable[i]:setTextColor(200,200,0)
    end
    for i = 5, table.indexOf(valueStarTable, event.target)+1, -1 do
        valueStarTable[i]:setTextColor(150,150,150)
    end
    friendRating = table.indexOf(valueStarTable, event.target)
end

local function rateYumminess(event)
    print(table.indexOf(yummyStarTable, event.target))
    for i = 1, table.indexOf(yummyStarTable, event.target) do
        yummyStarTable[i]:setTextColor(200,200,0)
    end
    for i = 5, table.indexOf(yummyStarTable, event.target)+1, -1 do
        yummyStarTable[i]:setTextColor(150,150,150)
    end
    friendRating = table.indexOf(yummyStarTable, event.target)
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
	
	local scrollBox = widget.newScrollView{
		top = 50,
		width = 320, height = 366,
		scrollWidth = 768, scrollHeight = 1024,
	}	
    
    local background = display.newRect(0, 0, w, h)
    background:setFillColor(255, 255, 255)
    group:insert(background)

    --Setup the nav bar
    local navBar = display.newImage("navBar.png", 0, 0, true)
    navBar.x = w*.5
    navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)
    group:insert(navBar)

    local navHeader = display.newText("Review Restaurant", 0, 0, native.systemFontBold, 16)
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

    restaurantName = display.newText("", 0, 0, native.systemFontBold, 18)
    restaurantName:setTextColor(0, 0, 0)
    restaurantName.x = math.floor(w/2)
    restaurantName.y = math.floor(h/7)
    scrollBox:insert(restaurantName)

    reviewText = display.newText('', 0, 0, native.systemFontBold, 18)
    reviewText:setTextColor(0, 0, 0)
    reviewText.x = math.floor(w/2)
    reviewText.y = math.floor(h/3)
    scrollBox:insert(reviewText)

    friendText = display.newText("    Friendliness rating:", 0, 0, native.systemFontBold, 16)
    friendText:setTextColor(0, 0, 0)
    friendText.y = math.floor(h/2)
    scrollBox:insert(friendText)

    friendStarTable = {}

    for i = 1, 5 do
        friendStarTable[i] = display.newText('*', 0, 0, native.systemFontBold, 40)
        friendStarTable[i]:setTextColor(150,150,150)
        friendStarTable[i].x = math.floor(w/2) + 40 + 20*i
        friendStarTable[i].y = math.floor(h/2) + 8
        scrollBox:insert(friendStarTable[i])
    end

    yummyText = display.newText("    Yumminess Rating:", 0, 0, native.systemFontBold, 16)
    yummyText:setTextColor(0, 0, 0)
    yummyText.y = math.floor(h/2) + 40
    scrollBox:insert(yummyText)

    yummyStarTable = {}

    for i = 1, 5 do
        yummyStarTable[i] = display.newText('*', 0, 0, native.systemFontBold, 40)
        yummyStarTable[i]:setTextColor(150,150,150)
        yummyStarTable[i].x = math.floor(w/2) + 40 + 20*i
        yummyStarTable[i].y = math.floor(h/2) + 48
        scrollBox:insert(yummyStarTable[i])
    end

    valueText = display.newText("    Value for money:", 0, 0, native.systemFontBold, 16)
    valueText:setTextColor(0, 0, 0)
    valueText.y = math.floor(h/2) + 80
    scrollBox:insert(valueText)

    valueStarTable = {}

    for i = 1, 5 do
        valueStarTable[i] = display.newText('*', 0, 0, native.systemFontBold, 40)
        valueStarTable[i]:setTextColor(150,150,150)
        valueStarTable[i].x = math.floor(w/2) + 40 + 20*i
        valueStarTable[i].y = math.floor(h/2) + 88
        scrollBox:insert(valueStarTable[i])
    end

    saveText = display.newText("Save Changes", 0, 0, native.systemFontBold, 20)
    saveText:setTextColor(0, 0, 180)
    saveText.x = math.floor(w/2)
    saveText.y = math.floor(h/2) + 180
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
