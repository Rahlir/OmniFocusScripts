use omni : script "omnifocuslib"
use scripting additions

on run
	tell application "OmniFocus"
		set selectedTasks to omni's getSelectedActions()
		set pName to name of containing project of first item of selectedTasks
		set taskItem to first item of selectedTasks
		set estDuration to estimated minutes of taskItem
		if estDuration is missing value then 
			set estDuration to 30
		else if estDuration is greater than 45 then
			set estDuration to 30
		end if
	end tell
	
	tell application "TimingHelper"
		set isInTiming to omni's isInTimings(pName)
		if not isInTiming then set isInTiming to not (omni's addToTimings(pName) is false)
		if isInTiming then
			set projectItem to front project whose name is pName
			start task with title name of taskItem project projectItem for about estDuration * 60
			try
				open location "focus://focus?minutes=" & estDuration
			on error number -10814
				return "No Focus"
			end try
		else
			return "Cancelled"
		end if
	end tell
	tell application "OmniFocus" to activate
end run
