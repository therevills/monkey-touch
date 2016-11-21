#rem
header:
[quote]

[b]File Name :[/b] Title_Screen
[b]Author    :[/b] Paul "Taiphoz" Grayston
[b]About     :[/b]
The Main screen that lets the player launch all the included mini games.
[/quote]
#end



Import main



#rem
summary:Title Screen Class.
Used to manage and deal with all Tital Page stuff.
#End
Class TitleScreen Extends Screen
	Field background:GameImage
	Field mask:GameImage
	
	Field Icons:GameImage[20]
	Field Thumbs:GameImage[20]
	Field outoforder:GameImage
	
	Field Tile:GameImage
	
	Field selected:Int
		
	Field offsety:Int
	Field startOffsetY:Int
	Field firstTouchY:Int
	Field lastTouchY:Int[] = New Int[3]
	Field thisTouchY:Int
	Field scrollSpeed:Float
	Field scrolling:Bool
	Field menu:SimpleMenu

	Method New()
		name = "Main Screen"
	End
	#rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		Self.background = diddyGame.images.Find("title")
		Self.outoforder = diddyGame.images.Find("ooo")
		Self.mask = diddyGame.images.Find("title_mask")
		Self.Tile = diddyGame.images.Find("game_tile")
		
		selected = 0
		LoadGameIcons()
		
		menu = New SimpleMenu("ButtonOver", "ButtonClick", 0, 200, 30, True, VERTICAL)
		local b:SimpleButton = menu.AddButton("playButton.png", "playButton.png")
		b.MoveTo(275, 394)
		b = menu.AddButton("aboutButton.png", "aboutButton.png")
		b.MoveTo(480, 393)
		
		#IF TARGET="glfw"
			diddyGame.MusicPlay("brain_menu.wav", True)
		#ELSE
			diddyGame.MusicPlay("brain_menu.mp3", True)
		#END
	End
	
	#rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		DrawImage(background.image, 0, 0)
		
		DrawImage(Self.Thumbs[Self.selected].image, 300, 214)
		
		'render the game icons.
		For Local row:Int = 0 To 19
		
			If GameList[row].name <> "????"
				
				If Self.selected = row
					DrawImage(Self.Tile.image, 39, 175 + (row * 58) + offsety, 1)
				Else
					DrawImage(Self.Tile.image, 39, 175 + (row * 58) + offsety, 0)
				End If
				
				DrawImage(Self.Icons[row].image, 83, 203 + (row * 58) + offsety)
				InfoFont.DrawText(GameList[row].name[ .. 12], 110, 205 + (row * 58) + offsety)
			End If
			
		Next
		
		Local stp:Int = 150
		Local gap:Int = 20
		
		TitleFont.DrawText("Game    : ", 353, stp, 1)
		stp += gap
		InfoFont.DrawText("  " + GameList[Self.selected].name, 353, stp, 1)
		stp += gap
		TitleFont.DrawText("Author  : ", 353, stp, 1)
		stp += gap
		InfoFont.DrawText("  " + GameList[Self.selected].author, 353, stp, 1)
		
		stp += gap
		TitleFont.DrawText("Website : ", 353, stp, 1)
		stp += gap
		InfoFont.DrawText("  " + GameList[Self.selected].authorurl, 353, stp, 1)
		
		stp = 272
		TitleFont.DrawText("Game Info", 245, stp, 1)
		
		stp += gap
		InfoFont.DrawTextWidth(GameList[Self.selected].info, 245, stp, 1, 380)

		DrawImage(Self.mask.image, 0, 0, 0)

		menu.Draw()
				
	End

	#rem
	sumary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	and all use input.
	#End
	Method Update:Void()
		Local viewableHeight:Float = 19*58
		Self.selected = (Abs( (-29 + Self.offsety) / 58))' + 1)
		menu.Update()
		If TouchHit() Then
			If MouseOver(51 * SCREENX_RATIO, 147 * SCREENY_RATIO, 186 * SCREENX_RATIO, 279 * SCREENY_RATIO) Then
				firstTouchY = TouchY()
				lastTouchY[0] = firstTouchY
				lastTouchY[1] = firstTouchY
				lastTouchY[2] = firstTouchY
				thisTouchY = firstTouchY
				startOffsetY = offsety
				scrolling = True
				Self.offsety = startOffsetY - firstTouchY + thisTouchY
			End
		Elseif TouchDown() Then
			If scrolling Then
				lastTouchY[2] = lastTouchY[1]
				lastTouchY[1] = lastTouchY[0]
				lastTouchY[0] = thisTouchY
				thisTouchY = TouchY()
				Self.offsety = startOffsetY - firstTouchY + thisTouchY
			End
		Elseif scrolling Then
			scrollSpeed = Float(thisTouchY - lastTouchY[2]) / 3.0
			scrolling = False
		End
		
		If scrollSpeed <> 0 Then Self.offsety += scrollSpeed
		If Self.offsety >= 0 Then
			Self.offsety = 0
			Self.scrollSpeed = 0
		Elseif Self.offsety <= -viewableHeight
			Self.offsety = -viewableHeight
			Self.scrollSpeed = 0
		End
		If scrollSpeed > 0 Then
			scrollSpeed -= 0.1
			If scrollSpeed < 0 Then scrollSpeed = 0
		Elseif scrollSpeed < 0 Then
			scrollSpeed += 0.1
			If scrollSpeed > 0 Then scrollSpeed = 0
		End
		
		'About Button
		If menu.Clicked("aboutButton")
			If TouchHit() Or MouseHit(MOUSE_LEFT)
				FadeToScreen(AboutScr)
			End If
		Endif
		
		'Play Button.
		If menu.Clicked("playButton")
			'clicked play.
			Select Self.selected + 1
				Case 1
					FadeToScreen(Game1Scr)
				Case 2
					FadeToScreen(Game2Scr)
				Case 3
					FadeToScreen(Game3Scr)
				Case 4
					FadeToScreen(Game4Scr)
				Case 5
					FadeToScreen(Game5Scr)
				Case 6
					FadeToScreen(Game6Scr)
				Case 7
					FadeToScreen(Game7Scr)
				Case 8
					FadeToScreen(Game8Scr)
				Case 9
					FadeToScreen(Game9Scr)
				Case 10
					FadeToScreen(Game10Scr)
				Case 11
					FadeToScreen(Game11Scr)
				Case 12
					FadeToScreen(Game12Scr)
				Case 13
					FadeToScreen(Game13Scr)
				Case 14
					FadeToScreen(Game14Scr)
				Case 15
					FadeToScreen(Game15Scr)
				Case 16
					FadeToScreen(Game16Scr)
				Case 17
					FadeToScreen(Game17Scr)
				Case 18
					FadeToScreen(Game18Scr)
				Case 19
					FadeToScreen(Game19Scr)
				Case 20
					FadeToScreen(Game20Scr)
			End
			
		Endif
	
	
	End
	
	#rem
	'summary: LoadGames
	loads the games from a text file, which should make it easier to add new games.
	#END
	Method LoadGameIcons:Void()
		For Local count:Int = 0 To 19
			Self.Icons[count] = diddyGame.images.Find("game" + (count + 1) + "_icon")
			Self.Thumbs[count] = diddyGame.images.Find("game" + (count + 1) + "_thumb")
		Next
	End Method

	
End




Global GameList:miniGame[20]
#rem
	'summary: miniGame
	Class used to just help oganise the game list a litte
#END
Class miniGame
	Field name:String
	Field id:Int
	Field iconname:String
	Field thumbnail:String
	Field author:String
	Field authorurl:String
	Field info:String
End


Function MouseOver:Bool(_x:Int, _y:Int, _w:Int, _h:Int)
	Local result:Bool = False
	
		If TouchX() > _x And TouchX() < (_x + _w) And TouchY() > _y And TouchY() < (_y + _h)
			result = True
		Endif
	
	Return result
End


#rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#end