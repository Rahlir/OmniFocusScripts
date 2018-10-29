use omnilib : script "omnifocuslib"
use scripting additions

on run
	tell application "OmniFocus"
		set timeList to omnilib's getDuration(15)
		set hrs to first number of timeList as string
		set mins to second number of timeList as string
		display alert "Estimated Duration of Selected Tasks" message hrs & " hours and " & mins & " minutes remaining" giving up after 5
	end tell
end run
