#Rem
header:


File Name : Game7Screen
Author    : Patrik "Tibit" Strandell
About     : Desert Race Mayhem, see how long you can keep it up :)
 

#end



Import main
Import diddy

#Rem
summary:Title Screen Class. Test Commit
Used to manage and deal with all Tital Page stuff.
#End
Class Game7Screen Extends Screen

        Field GameState:ERT_GameState
        Field BlinkTimer:Float
        Field BlinkFade:Bool
        
        Method New()
                name = "Game 7 Screen"
                Local gameid:Int = 7
                GameList[gameid - 1] = New miniGame
                GameList[gameid - 1].id = gameid - 1
                GameList[gameid - 1].name = "Desert Race Mayhem"
                GameList[gameid - 1].iconname = "game" + gameid + "_icon"
                GameList[gameid - 1].thumbnail = "game" + gameid + "_thumb"
                GameList[gameid - 1].author = "Patrik Strandell"
                GameList[gameid - 1].authorurl = "tibitinteractive.com"
                GameList[gameid - 1].info = "When you get to be 1st, you get a flat tire.."
        End
                
        #Rem
        summary:Start Screen
        Start the Title Screen.
        #End
        Method Start:Void()
                diddyGame.screenFade.Start(50, False)
                GameState = new ERT_GameState
                GameState.LoadGraphics()                        
        End
        
        #Rem
        summary:Render Title Screen
        Renders all the Screen Elements.
        #End
        Method Render:Void()
                Cls
                SetColor(255, 255, 255)
        
                Local rowHeight:Int = 30
                Local row:Int = 0
                TitleFont.DrawText("Oh NO!", 320, 140 + row * rowHeight, 2); row += 2
                TitleFont.DrawText("You have managed to take the 1st position", 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("in a desert race and you just got a flat tire..", 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("For how long can you keep the lead?? ", 320, 140 + row * rowHeight, 2); row += 3
                
                SetAlpha(BlinkTimer * 0.01)
                TitleFont.DrawText("click to start", 320, 140 + row * rowHeight, 2); row += 1
                SetAlpha(1)
        End

        #Rem
        sumary:Update Title Screen
        Will update all screen objects, handles mouse, keys
        and all use input.
        #End
        Method Update:Void()
                Local fadeSpeed:Float = 2
                if BlinkFade = False
                        BlinkTimer += fadeSpeed
                        if BlinkTimer > 98
                                BlinkFade = True
                        End
                Else
                        BlinkTimer -= fadeSpeed
                        if BlinkTimer < 2
                                BlinkFade = false
                        End
                End
                
                                
                if TouchHit()
                        diddyGame.nextScreen = GameState
                        diddyGame.screenFade.Start(50, true)
                End
                                
                if KeyHit(KEY_ESCAPE) or
                        diddyGame.nextScreen = TitleScr
                        diddyGame.screenFade.Start(50, true)
                EndIf
                
        End method

        
End

'summary:need input
Class Mine

        Field Position:Vector2D = new Vector2D
        
        Method New(startPosition:Vector2D)
                ' Since we are using vectors it is VERY important 
                ' that we use SET here and not =
                Position.Set(startPosition)
        End
End

'summary:need input
Class OpponentCar
        Field Position:Vector2D = new Vector2D
        Field Type:Int
        Field Speed:Float
        Field MaxSpeed:Float
        Field Destroyed:Bool = false
        
        Method New(startX:float, startY:float, speed:Float = 0)
                Position.Set(startX, startY)
                Type = Rnd(1, 5) '<-- Generates a 1 or 2 or 3 or 4
                Speed = speed
                if Speed = 0 Then Speed = Rnd(3, 6)
                MaxSpeed = Speed
        End
        
End
'summary:need input
Class ERT_GameState Extends Screen
        
        Field VictoryGameState:ERT_VictoryGameState = new ERT_VictoryGameState
        Field LossGameState:ERT_LossGameState = new ERT_LossGameState
        Field CarImage:GameImage[5] 'Array of 5 Images
        
        Field MineImage:GameImage
        Field PauseImage:GameImage
        Field CrashImage:GameImage
        Field CarPosition:Vector2D = new Vector2D
        Field MineCooldown:Float = 10
		
        Field PlayerSpeed:Float
		Field PlayerMaxSpeed:Float
		
        Field MineFrame:Int
        Field MineFrameTimer:Float
        Field RoadImage:GameImage
        Field RoadOffset:Float
        Field Distance:Float
        Field Place:Int = 1
        Field PlayerDead:Bool = true
        Field TouchLocation:Vector2D = new Vector2D
        
        Field SpawnCooldown:Float = 500
        Field SpawnTimer:Float
        Field Difficulty:Float = 0
        
        Field MineList:List<Mine> = new List<Mine>
        Field OpponentList:List<OpponentCar> = new List<OpponentCar>
        
        ' X Position of the Center of that Lane
        
        Const LANE1A:Int = 147 - 25
        Const LANE2A:Int = 262 - 25
        Const LANE3A:Int = 382 - 25
        Const LANE4A:Int = 498 - 25
        
        Const LANE1B:Int = 147 + 25
        Const LANE2B:Int = 262 + 25
        Const LANE3B:Int = 382 + 25
        Const LANE4B:Int = 498 + 25
        
        Method LoadGraphics:Void()
		
                CrashImage = diddyGame.images.Find("game7_crash") 'If not using a texture packer: LoadImage("graphics/game7/crash.png")
				CrashImage.SetHandle(0, 0)
                PauseImage = diddyGame.images.Find("game7_pause") 'LoadImage("graphics/game7/pause.png")
                CarImage[1] = diddyGame.images.Find("game7_car") 'LoadImage("graphics/game7/car.png")
                CarImage[2] = diddyGame.images.Find("game7_car2") 'LoadImage("graphics/game7/car2.png")
                CarImage[3] = diddyGame.images.Find("game7_car3") 'LoadImage("graphics/game7/car3.png")
                CarImage[4] = diddyGame.images.Find("game7_car4") 'LoadImage("graphics/game7/car4.png")
                RoadImage = diddyGame.images.Find("game7_road") 'LoadImage("graphics/game7/road.png")
				RoadImage.SetHandle(0, 0)
                MineImage = diddyGame.images.Find("game7_mine") 'LoadImage("graphics/game7/mine.png", 12, 12, 2)
                'ERT_WorldRecordDistance 'We could Load from file + Save at end of game
                ERT_ExitMenu = New ERT_EndOfGameMenu()
        End
        
        'summary: Initialize Gameplay
        Method Start:Void()
                diddyGame.screenFade.Start(1500, False)
                CarPosition.Set(120, 130)
                PlayerDead = False
                SpawnTimer = SpawnCooldown
                PlayerMaxSpeed = 8
        End
        
        'summary: Render Game
        Method Render:Void()
                Cls
                'Draw Road
				RoadImage.Draw(0, RoadOffset)
                RoadImage.Draw(0, RoadOffset - RoadImage.image.Height)
                'Above: I am drawing the background twice, so it will appear as it loops when we move it
                
                For Local mine:Mine = EachIn MineList
                    MineImage.Draw(mine.Position.x - MineImage.h2, mine.Position.y - MineImage.h2, MineFrame)
                Next
                
                
                CarImage[1].Draw(CarPosition.x - CarImage[1].w2, CarPosition.y - CarImage[1].h2)
                
                For Local car:OpponentCar = EachIn OpponentList
                        CarImage[car.Type].Draw(car.Position.x - CarImage[car.Type].h2, car.Position.y - CarImage[car.Type].h2)
                        if car.Destroyed
                                CrashImage.Draw(car.Position.x - CrashImage.w2, car.Position.y - CrashImage.h2)
                        End
                Next
                
                PauseImage.Draw(DEVICE_WIDTH - 50, DEVICE_HEIGHT - 50)
                
                TitleFont.DrawText("Speed: " + int(PlayerSpeed) + ". Distance: " + Int(Distance), 50, 30, 1)
                TitleFont.DrawText("Place: " + Place, DeviceWidth(), 30, 3)
        End
		
		
        'summary: Game Logic
        Method Update:Void()
                Distance += PlayerSpeed 'Int!

                MineLogic()
				
				DifficultyIncrease()
				
				If Not PlayerDead Then InputLogic()
				
				PlayerLogic()
				
				OpponentCarLogic()
                                
                if EndOfGameCondition Then OnEndOfGame()
                
                'Lose game - happens if you click PAUSE
                if KeyHit(KEY_ESCAPE) or TouchLocation.Distance(DEVICE_WIDTH - 25, DEVICE_HEIGHT - 25) < 25
					OnEndOfGame()
                End
                
        End method

		
		'summary: Here you find the code that alters the difficulty over time! For effect is also slows the player down.
		Method DifficultyIncrease:Void()
                 'Lower player speed over time!
                if Distance > 8000
                        SpawnCooldown = 20
                        PlayerMaxSpeed = 3
                        Difficulty = PlayerMaxSpeed + 6.5
                Else if Distance > 7000
                        PlayerMaxSpeed = 3.5
                        SpawnCooldown = 50
                        Difficulty = PlayerMaxSpeed + 6.5
                Else if Distance > 6000
                        PlayerMaxSpeed = 4
                        SpawnCooldown = 50
                        Difficulty = PlayerMaxSpeed + 5.5
                Else if Distance > 5000
                        PlayerMaxSpeed = 4.5
                        SpawnCooldown = 50
                        Difficulty = PlayerMaxSpeed + 4.5
                Else if Distance > 4000
                        PlayerMaxSpeed = 5
                        SpawnCooldown = 50
                        Difficulty = PlayerMaxSpeed + 3.5
                Else if Distance > 4000
                        PlayerMaxSpeed = 6
                        SpawnCooldown = 50
                        Difficulty = PlayerMaxSpeed + 2
                Else If Distance > 500
                        PlayerMaxSpeed = 7
                        SpawnCooldown = 50
                        Difficulty = PlayerMaxSpeed + 1
                Else If Distance > 0
                        PlayerMaxSpeed = 8
                        SpawnCooldown = 50
                        Difficulty = PlayerMaxSpeed + 0.3
                End
							
                SpawnTimer += 1
				' On Spawn!
                If SpawnTimer >= SpawnCooldown
                        SpawnTimer = 0
						
                        Local lane:Int = Rnd(1, 9)
                        Select lane
                                Case 1
                                        Spawn(LANE1A, Difficulty + Rnd( - 1, 2))
                                Case 2
                                        Spawn(LANE1B, Difficulty + Rnd( - 1, 2))
                                Case 3
                                        Spawn(LANE2A, Difficulty + Rnd( - 1, 2))
                                Case 4
                                        Spawn(LANE2B, Difficulty + Rnd( - 1, 2))
                                Case 5
                                        Spawn(LANE3A, Difficulty + Rnd( - 1, 2))
                                Case 6
                                        Spawn(LANE3B, Difficulty + Rnd( - 1, 2))
                                Case 7
                                        Spawn(LANE4A, Difficulty + Rnd( - 1, 2))
                                Case 8
                                        Spawn(LANE4B, Difficulty + Rnd( - 1, 2))
                        End
                End
                
                'Used these to Test the gameplay
                '#REM
                If KeyHit(KEY_1)
                        OpponentList.AddFirst(New OpponentCar(LANE1A, RoadImage.h + 50, 1))
                        OpponentList.AddFirst(New OpponentCar(LANE1B, RoadImage.h + 50, 1))
                End
                If KeyHit(KEY_2)
                        OpponentList.AddFirst(New OpponentCar(LANE2A, RoadImage.h + 50, 2))
                        OpponentList.AddFirst(New OpponentCar(LANE2B, RoadImage.h + 50, 2))
                End
                If KeyHit(KEY_3)
                        OpponentList.AddFirst(New OpponentCar(LANE3A, RoadImage.h + 50, 3))
                        OpponentList.AddFirst(New OpponentCar(LANE3B, RoadImage.h + 50, 3))
                End
                If KeyHit(KEY_4)
                        OpponentList.AddFirst(New OpponentCar(LANE4A, RoadImage.h + 50, 4))
                        OpponentList.AddFirst(New OpponentCar(LANE4B, RoadImage.h + 50, 4))
                End
                '#END
		End
		
		'summary: Update and handle logic with Mines. Collision & movement.
		Method MineLogic:Void()
            MineCooldown += 1
            MineFrameTimer += 1
            if MineFrameTimer > 10
                    if MineFrame = 0 then MineFrame = 1 Else MineFrame = 0 'ToggleFrame
                    MineFrameTimer = 0
            End
			
            For Local mine:Mine = EachIn MineList
                    mine.Position.y += PlayerSpeed
                    If mine.Position.y > RoadImage.h + 50
                            MineList.Remove(mine)
                    End
                    For Local opponent:OpponentCar = EachIn OpponentList
                            if mine.Position.Distance(opponent.Position) < 15
                                    MineList.Remove(mine)
                                    opponent.Speed = 0
                                    opponent.Destroyed = True
                            End
                    Next
            Next
		End
		
		'summary: Check for touch input, and Act accordingly
		Method InputLogic:Void()
                'TiltLeft or Touch Left Side of Player Car
				If TouchDown
	                If TouchX() < CarPosition.x OR KeyDown(KEY_LEFT) Or AccelZ() = - 1
	                        CarPosition.x -= 4
	                End
	                
	                'TiltRight or Touch Right Side of Player Car
	                If TouchX() > CarPosition.x OR KeyDown(KEY_RIGHT) Or AccelZ() = 1
	                        CarPosition.x += 4
	                End
	                
	                TouchLocation.Set(TouchX(), TouchY())
	                
	                ' Touch Car
	                if TouchLocation.Distance(CarPosition) < 25 OR KeyDown(KEY_SPACE)
	                        'Deploy Mine if Cooldown time OK
	                        if MineCooldown > 100
	                                MineList.AddLast(New Mine(CarPosition))
	                                MineCooldown = 0
	                        End
	                End
                End
		End
		
		'summary: Update player, and make sure player's speed is reduced if we go outside the road, update pålayer if dead
		Method PlayerLogic:Void()
			RoadOffset += PlayerSpeed
				
			'Slow down when outside Road or when over middle
            If CarPosition.x < 92 or CarPosition.x > RoadImage.w - 99 or (CarPosition.x > 316 - 5 And CarPosition.x < 331 + 5)
                    PlayerSpeed = PlayerMaxSpeed * 0.7
            Else
                    PlayerSpeed = PlayerMaxSpeed
            End
			 
            if PlayerDead = True ' We stop when dead...  = We move towards bottom of screen
                     CarPosition.y += PlayerSpeed
            End
			
			if RoadOffset >= RoadImage.h Then RoadOffset = 0
		End

		Method OpponentCarLogic:Void()
                For Local car:OpponentCar = EachIn OpponentList
						Local carRelativeSpeed:Float = (car.Speed - PlayerSpeed)
                        
						If car.Destroyed
							car.Position.y += PlayerSpeed ' Move down
							
							If car.Position.y > RoadImage.h + 80
                                OpponentList.Remove(car)
                                Continue
	                        End

						else
						 	car.Position.y -= carRelativeSpeed ' Move up - relative
							
							If car.Position.y < - 80
	                                Place += 1
	                                OpponentList.Remove(car)
	                                Continue
	                        End
						end
						
                        
                        For Local car2:OpponentCar = EachIn OpponentList
                            If car.Position.Distance(car2.Position.x, car2.Position.y + 80) < 40
                                    car.Speed = car2.Speed * 0.2 ' BREAKS!
                            Else
                                    If car.Speed < car.MaxSpeed
                                            car.Speed += car.MaxSpeed * 0.0003 'Accelerate to max again
                                    End
                            End
                        Next
                        If car.Position.Distance(CarPosition.x, CarPosition.y + 75) < 25
                                car.Speed = PlayerSpeed * 0.8
                        End
                        'Crash?
                        If car.Position.Distance(CarPosition.x, CarPosition.y + 10) < 25
                               car.Speed = 0
                               car.Destroyed = True
                               PlayerMaxSpeed = 0
                               ' Explosion!
                               PlayerDead = True
						End
                Next
		End		
				
		Method EndOfGameCondition:Bool()
			Return Place > 25 Or PlayerDead = true
		End
		
		Method OnEndOfGame:Void()
               'Using global to send score to the Victory/loss state
             ' This is not the best code, but then this is also a simple game :)
             ERT_DistanceTraveledThisGame = Distance
                                 
             ' Check Score - if best score then goto victory screen instead
             If Distance > ERT_WorldRecordDistance
                     ERT_WorldRecordDistance = Distance ' Save new record!
                     diddyGame.nextScreen = VictoryGameState
                     diddyGame.screenFade.Start(1500, true)
             Else
                     diddyGame.nextScreen = LossGameState
                     diddyGame.screenFade.Start(1500, true)
             End
		End
		        
        'summary: This metod spawns a car at a X coordinate and with a certain speed faster than the player's current speed. Use the LANE constants to spawn on lanes!
        Method Spawn(xLane:Float, speed:Float)
                OpponentList.AddFirst(New OpponentCar(xLane, RoadImage.h + 50, speed))
        End

End
Global ERT_DistanceTraveledThisGame:Int
Global ERT_WorldRecordDistance:Int
Global ERT_ExitMenu:ERT_EndOfGameMenu

'summary: This state just draws some text on the screen after the player has won the game
Class ERT_VictoryGameState Extends Screen
        Method Start:Void()
        End
        Method Update:Void()
                ERT_ExitMenu.Update
        End
        Method Render:Void()
                Cls
                SetColor(255, 255, 255)
        
                Local rowHeight:Int = 30
                Local row:Int = 0
                TitleFont.DrawText("Congratulations!", 320, 140 + row * rowHeight, 2); row += 2
                TitleFont.DrawText("No one in the world has managed to keep themselves", 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("in a desert race with a flat tire such a long distance!", 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("Amazing! Now, can you do even better? ", 320, 140 + row * rowHeight, 2); row += 3
                TitleFont.DrawText("You traveled: " + ERT_DistanceTraveledThisGame, 320, 140 + row * rowHeight, 2); row += 1
                ERT_ExitMenu.Render
        End
End
'summary: This state draws the "you lose, try again" text on the screen
Class ERT_LossGameState Extends Screen
        Method Start:Void()
                
        End
        Method Update:Void()
                ERT_ExitMenu.Update
        End
        Method Render:Void()
                Cls
                Local rowHeight:Int = 30
                Local row:Int = 0
                TitleFont.DrawText("You are LAST!", 320, 140 + row * rowHeight, 2); row += 2
                TitleFont.DrawText("You did not break the world record this time..", 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("Nothing else counts.. really.. deal with it..", 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("World Record: " + ERT_WorldRecordDistance, 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("You traveled: " + ERT_DistanceTraveledThisGame, 320, 140 + row * rowHeight, 2); row += 1
                TitleFont.DrawText("Remaining Distance: " + (ERT_WorldRecordDistance - ERT_DistanceTraveledThisGame), 320, 140 + row * rowHeight, 2); row += 2
                TitleFont.DrawText("Maybe next time you have better luck!", 320, 140 + row * rowHeight, 2); row += 1
                ERT_ExitMenu.Render
        End
End

'summary: This class handles the Menu System used in the ERT_VictoryGameState and ERT_LossGameState screens. Remeber to call update & render
Class ERT_EndOfGameMenu
        
        Field Restart:= new Vector2D(30, 430)
        Field Back:= new Vector2D(460, 430)
        Field BlinkTimer:Float
        Field BlinkFade:Bool
                        
        Method New()
                
        End
        
        Method Render:Void()
                SetAlpha(BlinkTimer * 0.01)
                TitleFont.DrawText("PLAY AGAIN", Restart.x, Restart.y, 1);
                TitleFont.DrawText("BACK TO ARCADE", Back.x, Back.y, 1);
                SetAlpha(1)
        End
        
        Method Update:Void()

                Local fadeSpeed:Float = 2
                if BlinkFade = False
                        BlinkTimer += fadeSpeed
                        if BlinkTimer > 98
                                BlinkFade = True
                        End
                Else
                        BlinkTimer -= fadeSpeed
                        if BlinkTimer < 2
                                BlinkFade = false
                        End
                End     
        
                If Restart.Distance(TouchX(), TouchY()) < 100
                        diddyGame.nextScreen = Game7Scr
                        diddyGame.screenFade.Start(500, true)
                End
                
                If Back.Distance(TouchX(), TouchY()) < 100
                        diddyGame.nextScreen = TitleScr
                        diddyGame.screenFade.Start(500, true)
                End
        End
End

#Rem
footer: Feel free to use this source when building your game, commercial or otherwise. You do not need to say you got the code from here. Just make sure you use it for making the world a better place! Oh and feel free to use the Art as well :)
Monkey Coder 
#end