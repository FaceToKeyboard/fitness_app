--[[
-----------------------------------------------------------------------------------------
--
-- main.lua
--

The entry point of the app. 

The appData is declared, tab bar is set up, and splash screen is displayed and closed.
After the splash screen closes, the scene automatically transitions to 
the first interactive scene: Day A.lua


-----------------------------------------------------------------------------------------
-- ]]


local helper = require("helper")
local widget = require "widget"
local CardGroup = require "CardGroup"
local composer = require "composer"

local tabBar = {}
local appData = require "appData"



--[[

The appData "class" is used to store and persist data between scene transitions.
I put "class" in quotes because if you look at the appData.lua, it's just:

local A = {}

return A

This allows us to |require| the class, which causes the object to persist
throughout the life/runtime of the app, effectively making it global; all 
while avoiding the actual Global "namespace".

]]--

appData[1] = {}
appData[2] = {}
appData[3] = {}
appData[4] = {}
appData[5] = {}
appData[6] = {}

--[[--------------------------------------

showScreen1, 2, and 3 are the functions called when the tab bar
buttons are hit; they're where the actual goToScene function is called.

]]----------------------------------------

function showScreen1()
    tabBar:setSelected(1)
    composer.removeHidden()
    composer.gotoScene("Day A", {time=400, effect="crossFade"})
    
    return true
end

function showScreen2()
    tabBar:setSelected(2)
    composer.removeHidden()
    composer.gotoScene("Day B", {time=400, effect="crossFade"})
    
    return true
end

function showScreen3()
    tabBar:setSelected(3)
    composer.removeHidden()
    --composer.gotoScene("Warmup", {time=250, effect="crossFade"})
    
    return true
end

--------------------------------------------
--[[
Set up the Tab Bar widget, and configure the buttons to transition to the respective scenes.

Although, the splash screen code further down will hide the tab bar, the bar
has to be set up in this initial Main.lua so that it persists throughout all scenes and remains
despite the transitions; keeping the bar remains in the foreground.
]]--
--------------------------------------------

-- Configure the tab buttons to appear within the bar
local tabButtons = {
    {
        label = "Day A",
        id = "tab1",
        selected = true,
        onPress = showScreen1
    },
    {
        label = "Day B",
        id = "tab2",
        onPress = showScreen2
    },
    {
        label = "Warmup",
        id = "tab3",
        onPress = showScreen3
    }
}

-- Create the widget.
--Note that the default tab bar height is 52
tabBar = widget.newTabBar
{
    top = display.contentHeight- 52,
    width = display.contentWidth,
    buttons = tabButtons

}


--[[----------
Splash screen handling:
Blank background with app title on along the bottom, with a timed delay
before the splash screen is closed, and the first interactive scene/screen is loaded.
----------]]--

local contentAreaBackground = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	contentAreaBackground.anchorX = 0
	contentAreaBackground.anchorY = 0
	contentAreaBackground:setFillColor( 1, 1, .5 )

local title = display.newText("Fanno's fitness app", 0, 0,"DroidSans", 28)
	title:setFillColor( 0, 0, 0 )
	title.x = display.contentCenterX
	title.y = display.contentHeight - 64


local function closeSplash()
    display.remove(title)
    title = nil
    display.remove(contentAreaBackground)
    contentAreaBackground = nil
    showScreen1()
end

timer.performWithDelay(1500, closeSplash)


--Small function to monitor memory usage. Useful to find out if
--scene transitions and cleanup are being done properly.

local monitorMem = function()

  collectgarbage()
  print( "MemUsage: " .. collectgarbage("count") )

  local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
  print( "TexMem: " .. textMem )
end

--Runtime:addEventListener( "enterFrame", monitorMem )

