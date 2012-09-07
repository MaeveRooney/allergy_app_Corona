display.setStatusBar(display.HiddenStatusBar); 		--hide the status bar

local storyboard = require "storyboard"

-- load scenetemplate.lua
storyboard.gotoScene( "home" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):
--
require "sqlite3"

local path = system.pathForFile( "test1.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local tablesetup1 = [[CREATE TABLE IF NOT EXISTS restaurant (id INTEGER PRIMARY KEY autoincrement, name text unique not null, avgYummy num, avgValue num, address text, image text, website text unique);]]
db:exec( tablesetup1 )

local tablesetup2 = [[CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY autoincrement, name text unique not null, wheat int, gluten int, dairy int));]]
db:exec( tablesetup2 )


local restaurantTable =
{
    {
        name = "Italian Restaurant",
        avgYummy = 4.3,
        avgValue = 2.7,
        address = "2 main street, dublin 2.",
        image = "rest1.jpg",
        website = "http://www.example1.com/"
    },
    {
        name = "Mexican Restaurant",
        avgYummy = 3.7,
        avgValue = 1.9,
        address = "6 main street, dublin 2.",
        image = "rest2.jpg",
        website = "http://www.example2.com/"
    },
    {
        name = "Chinese Restaurant",
        avgYummy = 2.9,
        avgValue = 3.2,
        address = "7 main street, dublin 2.",
        image = "rest3.jpg",
        website = "http://www.example3.com/"
    },
    {
        name = "Maeves Restaurant",
        avgYummy = 4.7,
        avgValue = 1.2,
        address = "8 main street, dublin 2.",
        image = "rest4.jpg",
        website = "http://www.example4.com/"
    }
}

for i=1,#restaurantTable do
    local q = [[INSERT INTO restaurant VALUES (NULL, ']] .. restaurantTable[i].name .. [[',']] .. restaurantTable[i].avgYummy .. [[', ']] .. restaurantTable[i].avgValue .. [[', ']] .. restaurantTable[i].address .. [[', ']] .. restaurantTable[i].image .. [[', ']] .. restaurantTable[i].website ..[['); ]]
    db:exec( q )
end

local insertQuery = [[INSERT INTO user VALUES (NULL, 'Maeve Rooney',1,0,0); ]]
db:exec( insertQuery )

local function onSystemEvent( event )
    if event.type == "applicationExit" then
        if db and db:isopen() then
            db:close()
        end
    end
end
Runtime:addEventListener( "system", onSystemEvent )
