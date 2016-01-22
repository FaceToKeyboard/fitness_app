--[[
---------------------------------------------------------------------------------------
--
-- Day B.lua

Practically a copy of Day A, with different exercise information loaded. 

See "Day A.lua" for an explanation of the structure.


-----------------------------------------------------------------------------------------
--]]



local helper = require("helper")
local widget = require "widget"
local CardGroup = require "CardGroup"
local composer = require "composer"
local json = require "json"
local scene = composer.newScene()
local appData = require "appData"


local firstCardGroup
local secondCardGroup
local thirdCardGroup
local contentAreaBackground

print("Initialize Day B...")


function scene:create( event )
	local sceneGroup = self.view
	print("creating scene...")

	contentAreaBackground = display.newRect( 0, 0, display.contentWidth, display.contentHeight-52 )
		contentAreaBackground.anchorX = 0
		contentAreaBackground.anchorY = 0
		contentAreaBackground:setFillColor( 0, 0, .8 )
	sceneGroup:insert( contentAreaBackground )

	-- screen display is divided into 3 sections - 1 section for each of the 3 exercises per day in 5x5 StrongLifts
	firstCardGroup = CardGroup.newCardGroup()
		firstCardGroup.changeX (3)
		firstCardGroup.changeY( 0 )
		firstCardGroup.changeName("Squat")
		firstCardGroup.changeSets(5)
		firstCardGroup.changeWeight(185)
	sceneGroup:insert( firstCardGroup.getDisplayGroup() )

	secondCardGroup = CardGroup.newCardGroup()
		secondCardGroup.changeX (3)
		secondCardGroup.changeY( display.contentHeight*(.3) )
		secondCardGroup.changeName("Overhead Press")
		secondCardGroup.changeSets(5)
		secondCardGroup.changeWeight(65)
	sceneGroup:insert( secondCardGroup.getDisplayGroup() )

	thirdCardGroup = CardGroup.newCardGroup()
		thirdCardGroup.changeX (3)
		thirdCardGroup.changeY( display.contentHeight*(.6) )
		thirdCardGroup.changeName("Barbell Row")
		thirdCardGroup.changeSets(5)
		thirdCardGroup.changeWeight(75)
	sceneGroup:insert( thirdCardGroup.getDisplayGroup() )
		
end

--Reapply the exercise information if it exists.
function scene:show( event )

	print(event.name)

	local sceneGroup = self.view

	print(appData[4].buttonStatus)

	--If there's saved data present, reapply it
	if event.phase == "will" and appData[4].buttonStatus ~= nil then

			print("Attempting to restore button state...")

			local toggleStatus
			local buttonGroup

			buttonGroup = firstCardGroup.getButtonGroup()

			for i = buttonGroup.numChildren, 1, -1  do 

				toggleStatus = table.remove( appData[4].buttonStatus ) 

				if (toggleStatus == 0) then

					buttonGroup[i].toggledOn = 0 
					buttonGroup[i]:setFillColor( 1,0,0,.2)

				end
			
			end

			buttonGroup = secondCardGroup.getButtonGroup()

			for i = buttonGroup.numChildren, 1, -1  do 

				toggleStatus = table.remove( appData[5].buttonStatus ) 

				if (toggleStatus == 0) then

					buttonGroup[i].toggledOn = 0 
					buttonGroup[i]:setFillColor( 1,0,0,.2)

				end
			
			end

			buttonGroup = thirdCardGroup.getButtonGroup()

			for i = buttonGroup.numChildren, 1, -1  do 

				toggleStatus = table.remove( appData[6].buttonStatus ) 

				if (toggleStatus == 0) then

					buttonGroup[i].toggledOn = 0 
					buttonGroup[i]:setFillColor( 1,0,0,.2)

				end
			
			end

	end --event.phase == "will"
	
end


--Store the scenes relevant information so it can be recalled/reapplied when returning. 
--Exercise info, sets, reps, weight, and how many sets were completed (shown as buttons)
function scene:hide( event )

	local sceneGroup = self.view

	if event.phase == "will" then

		print("saving to appData")

		appData[4] = json.decode( firstCardGroup.getExerciseInfo() )
		appData[5] = json.decode( secondCardGroup.getExerciseInfo() )
		appData[6] = json.decode( thirdCardGroup.getExerciseInfo() )

		print(appData[4].buttonStatus)

	end

	print(event.name)

end


function scene:destroy( event )
	local sceneGroup = self.view
	print("Destroying Day A's view")
end




--Event listeners and return of "scene" for Corona
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene