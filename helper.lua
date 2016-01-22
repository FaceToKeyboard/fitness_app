----------------------------------------------------------------------------------------------------------------------------
--[[


Helpful functions
==========

-doesFileExist-
Given a filename and path, checks that path for that filename (defaults to system.ResourceDirector if no path provided).
Returns true or false.

]]--
----------------------------------------------------------------------------------------------------------------------------

local Helper = {}

--given the filename and path, returns true if file with that name exists, else returns false.

function Helper.doesFileExist ( fname, path )

    local results = false

    -- Path for the file
    local filePath = system.pathForFile( fname, path )

    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )

        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end

    return results
end

---------------------------------
--[[
Save exercise information to a file.
Exercise name, sets, reps weight

]]--
---------------------------------
function Helper.saveToFile( textString, fname, path )


end

---------------------------------
--[[
Load exercise information into application

]]--
---------------------------------
function Helper.loadFromFile( fname, path )


end

---------------------------------
--[[
Save exercise history/progress.
Dates with exercise info used to produce graphs/charts

]]--
---------------------------------
function Helper.saveExerciseHistory( textString, fname, path )


end


return Helper;