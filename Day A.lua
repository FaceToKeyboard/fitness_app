--[[
-----------------------------------------------------------------------------------------
--
-- Day A.lua

This is the first interactive scene that users will encounter.

You'll see regular use of the CardGroup class here, so you may want to open it and look into it at the same
time you read through this; or consider reading over the CardGroup class first.

**scene:create** uses the CardGroup object to create, intialize, and display the exercise information.
	Each CardGroup is the rectangle that is displayed on the phone's display that contains the 
exercise's name, set, rep, and weight info, and also has buttons that can be pressed to track immediate progress
on that exercise.
	You can see there are the "first", "second", and "third" CardGroups, which were intended to occupy 
vertical thirds of the display. 
	Also note that after intializing and setting the information in each cardgroup, the displaygroup that contains
all of that cardgroups objects is added to Day A's sceneGroup. This means that any visual changes/transformations 
to the sceneGroup will also affect the cards; which, in my opinion, makes more sense than leaving
each cardgroup separate from the scenegroup... 
Although maybe a case can be made for adding the cardgroups to their own displayGroup...

**scene:show** is responsible for restoring the previous state of the exercises 
for each cardgroup (if a previous state exists).
	This function is called whenever transitioning back to Day A's scene from somewhere else, such as other days or menus.
It's separate from scene:create because intializing the cardgroups is expensive resource-wise, and restoring is a lot cheaper.
At the moment, my testing via the simulator seems to show that scene:create and scene:show happen every time when transitioning to Day A, 
so maybe there's no big benefit for now; but that could also just be a quirk of the simulator. It's probably properly
efficient and smart on an actual phone.

**scene:hide** is responsible for storing/saving the current state of the information in the cardgroups.
Called whenever transitioning away from Day A to another scene, such as a different day, or menu.

**scene:destroy** is called when cleaning up, to free the scene's information from memory.
Having
local sceneGroup = self.view
in the function call is critical, as that gives Corona the proper ability to access and free everything in the scene.

Note: local sceneGroup = self.view 
is in every "scene:" function. That's critical, and needed to allow Corona to handle scenes.


At the bottom of this scenefile, you'll see event listeners for each of the "scene:" functions, and
then a return of "scene" - this is how Corona gets access to the scene and its functions.

--
--
-----------------------------------------------------------------------------------------
]]--


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

print("Initialize Day A...")


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
		secondCardGroup.changeName("Bench Press")
		secondCardGroup.changeSets(5)
		secondCardGroup.changeWeight(135)
	sceneGroup:insert( secondCardGroup.getDisplayGroup() )

	thirdCardGroup = CardGroup.newCardGroup()
		thirdCardGroup.changeX (3)
		thirdCardGroup.changeY( display.contentHeight*(.6) )
		thirdCardGroup.changeName("Deadlift")
		thirdCardGroup.changeSets(1)
		thirdCardGroup.changeWeight(225)
	sceneGroup:insert( thirdCardGroup.getDisplayGroup() )
		
end

--Reapply the exercise information if it exists.
function scene:show( event )

	print(event.name)

	local sceneGroup = self.view

	print(appData[1].buttonStatus)

	--If there's saved data present, reapply it
	if event.phase == "will" and appData[1].buttonStatus ~= nil then

			print("Attempting to restore button state...")

			local toggleStatus
			local buttonGroup

			buttonGroup = firstCardGroup.getButtonGroup()

			for i = buttonGroup.numChildren, 1, -1  do 

				toggleStatus = table.remove( appData[1].buttonStatus ) 

				if (toggleStatus == 0) then

					buttonGroup[i].toggledOn = 0 
					buttonGroup[i]:setFillColor( 1,0,0,.2)

				end
			
			end

			buttonGroup = secondCardGroup.getButtonGroup()

			for i = buttonGroup.numChildren, 1, -1  do 

				toggleStatus = table.remove( appData[2].buttonStatus ) 

				if (toggleStatus == 0) then

					buttonGroup[i].toggledOn = 0 
					buttonGroup[i]:setFillColor( 1,0,0,.2)

				end
			
			end

			buttonGroup = thirdCardGroup.getButtonGroup()

			for i = buttonGroup.numChildren, 1, -1  do 

				toggleStatus = table.remove( appData[3].buttonStatus ) 

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

		appData[1] = json.decode( firstCardGroup.getExerciseInfo() )
		appData[2] = json.decode( secondCardGroup.getExerciseInfo() )
		appData[3] = json.decode( thirdCardGroup.getExerciseInfo() )

		print(appData[1].buttonStatus)

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