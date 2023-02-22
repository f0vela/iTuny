iTuny
=====
<b>This project has been discontinued</b>

<b>v 0.5</b>

Source Code for iTuny a launchy companion that allows you to control iTunes.
This app was made with AutoIt 3, the installer interface was made with AutoIt GUI.

Was developed under Windows XP, works on Windows 7 but it needs administrator access to be able to access iTunes.
It needs some work to be used cleanly under Windows 7.

---

This AutoIt is free to distribute and modify to make it better.

	Created			by f0vela
	Collaboration 		by jarethbone
	Inspired 		by Amadawn's iTuny implementation

To use it with Launchy just double click the exe and the installer will popout.

	Install in the desired location.
	Rebuild Launchy's index and you're done.

After install call Launchy and just type: 

	iTunes [command] (Tab) [Parameters if needed]


A list of available commands:

	help			 		Brings you the scripts help
	play					Plays or Pause the selected song
	pause					Pauses the selected song
	stop					Stops iTunes
	next					Plays the next song
	prev					Plays the previous song
	mute					Mute or Unmute iTunes
	track					Shows you the current track info on a GUI with Artwork
	info					Shows you the current track info on a tooltip
	vol						Sets iTunes volume in percent (1-100)%
	visual					Toggles the visualizations on|off. With the full flag it goes fullscreen (not 100% functional)
	star, rate				Rates the current track (1-5)
	show					Shows the iTunes window
	hide					Minimizes the iTunes window
	eq						Toggles the EQ window
	mini					Toggles the Mini Player\
	quit					Exits iTunes
	query					Searches in the library the specified text and creates a temporary playlist to show the results.
							iTunes Query | "multiple space text"
							iTunes Query | nonspacetext
	focus					Finds a playlist on your iTunes, if there's no match an alert is showed.
							iTunes Focus | "multiple space playlist name"
							iTunes Focus | nonspaceplaylistname
	jump					Jumps to the current song and selects it
	shuffle					Enable the Shuffle mode for the current playlist
	create					Creates a playlist with the supplied name
							iTunes Create | "multiple space playlist name"
							iTunes Create | nonspaceplaylistname
	add						Adds the current song to the supplied name playlist
							iTunes Add | "multiple space playlist name"
							iTunes Add | nonspaceplaylistname
	art						Shows the Artwork of the current song
	nextAlbum				Plays the next album
	prevAlbum				Plays the previous album
	tag						Allows advanced tagging on the current song
								Artist
								Album
								Composer
								DiscNumber
								Genre (Rock, HardRock, Pop, etc�)
								Grouping
								PlayedCount
								Track (this is the Track number)
								Year (4 digit)
								VolumeAdjustment (from -100 to 100)
	config					Allows you to config somethings of iTuny
	twitter					Allows you to tweet the current song to Twitter
	pownce					Allows you to post the current song to Pownce
	install (default)		Starts the installer

Comments and requests are welcome.
f0vela at gmail dot com
Hope you like it.
