----------------------------------------------------------------------------------------------------------------------------
--[[


Card
==========

The "card" is one of the primary structures in the fitness app; and it may be the most important!

A card is a section of screen that displays the exercise name, number of sets, number of reps, and amount of weight
all arranged in the form of a card with rounded corners. I aimed to size the cards such that 3 of them are displayed
comfortably in each scene.

Each exercise gets it's own card, and each card has some properties that will need to be set for the exercise:

*Exercise's name
*The number of sets (maximum of 5 because I was aiming to track a 5x5 exercise program, "5x5 Stronglifts")
*Weight being moved/lifted on the exercise

The cardgroup can handle 1 to 5 sets - anything beyond 5 is undefined behavior to me.
As the number of sets changes, the number of circles on the card changes to match.

The circles on the card are actually buttons that, when pressed, toggles between green and red. These
are to track when you've finished a set.

When intializing/creating a CardGroup, you'll want to set its position, set the exercise information, and pass the card's 
displayGroup to the scene composer. Here's an example code snippet from Day A.lua where do just that:

local firstCardGroup

firstCardGroup = CardGroup.newCardGroup()
		firstCardGroup.changeX (3)
		firstCardGroup.changeY( 0 )
		firstCardGroup.changeName("Squat")
		firstCardGroup.changeSets(5)
		firstCardGroup.changeWeight(185)
	sceneGroup:insert( firstCardGroup.getDisplayGroup() )

The changeX and changeY methods are where the card's upper left corner should be; the upper-left corner is the 
origin (0,0) point of the card.

You'll notice that each visual element of the cardgroup is followed by a mainGroup:insert()
This puts all the elements on one displayGroup (mainGroup), so they can be moved and transformed together.


]]--
----------------------------------------------------------------------------------------------------------------------------
local widget = require "widget"
local json = require "json"
local composer = require "composer"

local CardGroup = {}

function CardGroup.newCardGroup()

	local self = {}

	self.x = 0
	self.y = 0
	self.exerciseName = "Null"
	self.numSets = 2
	self.numReps = 0
	self.amtWeight = 0
	self.cardWidth = 0
	self.cardHeight = 0

	local buttonSpace = display.contentWidth*.18
	local mainGroup = display.newGroup()
		mainGroup.x = self.x
		mainGroup.y = self.y
	local buttonGroup = display.newGroup( )
	local handleButtonEvent


	
	--[[-----------------------
	Here begins the building of the visual components of the cardgroup.

	Each card has its background, the exercise name, the "Sets:" and "Weight:" labels, set and weight amounts,
	and buttons to track set completion.

	]]-------------------------
	local background = display.newRect(0,0,display.contentWidth-7, display.contentHeight*.26)
		background.anchorX = 0
		background.anchorY = 0
		background:setFillColor( .95,.95,.95 )
		background:setStrokeColor( .9,.9,.9 )
		background.strokeWidth = 2
	    background.x = 0
	    background.y = (0)
	mainGroup:insert(background)
	
	
	local myExerciseName = display.newText(self.exerciseName, 15,50,0,0,"Fonts/Action_Man_Bold.ttf",20,"left")
		myExerciseName:setFillColor( 0,0,0 )
		myExerciseName.anchorX = 0
		myExerciseName.anchorY = 1
	mainGroup:insert(myExerciseName)


	local mySetsWeightText = display.newText("Sets:\nWeight:", display.contentWidth*.65,50,0,0,"Fonts/Action_Man.ttf",15,"left")
		mySetsWeightText:setFillColor( .2,.5,.4 )
		mySetsWeightText.anchorX = 0
		mySetsWeightText.anchorY = 1
	mainGroup:insert(mySetsWeightText)


	local mySetsWeightNum = display.newText(tostring(self.numSets).."\n"..tostring(self.amtWeight), display.contentWidth*.85,50,0,0,"Fonts/Action_Man.ttf",15,"left")
		mySetsWeightNum:setFillColor( 0,.3,1 )
		mySetsWeightNum.anchorX = 0
		mySetsWeightNum.anchorY = 1
	mainGroup:insert(mySetsWeightNum)

	--This for loop creates the number of buttons according to numSets, 
	--and adds each button to the displaygroup

	for i = 0,self.numSets-1 do

		local options = {
			x = display.contentWidth*.13 + ( i * buttonSpace),
			y = 90,
			onEvent = handleButtonEvent,
			emboss = true,
			shape = "circle",
			radius = 20,
			fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 1 } },
			strokeColor = { default={ .5, .5, .5, 1 }, over={ 0.8, 0.8, 1, 1 } },
			strokeWidth = 2
		}

		local myCircleObject = widget.newButton(options)

		buttonGroup:insert(myCircleObject)

		mainGroup:insert( buttonGroup )
	end

	--[[-----------------------

	Below you will find the member functions, getters, and setters for cardGroups.
	
	--]]-----------------------
	handleButtonEvent = function(event)
		if ( event.phase == "began" ) then 

			print("Began: Button pushed!")
		end

		if ( event.phase == "ended" ) then

			if ( event.target.toggledOn == 1 ) then 
				event.target:setFillColor( 1,0,0,.2 )
				event.target.toggledOn = 0
			elseif ( event.target.toggledOn == 0 ) then
				event.target:setFillColor( 0, 1, 0, .2 )
				event.target.toggledOn = 1
			end
		end
	end

	function self.changeName( newName )
		self.exerciseName = newName
		myExerciseName.text = self.exerciseName
	end


	function self.changeX (newX)
		self.x = newX
		mainGroup.x = self.x
		--buttonGroup.x = newX
	end


	function self.changeY (newY)
		self.y = newY
		mainGroup.y = self.y
		--buttonGroup.y = newY
	end


	function self.changeWeight(newWeight)
		self.amtWeight = newWeight
		mySetsWeightNum.text = tostring(self.numSets).."\n"..tostring(self.amtWeight)
	end


	function self.changeSets(newSets)
		self.numSets = newSets
		mySetsWeightNum.text = tostring(self.numSets).."\n"..tostring(self.amtWeight)

		for i = buttonGroup.numChildren,1,-1 do
			buttonGroup[i]:removeSelf()
			buttonGroup[i] = nil
		end

		for i = 0,self.numSets-1 do

			local options = {

				x = display.contentWidth*.13 + ( i * buttonSpace),
				y = 90,
				onEvent = handleButtonEvent,
				emboss = true,
				shape = "circle",
				radius = 20,
				fillColor = { default={ 0, 1, 0, .2}, over={ 1, 0.2, 0.5, 1 } },
				strokeColor = { default={ .5, .5, .5, 1 }, over={ 0.8, 0.8, 1, 1 } },
				strokeWidth = 2

			}

			local myCircleObject = widget.newButton(options)
			myCircleObject.toggledOn = 1

			buttonGroup:insert(myCircleObject)
		end
	end

	function self.getDisplayGroup()

		return mainGroup
	end

	--Returns a JSON formatted structure with this exercise's information
	function self.getExerciseInfo()

		local toJSON = {}

		toJSON.exerciseName = self.exerciseName
		toJSON.numSets = self.numSets
		toJSON.numReps = self.numReps
		toJSON.amtWeight = self.amtWeight
		toJSON.buttonStatus = {}

		for i = 1, buttonGroup.numChildren do

			toJSON.buttonStatus[i] = buttonGroup[i].toggledOn
			

		end

		local encoded = json.encode( toJSON, {indent = true} )

		print( "Printing JSON structure: ")
		print( encoded )
		
		return encoded
	end

	--returns a table that is a summary/representation of the current status of the buttons (On or Off)
	function self.getSetStatus()
		local status = {}
		
		for i = 1, buttonGroup.numChildren do

			print(buttonGroup[i]:getLabel() )

		end

		return status
	end

	--return the displayGroup that contains the buttons
	function self.getButtonGroup()

		return buttonGroup
	end --self.getButtonGroup()

	--Handles bringing up the UI for changing the Set and Rep information
	function self.setInfo(event)

		if event.phase == "began" then

			print("setInfo test")
		end -- "began"
		--Bring up overlay that let's user set/change Set and Rep numbers
	end --self.set.info

	--[[-------------

	Set Listeners

	--]]-------------
	mySetsWeightText:addEventListener( "touch", self.setInfo )

	return self
end  --End of newCardGroup

return CardGroup