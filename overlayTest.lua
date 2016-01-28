--[[----------

Testing composer.showOverlay() 

--]]----------

local composer = require( "composer" )

local scene = composer.newScene()

local contentAreaBackground = display.newRect( 0, 0, display.contentWidth, display.contentHeight-52 ) 
local numericField = native.newTextField( 150, 150, 220, 36 )


function scene:create( event )
	local sceneGroup = self.view

	contentAreaBackground.anchorX = 0
	contentAreaBackground.anchorY = 0
	contentAreaBackground:setFillColor( 0,0,0,.6 )
	sceneGroup:insert( contentAreaBackground )
	
	numericField.inputType = "number"
	sceneGroup:insert( numericField )

end


function scene:show( event )
	local sceneGroup = self.view

	
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then
    	-- parent:resumeGame()
        -- Call the "resumeGame()" function in the parent scene
        print("Closing the overlay!")
    end
end

-- By some method (a "resume" button, for example), hide the overlay
function hideOverlay( event )
	composer.hideOverlay( "fade", 400 )

end

function scene:destroy( event ) 
	local sceneGroup = self.view
end



local function handlerFunction( event )

    if ( event.phase == "began" ) then
        -- user begins editing numericField
        print( event.text )
    end   
end

	
	


contentAreaBackground:addEventListener( "touch", hideOverlay )
numericField:addEventListener( "userInput", handlerFunction )

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene)
scene:addEventListener( "hide", scene )
return scene
