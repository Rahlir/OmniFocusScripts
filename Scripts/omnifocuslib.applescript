property TAGPRIORITY : {¬
	{name:"Location", priority:3}, {name:"School", priority:2}, {name:"Activity", priority:2}, {name:"Importance", priority:0} ¬
	}

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
