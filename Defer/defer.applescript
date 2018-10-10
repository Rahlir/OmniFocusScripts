property creator : "Tadeas Uhlir"

use omniLib : script "omnifocuslib"
use scripting additions

on run
	set deferDate to (current date) + 1 * days

	tell application "OmniFocus"
		set deftime to omniLib's getSettingItem("DefaultStartTime")
		set defHours to text 1 thru 2 of deftime as number
		set defMinutes to text 4 thru 5 of deftime as number
		set defTime to defHours * 3600 + defMinutes * 60
		set time of deferDate to defTime
		
		set validSelectedItemsList to omniLib's getSelectedActions()
		repeat with taskOne in validSelectedItemsList
			set defer date of taskOne to deferDate
		end repeat
	end tell
end run
