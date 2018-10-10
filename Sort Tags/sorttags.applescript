property author : "Tadeas Uhlir"
property version : "1.0"
property name : "defer"

use omniLib : script "omnifocuslib"

on run
	tell application "OmniFocus"
		set validSelectedItemsList to omniLib's getSelectedActions()
		set allTags to {}
		repeat with taskOne in validSelectedItemsList
			set taskTagList to tag of taskOne
			set sortedList to reverse of omniLib's simple_sort(taskTagList)
			if sortedList is not equal to taskTagList then
				remove taskTagList from tag of taskOne
				add sortedList to tag of taskOne
			end if
		end repeat
	end tell
end run
