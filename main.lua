--[[
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- ]]

local helper = require("helper")
local widget = require "widget"
local CardGroup = require "CardGroup"
local composer = require "composer"
local appData = require "appData"

appData[1] = {}
appData[2] = {}
appData[3] = {}
appData[4] = {}
appData[5] = {}
appData[6] = {}




print("Hello World!")

local userData = "Squats;5;115"
local path = system.pathForFile("UserData.txt",system.DocumentsDirectory)
local file, errorString = io.open(path,"w")

if not file then
	print("File error: "..errorString)
else
	print("trying to write to a file...")
	file:write(userData)
	io.close(file)
end

file = nil

local test = helper.doesFileExist("UserData.txt",system.DocumentsDirectory)

print( "UserData exists:",test)



print("=================")




--------------------------------------------
--[[

Begin Tab Bar code

]]--
--------------------------------------------

-- Function to handle button events

local tabBar = {}

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

--Example of setting up a function and a listener to trigger/use it

function screenTap()
	--print("Tap sent to screen")
end

display.currentStage:addEventListener( "tap", screenTap )

local contentAreaBackground = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	contentAreaBackground.anchorX = 0
	contentAreaBackground.anchorY = 0
	contentAreaBackground:setFillColor( 1, 1, .5 )

local title = display.newText("Business Sample App", 0, 0,"DroidSans", 28)
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


local monitorMem = function()

  collectgarbage()
  print( "MemUsage: " .. collectgarbage("count") )

  local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
  print( "TexMem: " .. textMem )
end

--Runtime:addEventListener( "enterFrame", monitorMem )

timer.performWithDelay(1500, closeSplash)