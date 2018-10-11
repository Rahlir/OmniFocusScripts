use omnilib : script "omnifocuslib"
use scripting additions

on run
	tell application "OmniFocus"
		repeat with taskone in omnilib's getSelectedActions()
			repeat with t in (every attribute run of note of taskone where value of its style's attribute "link" is not "")
				set txt to text of t
				set dialogResult to (display dialog "Edit Link" default answer txt with icon 1)
				set text of t to text returned of dialogResult
			end repeat
		end repeat
	end tell
end run
