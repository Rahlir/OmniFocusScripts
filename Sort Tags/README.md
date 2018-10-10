# Sort Tags

I have hacked together a simple script that sorts selected action's tags based
on a predefined order of tag categories. This is done to enhance structure in
all perspectives especially in perspectives where you have a lot of actions
with a long list of tags.

## How this works

For instance, imagine that you have a tag for **Activity**, **School**,
**Location**, **Importance** (my current setup) and then some other
miscellaneous tags. This script sorts those tags for selected actions so that
**Activity** appears first, **Location** second, and **Importance** always
last. Simply select all the actions you want sorted and click on the **Sort
Tags** button in toolbar.  To demonstrate, I have included some pictures from
my own setup: 

<img src="https://Rahlir.github.io/Assets/tags.png" width="200"/>

**Before:**
<img src="https://Rahlir.github.io/Assets/before.png" width="900"/>
**After Running the Script:**
<img src="https://Rahlir.github.io/Assets/projects.png" width="900"/>

## Configuration

By default, the ordering is based on my own workflow. Obviously, everyone has
different tags and different tag categories/hierarchy. To use this script with
your own setup, change the first statement of the _omnifocuslib.applescript_.
So, for example if you have tag categories called **People** and **Energy
Level** and you want the tags belonging to **People** to be always first and
**Energy Level** to be always last, the first statement of
_omnifocuslib.applescript_ would look like:

```applescript
property TAGPRIORITY : {¬
    {name:"People", priority:2}, {name: "Energy Level", priority:0}¬
    }
```

Note that label categories that are not specified in the script will always
have a priority = 1.

## Installation

After you have changed the `TAGPRIORITY` property, you have to compile the
script. This is essentially the same process as outlined in the main README.
After you compile the script, copy it to the OmniFocus 3 script directory.
