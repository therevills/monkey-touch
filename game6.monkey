#Rem
header:
[quote]

[b]File Name :Eggs
[b]Author    :Adam Fryman
[b]About     :Match up as many eggs as you can in the time provided

[/quote]
#End



Import main
Global BunnySprite:Image
Global EggSprite:Image[10]
Global Game6Debug:Bool = True
#Rem
summary:Title Screen Class.
Used To manage And deal with all Tital Page stuff.
#End
Class Game6Screen Extends Screen
Field board:Fry_ClassBoard
Field gem:Fry_ClassGem[102]
Field input:Fry_ClassInput
Field Score:Int
Field timer:Int
Field InGame:Int = 0 '0 main menu 1 ingame 2 gameover 3 options
Field CurrentSound:Int = 1
Field SoundTimer:Int 'used to dertermin which sound should play and also what the current score multiplier is


	
	Method New()
		name = "Game 6 Screen"
		Local gameid:Int = 6
		GameList[gameid - 1] = New miniGame
		GameList[gameid - 1].id = gameid - 1
		GameList[gameid - 1].name = "Eggs"
		GameList[gameid - 1].iconname = "game" + gameid + "_icon"
		GameList[gameid - 1].thumbnail = "game" + gameid + "_thumb"
		GameList[gameid - 1].author = "Adam Fryman"
		GameList[gameid - 1].authorurl = "nerionx.net"
		GameList[gameid - 1].info = "Match up as many eggs as you can in the time provided"
	End
	#Rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		diddyGame.screenFade.Start(50, False)	


		'Load up assets
		EggSprite[1] = LoadImage("graphics/game6/game6_egg1.png")
		EggSprite[2] = LoadImage("graphics/game6/game6_egg2.png")
		EggSprite[3] = LoadImage("graphics/game6/game6_egg3.png")
		EggSprite[4] = LoadImage("graphics/game6/game6_egg4.png")
		EggSprite[5] = LoadImage("graphics/game6/game6_egg6.png")
		EggSprite[6] = LoadImage("graphics/game6/game6_egg6.png")
		BunnySprite = LoadImage("graphics/game6/game6_bunny.png")
		'*****************
		
		board = New Fry_ClassBoard
		input = New Fry_ClassInput
		timer = Millisecs()
		Score = 0
		
				
		
		SetUpdateRate(30)
		Seed = Millisecs()	
		GenerateGems
		
	End
	
	#Rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		'TitleFont.DrawText(self.name, 320, 240,2)
		If InGame = 0 Then
			Cls(255,255,255)
			DrawText("Unfinished project: Click to Start",250,250)
		Endif
		If InGame = 1
			Cls(255,255,255)
			board.DrawBoard
			Local a:Int
			For a = 0 To 99
				gem[a].DrawGem(a)
			Next
			DrawText("Score: " + Score,450,410)
			DrawText(60 -((Millisecs() - timer) /  1000),450,200)
			board.DrawOverlay
		
		Endif
	
		If InGame = 2 Then
			Cls(255,255,255)
			DrawText("GAMEOVER",250,250)
			DrawText("Score: " + Score,240,280)
		Endif
	End

	#Rem
	sumary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	And all use input.
	#End
	Method Update:Void()
		'
		If KeyHit(KEY_ESCAPE)
			diddyGame.nextScreen = TitleScr
			diddyGame.screenFade.Start(50, True)
		Endif
		
		If InGame = 0 Then
			If KeyHit(KEY_SPACE) Or MouseHit(MOUSE_LEFT) Then
				Score = 0
				timer = Millisecs()
				InGame = 1
			Endif
		Endif
	
		If InGame = 1 Then
			If MouseHit(MOUSE_LEFT) Then 
				If input.OnClick(board.GridSize,board.GridOffset,board.NumCells) = 1 Then CheckGems(input.SelCell,input.SelX,input.SelY) 'Grid was clicked cell info recovered, check gems
			Endif 
		
			If (60 -((Millisecs() - timer) /  1000)) < 1 Then 
				InGame = 2
			Endif
		
			If KeyHit(KEY_SPACE) Then
				Start
			Endif
	Endif
	
	If InGame = 2
		If KeyHit(KEY_SPACE) Or MouseHit(MOUSE_LEFT) Then 
			InGame = 0
		Endif
	Endif
		
	End Method
	Method GenerateGems()
		Local a:Int = 0
		For a = 0 To 99
			gem[a] = New Fry_ClassGem
			gem[a].Generate		
		Next
	End
Method CheckGems:Int(Cell:Int,X:Int,Y:Int) 'Perform this check when the grid has been clicked
		Local a:Int
		Local Changed:Bool = False
		Local NoAction:Bool = False
	
		gem[Cell].InAction = 1 'Set the clicked cell to the first action cell
		
		NoAction = False
		While NoAction = False		
		Changed = False
		If gem[a].InAction = 1 Then
			gem[a].InAction = 2
			If a < 90 And Y <> 9
				If gem[a+10].Type = gem[a].Type And gem[a+10].InAction <> 2 Then 
					gem[a+10].InAction = 1
					Changed = True
				Endif		
			Endif
		
			If a > 9 And Y <> 0 Then
				If gem[a-10].Type = gem[a].Type And gem[a-10].InAction <> 2  Then 
					gem[a-10].InAction = 1
					Changed = True
				Endif
			Endif
			If a < 99 And X <> 10 Then 
				If gem[a+1].Type = gem[a].Type  And gem[a+1].InAction <> 2 Then 
					gem[a+1].InAction = 1
					Changed = True
				Endif
			Endif
			If a > 0 And X <> 1 Then
				If gem[a-1].Type = gem[a].Type And gem[a-1].InAction <> 2 Then 
					gem[a-1].InAction = 1
					Changed = True
				Endif
			Endif
		Endif
			a = a + 1
			
		If Changed = True Then 
			NoAction = False
			a = 0
		Endif
		
		If Changed = False And a = 100 Then
			NoAction = True
		Endif

			
		Wend
		DestroyCells

	End
	
	Method DestroyCells()
		Local a:Int
		Local b:Int
		Local c:Int
		Local count:Int = 0
		count = 0
	'Count the number of cells to be destroyed before destroying them
		For a = 0 To 99
			If gem[a].InAction = 2 Then count = count + 1
		Next
			
		
		'If there are 3 or more cells next to each other then start destorying them
		If count > 2 Then 
			For a = 0 To 99
				If a > -1 Then
					If gem[a].InAction=2 Then 
	
						gem[a].InAction = 0
'						
							b = a
						
							For c = 0 To 10
						'Copy the cells above to the one below
							If b > 9 Then 
								gem[b].Type = gem[b-10].Type
								gem[b].Special = gem[b-10].Special
							Else
								gem[b].Generate 'No cell above so generate a new one
							Endif
										
							
							If b > 9 Then b = b - 10
						
							Next
					Endif
				Endif
		
		
			
			gem[a].InAction = 0
		Next
	'	Print "Number of cells to destroy: " + count
		Score = Score + (count * CurrentSound)
	Else
		'No cells where destroyed but the clicked cell and possible ones next to it are selected, so lets deactivate them
		For a = 0 To 99
			gem[a].InAction = 0
		Next
		timer = timer - 2000 'If person hits a cell without enough eggs the they lose 2 seconds
	'	Print "Not enough cells selected"
	Endif
'	
	End
	
End


Class Fry_ClassBoard
Field GridSize:Int = 40
Field NumCells:Int = 11
Field GridOffset:Int = 30
	Method DrawBoard()
		Local a:Int = 0
		Local b:Int = 0
	
				
		
		
			SetColor(0,0,0)
		For a = 1 To NumCells
			DrawLine(a*40, GridSize,(a*40),GridSize*NumCells)
			DrawLine(GridSize,a*40,GridSize*NumCells,a*40)
		Next
		SetColor(255,255,255)
		DrawImage(BunnySprite,450,350)
	

		
	End
	
	Method DrawOverlay()
	End
End

Class Fry_ClassGem
Field Type:Int
Field Special:Bool
Field OffSet:Int = 42
Field InAction:Int = 0 'Flagged when the cell is involved in the current move

Method DrawGem(GemNum:Int)
	'Work out where on the grid the gem should be drawn
	Local a:Int = 0
	Local tempgem:Int
	tempgem = GemNum
	While GemNum > 9
		 GemNum = GemNum - 10
		 a = a + 1
	Wend
	SetColor(255,255,255)
	DrawImage(EggSprite[Type],(GemNum*40)+OffSet,(a*40)+OffSet,0,.9,.9)
	'DrawText(tempgem,(GemNum*30)+OffSet,(a*30)+OffSet)
End

Method Generate()
	'Create a gem with random properties
	Local a:Int
	a = Rnd(1,6)
	Type = a
	Special = False
End


End

Class Fry_ClassInput
Field X:Int
Field Y:Int
Field SelX:int 
Field SelY:Int
Field SelCell:Int
Field RetVal:int

	Method OnClick:int(CellSize:Int,Offset:int,NumCells:int)
		X = MouseX()
		Y = MouseY()
		RetVal = 0
		Offset = Offset + 10 'Offset is slightly off
		If X > Offset And X < (Offset) + (CellSize * (NumCells - 1)) And Y > Offset And Y < Offset + (CellSize * (NumCells - 1)) Then 'Quick test to see if cursor is on grid
			Local a:Int = 0
			SelX = 1 'initialise selection
			SelY = 0
			'Gives us cordinates for the mouse position stored in SelX SelY
			For a = 1 to NumCells
				if X > Offset + (CellSize * a) Then SelX = SelX + 1
				if Y > Offset + (CellSize * a) Then SelY = SelY + 1
			
				If SelY > 9 Then SelY = 0 'Dont allow a selection if the mouse is off the screen
				If SelX > 10 Then SelX = 0 'Dont allow a selection if the mouse is off the screen
			
			Next	
			SelCell = (SelY * 10 + SelX) - 1
		'	Print "You selected Grid X:" + SelX + " Y:"+ SelY + " Which is Cell number: "+ SelCell
			RetVal = 1
		End IF
		
		Return RetVal
	End

End


#Rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#End