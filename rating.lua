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

local myList, detailScreenText, data
local w,h = display.contentWidth, display.contentHeight - 50

local topBoundary = display.screenOriginY + 40
local bottomBoundary = display.screenOriginY + 0


--initial values
local screenOffsetW, screenOffsetH = w -  display.viewableContentWidth, h - display.viewableContentHeight


--load database
require "sqlite3"

local path = system.pathForFile( "test5.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local restaurantTableNew = {}  -- starts off emtpy


-- Called when the scene's view does not exist:
function scene:createScene( event )
    print('creating rating')
    local group = self.view

    for row in db:nrows("SELECT * FROM restaurant ORDER BY ((avgValue + avgYummy)/2) DESC") do
    -- create table at next available array index
        restaurantTableNew[#restaurantTableNew+1] =
        {
            name = row.name,
            avgRating = ((row.avgYummy + row.avgValue)/2),
            avgYummy = row.avgYummy,
            avgValue = row.avgValue,
            address = row.address,
            image = row.image,
            website = row.website
        }
    end

    local background = display.newRect(0, 0, w, h)
    background:setFillColor(255, 255, 255)
    group:insert(background)

    --setup a destination for the list items
    local detailScreen = display.newGroup()
    group:insert(detailScreen)

    local detailBg = display.newRect(0,0,w,h-display.screenOriginY)
    detailBg:setFillColor(255,255,255)
    detailScreen:insert(detailBg)

    detailScreenText = display.newText("You tapped item", 0, 0, native.systemFontBold, 24)
    detailScreenText:setTextColor(0, 0, 0)
    detailScreen:insert(detailScreenText)
    detailScreenText.x = math.floor(w/2)
    detailScreenText.y = math.floor(h/2)
    detailScreen.x = w


    --setup functions to execute on touch of the list view items
    function listButtonRelease( event )
        self = event.target
        local id = self.id

        storyboard.state.localBackBtn.x = 50
        storyboard.state.backBtn.x = -50

        detailScreenText.text = restaurantTableNew[self.id].name
        transition.to(myList, {time=400, x=w*-1, transition=easing.outExpo })
        transition.to(detailScreen, {time=400, x=0, transition=easing.outExpo })
        print('detail screen')

        delta, velocity = 0, 0
    end

    function backBtnRelease( event )
        print("back button released")

        storyboard.state.localBackBtn.x = -50
        storyboard.state.backBtn.x = 50

        transition.to(myList, {time=400, x=0, transition=easing.outExpo })
        transition.to(detailScreen, {time=400, x=display.contentWidth, transition=easing.outExpo })

        delta, velocity = 0, 0
    end

    -- setup some data
    local data = {}
    for i=1, #restaurantTableNew do
        data[i] = {}
        data[i].title = restaurantTableNew[i].name
        data[i].subtitle = "Overall Rating  " .. restaurantTableNew[i].avgRating
        data[i].image = restaurantTableNew[i].image
    end


    -- create the list of items
    myList = tableView.newList{
        data=data,
        default="assets/listItemBg.png",
        over="assets/listItemBg_over.png",
        onRelease=listButtonRelease,
        top=topBoundary,
        bottom=bottomBoundary,
        backgroundColor={ 255, 255, 255 },
        callback=function(row)
                local g = display.newGroup()

                local img = display.newImage(row.image)
                g:insert(img)
                img.width = 80
                img.height = 60
                img.x = math.floor(46)
                img.y = math.floor(45)

                local title = display.newText(row.title, 0, 0, native.systemFontBold, 16)
                g:insert(title)
                title:setTextColor(0, 0, 0)
                title.x = math.floor(title.width/2) + 100
                title.y = 46

                local subtitle =  display.newText( row.subtitle, 0, 0, native.systemFont, 12 )
                subtitle:setTextColor(180,180,180)
                g:insert(subtitle)
                subtitle.x = math.floor(title.width/2) + 100
                subtitle.y = title.y + title.height + 6
                return g
            end
    }
    group:insert(myList)


    -----------------------------------------------------------------------------

    --  CREATE display objects and add them to 'group' here.
    --  Example use-case: Restore 'group' from previously saved state.

    -----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    print("entering rating")
    storyboard.state.navHeader.text = "      Search By Rating"

    storyboard.state.backBtn.alpha = 1

    storyboard.removeScene( "search" )

    storyboard.state.localBackBtn = ui.newButton{
        default = "assets/backButton.png",
        over = "assets/backButton_over.png",
        onRelease = backBtnRelease
    }
    storyboard.state.localBackBtn.y = 20
    storyboard.state.localBackBtn.x = -50
    storyboard.state.backBtn.x = 50


end


-- Called when scene is about to move offscreen:
function scene:exitScene()
    print('leaving rating')
    storyboard.removeScene( "rating" )
    storyboard.state.previousScene = "rating"

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    print ('destroying rating')

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



