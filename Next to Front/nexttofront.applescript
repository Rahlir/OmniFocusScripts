property author : "Tadeas Uhlir"
property version : "1.0"
property name : "Next to Front"

use omniLib : script "omnifocuslib"
use scripting additions

on run
	tell application "OmniFocus"
		set nextName to "🗄Next"
		set nextTag to (first item of (get flattened tags of front document whose name is nextName))
		set validSelectedItemsList to omniLib's getSelectedActions()
		repeat with taskOne in validSelectedItemsList
			if name of tags of taskOne contains nextName then
				remove nextTag from tags of taskOne
			else
				add nextTag to front of tag of taskOne
			end if
		end repeat
	end tell
end run
