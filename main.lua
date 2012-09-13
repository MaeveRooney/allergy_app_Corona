display.setStatusBar(display.HiddenStatusBar);      --hide the status bar

local storyboard = require "storyboard"
local widget = require "widget"
local ui = require("ui")

storyboard.state = {}


-- Display objects added below will not respond to storyboard transitions

-- create buttons table for the tab bar
storyboard.state.tabButtons = {
    {
        label="Home",
        default="assets/tabIcon.png",
        down="assets/tabIcon-down.png",
        width=32, height=32,
        onPress=function() storyboard.gotoScene( "home" ); end,
        selected=true
    },
    {
        label="Search",
        default="assets/tabIcon.png",
        down="assets/tabIcon-down.png",
        width=32, height=32,
        onPress=function() storyboard.gotoScene( "search" ); end,
    },
    {
        label="My Account",
        default="assets/tabIcon.png",
        down="assets/tabIcon-down.png",
        width=32, height=32,
        onPress=function() storyboard.gotoScene( "account" ); end,
    }
}

-- create a tab-bar and place it at the bottom of the screen
local demoTabs = widget.newTabBar{
    top=display.contentHeight-50,
    buttons=storyboard.state.tabButtons
}

--Setup the nav bar
local navBar = display.newImage("navBar.png", 0, 0, true)
navBar.x = display.contentWidth*.5
navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)

storyboard.state.navHeader = display.newText("Home", 0, 0, native.systemFontBold, 16)
storyboard.state.navHeader:setTextColor(255, 255, 255)
storyboard.state.navHeader.x = navBar.x
storyboard.state.navHeader.y = navBar.y

storyboard.state.previousScene = "home"

--Setup the back button
storyboard.state.backBtn = ui.newButton{
    default = "backButton.png",
    over = "backButton_over.png",
    onRelease = function() storyboard.gotoScene( storyboard.state.previousScene ); end }
storyboard.state.backBtn.x = 50
storyboard.state.backBtn.y = 20
storyboard.state.backBtn.alpha = 0

storyboard.state.localBackBtn = ui.newButton{
    default = "backButton.png",
    over = "backButton_over.png",
    onRelease = backBtnRelease
}
storyboard.state.localBackBtn.y = 20
storyboard.state.localBackBtn.x = -50

-----------------------------DATABASE STUFF------------------------------------------
require "sqlite3"

local path = system.pathForFile( "test3.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local tablesetup1 = [[CREATE TABLE IF NOT EXISTS restaurant (id INTEGER PRIMARY KEY autoincrement, name text unique not null, avgYummy num, avgValue num, address text, image text, website text unique, wheatVoteNum int, wheatVotePercent num, glutenVoteNum int, glutenVotePercent num, dairyVoteNum int, dairyVotePercent num);]]
db:exec( tablesetup1 )

local tablesetup2 = [[CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY autoincrement, name text not null, email unique not null, wheat text, gluten text, dairy text);]]
db:exec( tablesetup2 )

local tablesetup3 = [[CREATE TABLE IF NOT EXISTS review (id INTEGER PRIMARY KEY autoincrement, restaurantId integer REFERENCES restaurant not null, userId integer REFERENCES user not null, reviewText text, friendly integer, yummy integer, value integer, wheatVote int, glutenVote int, dairyVote int);]]
db:exec( tablesetup3 )

local restaurantTable =
{
    {
        name = "Italian Restaurant",
        avgYummy = 4.3,
        avgValue = 2.7,
        address = "2 main street, dublin 2.",
        image = "rest1.jpg",
        website = "http://www.example1.com/",
        wheatVoteNum = 24,
        wheatVotePercent = 35.9,
        glutenVoteNum = 24,
        glutenVotePercent = 35.9,
        dairyVoteNum = 24,
        dairyVotePercent = 35.9
    },
    {
        name = "Mexican Restaurant",
        avgYummy = 3.7,
        avgValue = 1.9,
        address = "6 main street, dublin 2.",
        image = "rest2.jpg",
        website = "http://www.example2.com/",
        wheatVoteNum = 24,
        wheatVotePercent = 35.9,
        glutenVoteNum = 24,
        glutenVotePercent = 35.9,
        dairyVoteNum = 24,
        dairyVotePercent = 35.9
    },
    {
        name = "Chinese Restaurant",
        avgYummy = 2.9,
        avgValue = 3.2,
        address = "7 main street, dublin 2.",
        image = "rest3.jpg",
        website = "http://www.example3.com/",
        wheatVoteNum = 24,
        wheatVotePercent = 35.9,
        glutenVoteNum = 24,
        glutenVotePercent = 35.9,
        dairyVoteNum = 24,
        dairyVotePercent = 35.9
    },
    {
        name = "Maeves Restaurant",
        avgYummy = 4.7,
        avgValue = 1.2,
        address = "8 main street, dublin 2.",
        image = "rest4.jpg",
        website = "http://www.example4.com/",
        wheatVoteNum = 24,
        wheatVotePercent = 35.9,
        glutenVoteNum = 24,
        glutenVotePercent = 35.9,
        dairyVoteNum = 24,
        dairyVotePercent = 35.9
    }
}

for i=1,#restaurantTable do
    local q = [[INSERT INTO restaurant VALUES (NULL, ']] .. restaurantTable[i].name .. [[',']] .. restaurantTable[i].avgYummy .. [[', ']] .. restaurantTable[i].avgValue .. [[', ']] .. restaurantTable[i].address .. [[', ']] .. restaurantTable[i].image .. [[', ']] .. restaurantTable[i].website ..[[', ']] ..restaurantTable[i].wheatVoteNum ..[[', ']] ..restaurantTable[i].wheatVotePercent ..[[', ']] ..restaurantTable[i].glutenVoteNum ..[[', ']] ..restaurantTable[i].glutenVotePercent ..[[', ']] ..restaurantTable[i].dairyVoteNum ..[[', ']] ..restaurantTable[i].dairyVotePercent ..[['); ]]
    db:exec( q )
end

local insertQuery = [[INSERT INTO user VALUES (NULL, 'Maeve Rooney','maeve.rooney@gmail.com', 'Yes', 'No', 'No'); ]]
db:exec( insertQuery )

local function onSystemEvent( event )
    if event.type == "applicationExit" then
        if db and db:isopen() then
            db:close()
        end
    end
end
Runtime:addEventListener( "system", onSystemEvent )

-- load scenetemplate.lua
storyboard.gotoScene( "home" )

