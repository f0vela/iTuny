#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=iTunes.ico
#AutoIt3Wrapper_outfile=iTunes Control.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=http://www.hiddensoft.com/autoit3/compiled.html
#AutoIt3Wrapper_Res_Description=AutoIt v3 Compiled Script
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/rel /tc 1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#comments-start ***********************************************************************
	
	This application was created by amadawn and modified by f0vela
	to report bugs please post them in the sourceforge forums:
	https://sourceforge.net/forum/forum.php?forum_id=677087
	or on my blog:
	http://f0vela.wordpress.com/2007/12/29/ituny-v04-released/
	
	Or send them by email to f0vela [at] gmail [dot] com
	
	The nextAlbum and previousAlbum code was provided by jarethbone
	from the sourceforge forums.
	
	Software and Images provided under GPLv2 License, please respect it.
	
#comments-end *************************************************************************
; *************************************************************************************
; Variables Section.
; $iTunesApp is the iTunes Object.
;
; by default (if double clicked) the iTunes Control will do
; the action defined on the $sAction variable which is "install"
; *************************************************************************************
Dim $iTunesApp = ObjCreate("iTunes.Application")
Dim $sAction = "install" 
Dim $sActionParam = ""
Dim $sActionParam2 = ""
Dim $errors = ""
Dim $TTF = 3
Dim $TTF_T = 3000
Dim $AWF = 4
Dim $AWF_T = 4000
Dim $pw = "~#[.ab!@MNmn6UVuv2-<EFef`$KLkl7&\XwABW{,CDcdx1+>}/GHgh9%]IJij8^|YZyz0=?*:OPop 5(""QRqr4);STst3_'" 
Dim $iniPath = 'iTuny.ini' 
; *************************************************************************************
; User configurations read from the iTuny.ini file
; to change the iTuny.ini file location just change the $iniPath var
; *************************************************************************************
$TTF = IniReadSection($iniPath, 'Tooltip')
$TTF_T = $TTF[1][1]
$TTF = $TTF[1][1] * 1000
$AWF = IniReadSection($iniPath, 'ArtWindow')
$AWF_T = $AWF[1][1]
$AWF = $AWF[1][1] * 1000
$Twitter = IniReadSection($iniPath, 'Twitter')
If IsArray($Twitter) Then $Twitter_u = $Twitter[1][1]
If IsArray($Twitter) Then $Twitter_p = RC4 ($Twitter[2][1], $pw, 1)
$Pownce = IniReadSection($iniPath, 'Pownce')
If IsArray($Pownce) Then $Pownce_u = $Pownce[1][1]
If IsArray($Pownce) Then $Pownce_p = RC4 ($Pownce[2][1], $pw, 1)
$Network = IniReadSection($iniPath, 'Network')
If IsArray($Network) Then $proxy_server = $Network[1][1]
If IsArray($Network) Then $proxy_port = $Network[2][1]
If IsArray($Network) Then $proxy_u = $Network[3][1]
If IsArray($Network) Then $proxy_p = RC4 ($Network[4][1], $pw, 1)
If IsArray($Network) Then $proxy_enabled = $Network[5][1]
$Snarl = IniReadSection($iniPath, 'Snarl')
If IsArray($Snarl) Then $Snarl_e = $Snarl[1][1]
If $Snarl_e = 1 Then
	$NL = @CRLF
Else
	$NL = @CR
EndIf
; *************************************************************************************
; Include Files
; *************************************************************************************
#include <GUIConstants.au3>
#include <A3LGDIPlus.au3>
#include <A3LScreenCap.au3>
#include <iTunyFuncs.au3>
; *************************************************************************************
; This section reads the command line parameters sended to the iTunes Control.exe it accepts
; 3 parameters at max and 1 at min (as said before install is the default action)
; *************************************************************************************
If $CmdLine[0] > 0 Then
	$sAction = $CmdLine[1]
	If $CmdLine[0] > 1 Then
		$sActionParam = $CmdLine[2]
	EndIf
	If $CmdLine[0] > 2 Then
		$sActionParam2 = $CmdLine[3]
	EndIf
EndIf
; *************************************************************
; Checks if iTunes is well installed or is Actually installed
; Added on April 27, 2008 after my failed update of iTunes through
; the Apple Software Updater from version 7.6.0.9 to version 7.6.2.9
; on Windows Vista (be careful with the updates on Vista,
; if this happened to you on my blog I have the solution)
; *************************************************************
If Not IsObj($iTunesApp) Then
	$badInstall = "---------------------------------------------------------------------" & $NL & _
			"   You have a bad iTunes installation or don't have iTunes at all." & $NL & _
			"----------------------------------------------------------------------" & $NL & $NL & _
			"1. If you don't have iTunes installed, please install it and try again" & $NL & $NL & _
			"2. If you have iTunes installed, please repair the installation with " & $NL & _
			"    the iTunes installer" & $NL & $NL & _
			"3. If none of the above fixes your problem please take a look at this post " & $NL & $NL & _
			"   http://f0vela.wordpress.com/2008/04/29/aleluya-itunes-works-again/" & $NL & $NL & _
			"    the chances are that your installation have some problems " & $NL & _
			"    and the installer doesn't have permissions to register some " & $NL & _
			"    parts of iTunes" & $NL
	
	MsgBox(8208, "iTuny :: I found a problem", " " & $badInstall & " ")
Else
	Switch (StringLower($sAction))
		Case "show" 
			If $iTunesApp.BrowserWindow.Visible = 0 Then $iTunesApp.BrowserWindow.Visible = 1
		Case "hide" 
			If $iTunesApp.BrowserWindow.Minimized = 0 Then $iTunesApp.BrowserWindow.Minimized = 1
		Case "play", "playpause" 
			$iTunesApp.PlayPause ()
			TimeTool (iTunesPlayerStatus ($iTunesApp.PlayerState ()), $TTF, "iTuny :: Message", 4)
		Case "pause" 
			$iTunesApp.Pause ()
		Case "next", "nexttrack" 
			$iTunesApp.NextTrack ()
			showTrackInfo ()
		Case "prev", "prevtrack", "previous" 
			$iTunesApp.PreviousTrack ()
			showTrackInfo ()
		Case "stop" 
			$iTunesApp.Stop ()
		Case "quit", "exit" 
			$iTunesApp.Quit ()
		Case "jump" 
			$iTunesApp.CurrentTrack.Reveal ()
		Case "star", "rate", "rating" 
			Dim $nNewRate = Execute($sActionParam)
			If $nNewRate <= 5 And $nNewRate >= 0 Then
				If IsNumber($nNewRate) Then
					$nNewRate = $nNewRate * 20
					Dim $track = $iTunesApp.CurrentTrack
					$track.Rating = $nNewRate
				EndIf
			Else
				$errors = "Please rate this song with a number between 0 and 5" 
			EndIf
			$errors = "New Rate: " & starRating ($nNewRate / 20)
		Case "volume", "vol" 
			Dim $nNewVolume = Execute($sActionParam)
			If IsNumber($nNewVolume) Then
				If $nNewVolume > 100 Then $nNewVolume = 100
				If $nNewVolume < 0 Then $nNewVolume = 0
				$iTunesApp.SoundVolume = $nNewVolume
			Else
				$errors = "Please use a number to set the volume." 
			EndIf
		Case "mute", "unmute" 
			If $iTunesApp.Mute () Then
				$iTunesApp.Mute = 0
				$errors = "iTunes was released" 
			Else
				$iTunesApp.Mute = 1
				$errors = "iTunes is muted" 
			EndIf
			
		Case "info" 
			showTrackInfo ()
		Case "track" 
			trackInfoScreen ()
		Case "art" 
			artScreen ()
		Case "mini" 
			If $iTunesApp.BrowserWindow ().MiniPlayer = 0 Then
				$iTunesApp.BrowserWindow ().MiniPlayer = -1
			Else
				$iTunesApp.BrowserWindow ().MiniPlayer = 0
			EndIf
		Case "eq" 
			$eq = $iTunesApp.EQWindow ()
			If $eq.Visible = 0 Then
				$eq.Visible = 1
			Else
				$eq.Visible = 0
			EndIf
		Case "query", "search" 
			; Gets the searchData
			$searchData = $sActionParam
			$searchField = $sActionParam2
			; If the search field is specify then it uses it to filter the playlist
			If $sActionParam2 <> "" And $sActionParam <> "" Then
				$searchField = $sActionParam
				$searchData = $sActionParam2
			EndIf
			
			$gpl = $iTunesApp.LibrarySource ()
			$pl = $gpl.Playlists ().item (1) ; Searches in the whole iTunes library
			If $searchField <> "" Then
				$ar = $pl.Search ($searchData, 5)
			Else
				$ar = $pl.Search ($searchData, 1)
			EndIf
			$iTR = $gpl.Playlists ().ItemByName ("iTunyResults")
			If IsObj($iTR) Then
				$iTR.Delete ()
			EndIf
			$thisPl = $iTunesApp.CreatePlaylistInSource ("iTunyResults", $gpl)
			$co = 0
			For $it In $ar
				$thisPl.AddTrack ($it)
			Next
			If $it = 0 Then
				$errors = "Couldn't find any tracks with your search query" 
			Else
				$thisPl.Reveal
				If $thisPl.Visible = 0 Then $thisPl.Visible = 1
			EndIf
		Case "pl", "focus", "goto" 
			Dim $focuspl
			If $sActionParam = "" Then
				$errors = "Please specify a playlist name" 
			Else
				$focus = $iTunesApp.LibrarySource ()
				If getPL ($sActionParam) = "" Then
					$errors = "Couldn't find a playlist that matched your term" 
				Else
					$focuspl = $focus.Playlists.item (getPL ($sActionParam))
					$focuspl.Reveal ()
					If $focuspl.Visible = 0 Then
						$focuspl.Visible = 1
					EndIf
				EndIf
			EndIf
		Case "shuffle" 
			$shuffle = $iTunesApp.LibrarySource ()
			;$activePL = getActivePL ()
			
			$pl = $shuffle.Playlists.Item (2)
			If ($pl.Shuffle = -1) Then
				$pl.Shuffle = 0
				$errors = "Shuffle is off" 
			Else
				$pl.Shuffle = -1
				$errors = "Shuffle is on" 
			EndIf
			
		Case "create" 
			If $sActionParam = "" Then
				$errors = "Please specify a playlist name to create" 
			Else
				$gpl = $iTunesApp.LibrarySource ()
				$thisPl = $iTunesApp.CreatePlaylistInSource ($sActionParam, $gpl)
				$errors = "The playlist " & $sActionParam & " has been created" 
			EndIf
		Case "add" 
			If $sActionParam <> "" Then
				$Ct = $iTunesApp.CurrentTrack ()
				$gpl = $iTunesApp.LibrarySource ()
				If IsObj($gpl.Playlists.itemByName ($sActionParam)) Then
					$pl = $gpl.Playlists.itemByName ($sActionParam)
					$pl.AddTrack ($Ct)
					$errors = "Track added to " & $sActionParam & " playlist" 
				Else
					$errors = "The playlist you specified doesn't exist or is mistyped. Please try again." 
				EndIf
			Else
				$errors = "Please specify a playlist name in which you want to put the current song" 
			EndIf
		Case "visuals" 
			If $iTunesApp.VisualsEnabled = 0 Then
				$iTunesApp.VisualsEnabled = 1
			Else
				$iTunesApp.VisualsEnabled = 0
			EndIf
			If $sActionParam <> "" And $sActionParam = "full"  Then
				$iTunesApp.FullScreenVisuals = 1
			Else
				$iTunesApp.FullScreenVisuals = 0
			EndIf
		Case "tag" 
			Dim $tagField = $sActionParam
			Dim $tagValue = $sActionParam2
			Dim $currentTrack = $iTunesApp.CurrentTrack ()
			If (StringCompare($tagField, "Artist", 2) = 0) Then
				$currentTrack.Artist () = $tagValue
				TimeTool ("Artist Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "Album", 2) = 0) Then
				$currentTrack.Album () = $tagValue
				TimeTool ("Album Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "Name", 2) = 0) Then
				$currentTrack.Name () = $tagValue
				TimeTool ("Name Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "Composer", 2) = 0) Then
				$currentTrack.Composer () = $tagValue
				TimeTool ("Composer Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "DiscNumber", 2) = 0) Then
				$currentTrack.DiscNumber () = $tagValue
				TimeTool ("Disc Number Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "Genre", 2) = 0) Then
				$currentTrack.Genre () = $tagValue
				TimeTool ("Genre Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "Grouping", 2) = 0) Then
				$currentTrack.Grouping () = $tagValue
				TimeTool ("Grouping Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "PlayedCount", 2) = 0) Then
				$currentTrack.PlayedCount () = $tagValue
				TimeTool ("Played Count Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "PlayCount", 2) = 0) Then
				$currentTrack.PlayedCount () = $tagValue
				TimeTool ("Played Count Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "Track", 2) = 0) Then
				$currentTrack.TrackNumber () = $tagValue
				TimeTool ("Track Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "Year", 2) = 0) Then
				$currentTrack.Year () = $tagValue
				TimeTool ("Year Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
			EndIf
			If (StringCompare($tagField, "VolumeAdjustment", 2) = 0) Then
				If ($tagValue > -100 And $tagValue < 100) Then
					$currentTrack.VolumeAdjustment () = $tagValue
					TimeTool ("Volume Adjustment Changed to " & $tagValue, $TTF, "iTuny :: Message", 4)
				Else
					$errors = "The volume adjustment value ranges from -100 to 100" 
				EndIf
			EndIf
		Case "nextAlbum"  	;Code by jarethbone
			Dim $track = $iTunesApp.CurrentTrack ().Name ()
			Dim $trackColl = $iTunesApp.CurrentPlaylist ().Tracks ()
			Dim $found = False
			Dim $foundTrack = False
			Dim $currentAlbum
			For $trackCount = 1 To $trackColl.Count ()
				If $found And Not ($currentAlbum = $trackColl.ItemByPlayOrder ($trackCount).Album ()) Then
					Dim $nextTrack = $trackColl.ItemByPlayOrder ($trackCount)
					$foundTrack = True
					$trackCount = $trackColl.Count () + 1
				ElseIf Not ($found) And $track = $trackColl.ItemByPlayOrder ($trackCount).Name () Then
					Dim $currentAlbum = $trackColl.ItemByPlayOrder ($trackCount).Album ()
					$found = True;
				EndIf
			Next
			If $foundTrack Then
				$nextTrack.Play ()
				showTrackInfo ()
			EndIf
		Case "prevAlbum"  	;Code by jarethbone
			Dim $track = $iTunesApp.CurrentTrack ().Name ()
			Dim $trackColl = $iTunesApp.CurrentPlaylist ().Tracks ()
			Dim $found = False
			Dim $foundPrev = False
			Dim $foundTrack = False
			Dim $previousAlbum
			For $trackCount = $trackColl.Count () To 1 Step - 1
				If $foundPrev And Not ($previousAlbum = $trackColl.ItemByPlayOrder ($trackCount).Album ()) Then
					Dim $nextTrack = $trackColl.ItemByPlayOrder ($trackCount + 1)
					$foundTrack = True
					$trackCount = 1
				ElseIf $found And Not ($currentAlbum = $trackColl.ItemByPlayOrder ($trackCount).Album ()) Then
					Dim $previousAlbum = $trackColl.ItemByPlayOrder ($trackCount).Album ()
					$foundPrev = True
					If $trackCount = 1 Then
						Dim $nextTrack = $trackColl.ItemByPlayOrder ($trackCount)
						$foundTrack = True
					EndIf
				ElseIf Not ($found) And $track = $trackColl.ItemByPlayOrder ($trackCount).Name () Then
					Dim $currentAlbum = $trackColl.ItemByPlayOrder ($trackCount).Album ()
					$found = True
				EndIf
			Next
			If $foundTrack Then
				$nextTrack.Play ()
				showTrackInfo ()
			EndIf
		Case "help", "?", "-?", "-help" 
			Dim $help
			$help = "The available commands are:" & $NL & $NL & _
					" - help,-help,?,-?" & @TAB & @TAB & "--brings this dialog" & $NL & _
					" - play" & $NL & _
					" - pause" & $NL & _
					" - stop" & $NL & _
					" - next" & $NL & _
					" - prev" & $NL & _
					" - mute" & $NL & _
					" - track" & @TAB & @TAB & @TAB & "New track info with AlbumArt" & $NL & _
					" - info" & @TAB & @TAB & @TAB & "Classic track info on a tooltip balloon" & $NL & _
					" - volume,vol" & @TAB & @TAB & "#" & $NL & _
					" - visual" & @TAB & @TAB & @TAB & """full""" & $NL & _
					" - star,rate,rating" & @TAB & @TAB & "1 to 5" & $NL & _
					" - show" & $NL & _
					" - hide" & $NL & _
					" - eq" & $NL & _
					" - mini" & $NL & _
					" - quit" & $NL & _
					" - jump" & $NL & _
					" - search,query" & @TAB & @TAB & """text to seach""" & $NL & _
					" - pl,focus,goto" & @TAB & @TAB & """playlist to focus""" & $NL & _
					" - shuffle " & $NL & _
					" - create" & @TAB & @TAB & @TAB & """playlist to create""" & $NL & _
					" - add" & @TAB & @TAB & @TAB & """playlist where to add the current song""" & $NL & _
					" - art" & @TAB & @TAB & @TAB & """Shows the current song's artwork""" & $NL & _
					" - nextAlbum" & @TAB & @TAB & @TAB & """Jumps to the next album""" & $NL & _
					" - prevAlbum" & @TAB & @TAB & @TAB & """Jumps to the previous album""" & $NL & _
					" - tag" & @TAB & @TAB & @TAB & """Lets you tag the current playing song""" & $NL & _
					" - config" & @TAB & @TAB & @TAB & """To configure some iTuny settings""" & $NL & _
					" - install (default)" & $NL & _
					" ---------------------------------------------------------------------- " & $NL & $NL
			ToolTip($help, @DesktopWidth - (@DesktopWidth / 1.5), @DesktopHeight - (@DesktopHeight / 1.3), "iTuny Help", 4, 4)
			Sleep(6000)
			
		Case "config" 
			configWindow ()
			
		Case "twitter" 
			$twitter_text = "Listening: " & $iTunesApp.CurrentTrack ().Name () & " - " & $iTunesApp.CurrentTrack ().Artist () & " (" & $iTunesApp.CurrentTrack ().Album () & ")" 
			$THTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
			
			$errors = twince ($twitter_text, $THTTP, "twitter")
			
		Case "pownce" 
			$pownce_text = "Listening: " & $iTunesApp.CurrentTrack ().Name () & " - " & $iTunesApp.CurrentTrack ().Artist () & " (" & $iTunesApp.CurrentTrack ().Album () & ")" 
			$PHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
			
			$errors = twince ($pownce_text, $PHTTP, "pownce")
		Case "party" 
			If $sActionParam = "off"  Then
				; jumps to the main library and plays the first song
				$partyshuffle = $iTunesApp.LibrarySource ()
				$pl = $partyshuffle.Playlists.Item (2)
				$pl.PlayFirstTrack ()
				$iTunesApp.CurrentTrack.Reveal ()
				$errors = "Party is off..." 
			Else
				; jumps to the party shuffle library and starts playing the next song
				$partyshuffle = $iTunesApp.LibrarySource ()
				$pl = $partyshuffle.Playlists.Item (5)
				$pl.PlayFirstTrack ()
				$iTunesApp.CurrentTrack.Reveal ()
				$errors = "Let's Party On!" 
			EndIf
			
		Case "install" 
			#region --- GuiBuilder code Start ---
			; Script generated by AutoBuilder 0.6 Prototype
			GUICreate("iTuny :: iTunes Control", 269, 261, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
			$Button_3 = GUICtrlCreateButton("Cancel", 180, 230, 70, 20)
			$Button_4 = GUICtrlCreateButton("Install", 100, 230, 70, 20)
			$Group_1 = GUICtrlCreateGroup("Exe Location", 20, 20, 230, 90)
			$Radio_5 = GUICtrlCreateRadio("Current", 30, 40, 210, 20)
			$Radio_6 = GUICtrlCreateRadio("Launchy Utilities", 30, 60, 210, 20)
			$Radio_7 = GUICtrlCreateRadio("Other", 30, 80, 210, 20)
			$Group_2 = GUICtrlCreateGroup("Links Location", 20, 130, 230, 90)
			$Radio_8 = GUICtrlCreateRadio("Current", 30, 150, 210, 20)
			$Radio_9 = GUICtrlCreateRadio("Launchy Utilities", 30, 170, 210, 20)
			$Radio_10 = GUICtrlCreateRadio("Start Menu", 30, 190, 210, 20)
			GUISetState()
			While 1
				$msg = GUIGetMsg()
				Select
					Case $msg = $GUI_EVENT_CLOSE
						ExitLoop
					Case $msg = $Button_3
						ExitLoop
					Case $msg = $Button_4
						Dim $linkNames[32]
						Dim $installDir, $appDir
						$return = 9
						$returnLinks = 9
						$linkNames[0] = "Show" 
						$linkNames[1] = "Hide" 
						$linkNames[2] = "Play" 
						$linkNames[3] = "Pause" 
						$linkNames[4] = "Next" 
						$linkNames[5] = "Prev" 
						$linkNames[6] = "Stop" 
						$linkNames[7] = "Quit" 
						$linkNames[8] = "Star" 
						$linkNames[9] = "Rate" 
						$linkNames[10] = "Vol" 
						$linkNames[11] = "Mute" 
						$linkNames[12] = "Track" 
						$linkNames[13] = "Mini" 
						$linkNames[14] = "EQ" 
						$linkNames[15] = "Query" 
						$linkNames[16] = "Focus" 
						$linkNames[17] = "Shuffle" 
						$linkNames[18] = "Create" 
						$linkNames[19] = "Add" 
						$linkNames[20] = "Visuals" 
						$linkNames[21] = "Help" 
						$linkNames[22] = "Jump" 
						$linkNames[23] = "Info" 
						$linkNames[24] = "Art" 
						$linkNames[25] = "NextAlbum" 
						$linkNames[26] = "PrevAlbum" 
						$linkNames[27] = "Tag" 
						$linkNames[28] = "Config" 
						$linkNames[29] = "Twitter" 
						$linkNames[30] = "Pownce" 
						$linkNames[31] = "Party" 
						If GUICtrlRead($Radio_5, 0) = 1 Then $appDir = @WorkingDir & "\" 
						If GUICtrlRead($Radio_6, 0) = 1 Then $appDir = @ProgramFilesDir & "\Launchy\Utilities\" 
						If GUICtrlRead($Radio_7, 0) = 1 Then $appDir = InputBox("Directorio", "Where do you want to install?", @MyDocumentsDir & "\")
						If GUICtrlRead($Radio_8, 0) = 1 Then $installDir = @WorkingDir & "\" 
						If GUICtrlRead($Radio_9, 0) = 1 Then $installDir = @ProgramFilesDir & "\Launchy\Utilities\" 
						If GUICtrlRead($Radio_10, 0) = 1 Then $installDir = InputBox("Directorio", "Please change the ""Programs"" entry if your windows is in another language.", @StartMenuDir & "\Programs\iTuny\")
						$return = FileCopy("iTunes Control.exe", $appDir & "iTunes Control.exe", 1 + 8)
						$returnNA = FileCopy("NA.jpg", $appDir & "NA.jpg", 1 + 8)
						$returnINI = FileCopy("iTuny.ini", $appDir & "iTuny.ini", 1 + 8)
						; Added to copy the Snarl command app that sends the messages *********
						$returnSnarl = FileCopy("Snarl_CMD.exe", $appDir & "Snarl_CMD.exe", 1 + 8)
						; *********************************************************************
						If $return = 0 Then
							MsgBox(0, "iTuny :: Install", "I couldn't install iTuny on the specified location." & $NL & $NL & _
									"If you are using Windows Vista, try executing the exe as Administrator or install it on another location.")
						EndIf
						If $returnNA = 0 Then
							MsgBox(0, "iTuny :: Install", "I couldn't install the No Artwork Image on the specified location." & $NL & $NL & _
									"If you are using Windows Vista, try executing the exe as Administrator or install it on another location.")
						EndIf
						For $a In $linkNames
							If FileExists($installDir & "iTunes " & $a & ".lnk") Then
								$errors = "iTuny installed Correctly" 
								$returnLinks = 1
							Else
								$returnLinks = FileCreateShortcut($appDir & "iTunes Control.exe", "iTunes " & $a, $appDir, StringLower($a))
								FileMove("iTunes " & $a & ".lnk", $installDir & "iTunes " & $a & ".lnk", 1 + 8)
							EndIf
						Next
						If $return = 1 And $returnLinks = 1 Then
							MsgBox(0, "Success", "iTuny has been installed correctly", 4000)
							ExitLoop
						Else
							If $return = 0 Then MsgBox(0, "Ups! something happened", "Not all the iTuny components could be installed." & $NL & "The Program couldn't be copied to it's location", 4000)
							If $returnLinks = 0 Then MsgBox(0, "Ups! something happened", "Not all the iTuny components could be installed." & $NL & "The Links couldn't be created to it's location", 4000)
						EndIf
					Case Else
						;
				EndSelect
			WEnd
			GUIDelete()
			Exit
			#endregion --- GuiBuilder generated code End ---
		Case Else
			$errors = "Unknow command, please check the help." 
	EndSwitch
EndIf
If $errors <> "" Then TimeTool ($errors, $TTF, "iTuny :: Message", 4)