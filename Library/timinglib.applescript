property author : "Tadeas Uhlir"
property version : "1.0"
property name : "timinglib"

on isInTimings(projectName)
	tell application "TimingHelper"
		if projectName is in name of projects of application "TimingHelper" then
			return true
		else
			return false
		end if
	end tell
end isInTimings

on timingGetAllChildren(projectItem)
	tell application "TimingHelper"
		if projectItem is true then
			set childrenProjects to root projects of application "TimingHelper"
		else
			set childrenProjects to projects of projectItem
		end if
		set childrenItems to {}
		repeat with childrenProject in childrenProjects
			log (get name chain of childrenProject)
			copy name chain of childrenProject to end of childrenItems
			set levelDown to my timingGetAllChildren(childrenProject)
			if length of levelDown is not 0 then
				set childrenItems to childrenItems & levelDown
			end if
		end repeat
		return childrenItems
	end tell
end timingGetAllChildren

on addToTimings(pName)
	tell application "TimingHelper"
		try
			display dialog "Project " & pName & " is not in Timings. Would you like to add it?" buttons {"Yes", "No"} default button "Yes" cancel button "No"
		on error number -128
			return false
		end try
		set projectList to my timingGetAllChildren(true)
		copy "Make a root project" to beginning of projectList
		set parentProject to choose from list projectList with title "What should the parent project be?" default items {"Make a root project"}
		if parentProject is false then return false
		set parentProject to first item of parentProject
		if parentProject is "Make a root project" then
			set parentProject to missing value
		else
			set parentProject to front project whose name chain is parentProject
		end if
		display alert "Choose the color for the project"
		try
			set colorItem to choose color default color {0, 0, 40535}
			set colorHex to my convertRGBColorToHexValue(colorItem)
		on error number -128
			return false
		end try
		set validRating to false
		repeat while validRating is false
			try
				set pRatingRaw to display dialog "Set Productivity Rating for project " & pName & " (number between 1 and 0)" buttons {"OK", "Cancel"} default button "OK" cancel button "Cancel" default answer "0.5"
				set pRating to text returned of pRatingRaw as real
				set validRating to (pRating ≤ 1.0 and pRating ≥ 0.0)
				
			on error errText number errNumber
				if errNumber is -128 then
					return false
				else if errNumber is -1700 then
					set validRating to false
				else
					error errText number errNumber
				end if
			end try
		end repeat
		if parentProject is missing value then
			set newProject to create project name pName color colorHex productivity rating pRating
		else
			set newProject to create project name pName parent project parentProject color colorHex productivity rating pRating
		end if
		return newProject
	end tell
end addToTimings
