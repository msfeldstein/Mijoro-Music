-- MijorTunes.applescript
-- MijorTunes

--  Created by Michael Feldstein on 12/17/08.
--  Copyright 2008 __MyCompanyName__. All rights reserved.

on next_song()
	tell application "iTunes"
		next track
	end tell
end next_song

on clicked theObject
	if theObject's name is "next" then
		tell application "iTunes"
			next track
		end tell
	end if
	if theObject's name is "play" then
		tell application "iTunes"
			playpause
		end tell
	end if
	if theObject's name is "prev" then
		tell application "iTunes"
			back track
		end tell
	end if
end clicked

