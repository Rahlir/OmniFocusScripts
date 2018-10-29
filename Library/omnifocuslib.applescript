property author : "Tadeas Uhlir"
property version : "1.0"
property name : "omnifocuslib"

property TAGPRIORITY : {¬
	{name: "🗄Next", priority:4}, {name:"Location", priority:3}, {name:"School", priority:2},¬
	{name:"Activity", priority:2}, {name:"Difficulty", priority:0},¬
	{name:"Importance", priority:-1} }

on getTagPriority()
	tell application "Finder" to set dname to container of (path to me) as string
	set pfilePath to dname & "omnitagpriorities.plist" as alias
	tell application "System Events"
		set pfile to property list file pfilePath
		return every property list item of pfile
	end tell
end getTagPriority

on simple_sort(my_list)
	set the index_list to {}
	set the sorted_list to {}
	repeat (the number of items in my_list) times
		set the low_item to ""
		repeat with i from 1 to (number of items in my_list)
			if i is not in the index_list then
				set this_item to item i of my_list
				if the low_item is "" then
					set the low_item to this_item
					set the low_item_index to i
				else if retrievePriority(this_item) is less than retrievePriority(low_item) then
					set the low_item to this_item
					set the low_item_index to i
				end if
			end if
		end repeat
		set the end of sorted_list to the low_item
		set the end of the index_list to the low_item_index
	end repeat
	return the sorted_list
end simple_sort

on retrievePriority(tagItem)
	tell application "OmniFocus"
		set tagName to name of my getSuperParent(tagItem)
		repeat with rec in my TAGPRIORITY
			if name of rec is equal to tagName then
				return priority of rec
			end if
		end repeat
		return 1
	end tell
end retrievePriority

on getSuperParent(tagOne)
	tell application "OmniFocus"
		set nameToLog to name of tagOne
		log nameToLog
		set tagContainer to container of tagOne
		if class of tagContainer is equal to tag then
			return my getSuperParent(tagContainer)
		else
			return tagOne
		end if
	end tell
end getSuperParent

on getSelectedActions()
	tell application "OmniFocus"
		tell content of first document window of front document
			--Get selection
			set validSelectedItemsList to value of (selected trees where class of its value is not item and class of its value is not folder and class of its value is not tag and class of its value is not perspective)
			return validSelectedItemsList
		end tell
	end tell
end getSelectedActions

on getSettingItem(settingId)
	tell application "OmniFocus"
		return value of setting id settingId of default document
	end tell
end getSettingItem

on getDuration(defDuration)
	if defDuration is missing value then
		set defDuration to 15
	end if
	tell application "OmniFocus"
		set totalDur to 0
		repeat with taskOne in my getSelectedActions()
			set dur to estimated minutes of taskOne
			if dur is missing value then
				set dur to defDuration
			end if
			set totalDur to totalDur + dur
		end repeat
		set hrs to totalDur div 60
		set mins to totalDur mod 60
		return {hrs, mins}
	end tell
end getDuration

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
end getAllChildren

on convertRGBColorToHexValue(theRGBValues)
	set theHexList to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	set theHexValue to ""
	repeat with a from 1 to count of theRGBValues
		set theCurrentRGBValue to (item a of theRGBValues) div 256
		if theCurrentRGBValue is 256 then set theCurrentRGBValue to 255
		set theFirstItem to item ((theCurrentRGBValue div 16) + 1) of theHexList
		set theSecondItem to item (((theCurrentRGBValue / 16 mod 1) * 16) + 1) of theHexList
		set theHexValue to (theHexValue & theFirstItem & theSecondItem) as string
	end repeat
	return ("#" & theHexValue) as string
end convertRGBColorToHexValue

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
