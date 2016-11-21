#Rem
header:
[quote]

[b]File Name :[/b] Game1Screen
[b]Author    :[/b] Paul "Taiphoz" Grayston
[b]About     :[/b]
Space Invaders with little glowing ships, keeping this nice and 
basic, endless levels of ever increasing speed and a hail of bullets
to test the players reflex's
[/quote]
#end

Import main


Global TaiPlayer:Tai_Player
Global Tai_Shunt:Bool = False
Global HighScore:Int = 100
Global OldHighScore:Int = 100

Global blockscorefont:BitmapFont2
Global blockfont:BitmapFont2

Const BLUE:Int = 1
Const GREEN:Int = 2
Const ORANGE:Int = 3
Const PURPLE:Int = 4
Const RED:Int = 5

Global GameOver:bool = false
Global GameComplete:Bool = false

Global shotsound:GameSound
Global explodesound:GameSound
Global hitsound:GameSound
Global powerupdropsound:GameSound
Global poweruppicksound:GameSound
Global waveinsound:GameSound
Global lowscoresound:GameSound
Global highscoresound:GameSound

Global endscoreplayed:Bool = false

	
Global Game1PlayScr:Screen = New Game1PlayScreen()
#Rem
summary:Title Screen Class.
Used to manage and deal with all Tital Page stuff.
#End
Class Game1PlayScreen Extends Screen
	
	Field background:Image
	Field clearing:Bool
	Field scoreup:bool
	
	#Rem
	summary: New
	New method to create a new instance of this screen class.
	#End
	Method New()
		name = "Game 1 Play Screen"
		
		clearing = False
				
	End
	
	#Rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
				
		diddyGame.screenFade.Start(50, False)
		background = LoadImage("graphics/game1/bg.png")
		
		TaiPlayer = New Tai_Player(320)
		ClearGameData()
		TaiPlayer.score = 0
		TaiPlayer.life = 3
		TaiPlayer.score = 0' debug HighScore
		scoreup = false
		GameComplete = false
		TaiWave = 1
		self.clearing = false
		CreateWave(TaiWave)
		GameOver = false
		
		shotsound = diddyGame.sounds.Find("shot_02")
		explodesound = diddyGame.sounds.Find("explode_02")
		hitsound = diddyGame.sounds.Find("hit_01")
		powerupdropsound = diddyGame.sounds.Find("powerup_01")
		poweruppicksound = diddyGame.sounds.Find("powerup_04")
		waveinsound = diddyGame.sounds.Find("spawn_03")
		highscoresound = diddyGame.sounds.Find("highscore")
		lowscoresound = diddyGame.sounds.Find("lowscore")
		
		#IF TARGET="glfw"
			diddyGame.MusicPlay("demon_diddyGame.wav", True)
		#ELSE
			diddyGame.MusicPlay("demon_diddyGame.mp3", True)
		#END
		
		OldHighScore = HighScore
		
	End
	
	method CollisionCheck()

	For Local shot:Tai_Bullet = eachin TaiBulletList
		
		'check aliens.
		
		For Local alien:Tai_Alien = eachin TaiAlienList
			if RectsOverlap(shot.x, shot.y, 10, 10, alien.x - 18, alien.y - 20, 36, 40) and shot.dir = UP And shot.life > 0
				'bullet hit the alien.
				
				alien.shoot()
				
				if alien.life <= 1 Then
					'it died, give points
					alien.life = 0
					'Print "Adding a point"
					TaiPlayer.AddScore(alien.pts)
					
					'Self.explodesound.Play()
					
				else
					'its alive make it shoot back
					'and take some like off.
					alien.life -= 1
					
					
				EndIf
				
				hitsound.Play()
				shot.life = 0
			End if
		Next
		
		'check power ups.
		
		For Local power:TaiPowerUp = eachin TaiPowerUplist
			if RectsOverlap(shot.x, shot.y, 10, 10, power.x - 18, power.y - 20, 36, 41) and shot.dir = UP And shot.life > 0
				'bullet hit the power.
				shot.life = 0
				power.life -= 1
				
				if power.life <= 0
					CreateBang(power.x, power.y, power.color, 30)
				EndIf
				
				hitsound.Play()
				TaiPlayer.AddScore(power.pts)
				
			End if					
		Next
		
		'check player.
		if (shot.dir = DOWN or shot.dir=TARGETED) And TaiPlayer.phase=0
			if RectsOverlap(shot.x, shot.y, 10, 10, TaiPlayer.x - 20, TaiPlayer.y - 20, 40, 40) And shot.life > 0
				'bullet hit the player.
				
				if TaiPlayer.power > 1 Then TaiPlayer.power -= 1
				CreateBang(TaiPlayer.x,TaiPlayer.y,RED,50)
				
				TaiPlayer.life -= 1
				shot.life = 0
				hitsound.Play()
				TaiPlayer.phase=1
			End if
		EndIf
	Next
	End method
	
	#Rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
			DrawImage(background, 0, 0)
			'TitleFont.DrawText("Taiphoz Invaders", 320, 240, 2)
			
			'blockscorefont.DrawText(TaiPlayer.score, DEVICE_WIDTH / 2, 1, 2)
			
			
			
			for local ub:Tai_Bullet = eachin TaiBulletList
				ub.render()
			Next		
	
			for local ua:Tai_Alien = eachin TaiAlienList
				ua.renderbloom()
				ua.render()
			Next
			
			'for local ua:Tai_Alien = eachin TaiAlienList
				'ua.render()
			'Next
				
			for local pu:TaiPowerUp = eachin TaiPowerUplist
				pu.draw()
			Next
			
			for local pt:cParticle = eachin cParticleList
				pt.draw()
			Next			
					
			For Local lpx:Int = 1 to 3
				PushMatrix
				
				SetMatrix(1, 0, 0, 1, 0, 0)
				Scale 0.5, 0.5
				Translate((DEVICE_WIDTH + 21) - (lpx * 42), DEVICE_HEIGHT - 21)
				
				DrawImage(TaiPlayer.heart.image, (DEVICE_WIDTH + 21) - (lpx * 42), DEVICE_HEIGHT - 21)
				
				PopMatrix
			Next
					
			For Local lpx:Int = 1 to TaiPlayer.life
				DrawImage(TaiPlayer.fullheart.image, (DEVICE_WIDTH + 21) - (lpx * 42), DEVICE_HEIGHT - 21)
			Next
			
			
			TaiPlayer.render()
			
			
			if GameOver = true or GameComplete = true
				'ok game over. lets draw the score in the center with a text message.
				
				select self.scoreup
					Case true
					
						if not endscoreplayed
							highscoresound.Play()
							endscoreplayed = true
							
						EndIf
						
						select GameComplete
							Case true
								blockscorefont.DrawText(TaiPlayer.score, DEVICE_WIDTH / 2, 150, 2)
								blockfont.DrawText("!!GAME COMPLETE!!", DEVICE_WIDTH / 2, 210, 2)
								blockfont.DrawText("Congratulations, and thanks for playing.", DEVICE_WIDTH / 2, 240, 2)
								blockfont.DrawText("And you beat your Highest Score...", DEVICE_WIDTH / 2, 270, 2)
								blockfont.DrawText("Well Done!", DEVICE_WIDTH / 2, 300, 2)
								blockfont.DrawText("Tap or Shoot to Continue!", DEVICE_WIDTH / 2, 340, 2)
							case false
								blockscorefont.DrawText(TaiPlayer.score, DEVICE_WIDTH / 2, 250, 2)
								blockfont.DrawText("New High Score", DEVICE_WIDTH / 2, 300, 2)
								blockfont.DrawText("Tap or Shoot to Continue!", DEVICE_WIDTH / 2, 340, 2)
						End Select
						
					case false
					
						if not endscoreplayed
							lowscoresound.Play()
							endscoreplayed = true
						EndIf
						
						Select GameComplete
							Case True
								blockscorefont.DrawText(TaiPlayer.score, DEVICE_WIDTH / 2, 150, 2)
								blockfont.DrawText("!!GAME COMPLETE!!", DEVICE_WIDTH / 2, 210, 2)
								blockfont.DrawText("Congratulations, and thanks for playing.", DEVICE_WIDTH / 2, 240, 2)
								blockfont.DrawText("Play Again and beat your High Score..", DEVICE_WIDTH / 2, 270, 2)
								blockfont.DrawText("Better Luck Next Time!", DEVICE_WIDTH / 2, 300, 2)
								blockfont.DrawText("Tap or Shoot to Continue!", DEVICE_WIDTH / 2, 340, 2)
							Case False
								blockscorefont.DrawText(TaiPlayer.score, DEVICE_WIDTH / 2, 250, 2)
								blockfont.DrawText("Better Luck Next Time!", DEVICE_WIDTH / 2, 300, 2)
								blockfont.DrawText("Tap or Shoot to Continue!", DEVICE_WIDTH / 2, 340, 2)
						End Select
						
				End Select

			else
				blockscorefont.DrawText(TaiPlayer.score, DEVICE_WIDTH / 2, 1, 2)
			EndIf
			
						

			
			'TitleFont.DrawText("x " + TaiPlayer.x + " y " + TaiPlayer.y, 10, 60, 1)
			'TitleFont.DrawText("Bullets " + TaiBulletList.Count(), 10, 80, 1)
			'TitleFont.DrawText("Aliens " + TaiAlienList.Count(), 10, 100, 1)
			'TitleFont.DrawText("Wave " + TaiWave, 10, 120, 1)
			'TitleFont.DrawText("Base " + TaiBaseSpeed, 10, 140, 1)
			'TitleFont.DrawText("Particles " + cParticleList.Count(), 10, 180, 1)
			'TitleFont.DrawText("Phase " + TaiPlayer.phase, 10, 200, 1)

	End

	#Rem
	summary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	and all use input.
	#End
	Method Update:Void()
		
		if GameOver = false And GameComplete = false
		
			CollisionCheck()
		
			if TaiPlayer.life <= 0
				GameOver = true
				GameComplete = false
				If TaiPlayer.score > HighScore Then
					HighScore = TaiPlayer.score
					Self.scoreup = true
				End if
								
			else
				
				If TaiPlayer.score > HighScore Then
					HighScore = TaiPlayer.score
					Self.scoreup = true
				End if			
				
				if TaiAlienList.Count() = 0 And TaiWave = 40
					GameOver = true
					GameComplete = true
				EndIf
			EndIf
			

			
			if TaiPlayer.life > 0 And TaiAlienList.Count() = 0 And cParticleList.Count() = 0 And TaiBulletList.Count() = 0 and TaiPowerUplist.Count() = 0 ' waveout = false
				TaiWave += 1
				if waveinsound.IsPlaying() = false then
					waveinsound.Play()
				End if
				
				CreateWave(TaiWave)
			EndIf
			 
					
			if KeyDown(KEY_LEFT) Then
				if TaiPlayer.phase = 0
					TaiPlayer.MoveLeft
				ElseIf TaiPlayer.phase >= 3
					TaiPlayer.MoveLeft
				End if
			End if
			 
			if KeyDown(KEY_RIGHT) and (TaiPlayer.phase = 0 or TaiPlayer.phase>=3 )Then
				TaiPlayer.MoveRight
			End if
			
			if KeyDown(KEY_Z) Then TaiPlayer.Shoot
			
			TaiPlayer.update()
			
			for local ub:Tai_Bullet = eachin TaiBulletList
				ub.update()
			Next
					
			for local ua:Tai_Alien = eachin TaiAlienList
				ua.update()
			Next
			
			for local pu:TaiPowerUp = eachin TaiPowerUplist
				pu.update()
			Next
			
			for local pt:cParticle = eachin cParticleList
				pt.update()
			Next			
			
			if Tai_Shunt = True
				ShuntDown()
				Tai_Shunt = False
			EndIf
					
			if KeyHit(KEY_ESCAPE)
				
				FadeToScreen(Game1Scr)
			EndIf
		Else
			'game over , detect a touch to go back.
			
			for local ub:Tai_Bullet = eachin TaiBulletList
				ub.update()
			Next
			
			for local pu:TaiPowerUp = eachin TaiPowerUplist
				pu.update()
			Next
			
			for local pt:cParticle = eachin cParticleList
				pt.update()
			Next
						
			if TouchHit() or KeyHit(KEY_Z)
				ClearGameData()
				
				'here
				FadeToScreen(Game1Scr)
			EndIf
			
		End if

	End method

	
End


'summary:Clear out all the lists, and bullets, aliens. etc.
Function ClearGameData()
	TaiBulletList.Clear
	TaiAlienList.Clear
	TaiPowerUplist.Clear
	cParticleList.Clear
End Function



Class Game1Screen Extends Screen
	
	Field background:Image
	
	
	
	
	#Rem
	summary: New
	New method to create a new instance of this screen class.
	#End
	Method New()
		name = "Game 1 Menu"
		
		'diddyGame.MusicPlay("brain_menu.mp3", True)
		'diddyGame.MusicSetVolume(8)
		
		Local gameid:Int = 1
		
		GameList[gameid - 1] = New miniGame
		GameList[gameid - 1].id = (gameid - 1)
		GameList[gameid - 1].name = "Bit Invader"
		GameList[gameid - 1].iconname = "game" + gameid + "_icon"
		GameList[gameid - 1].thumbnail = "game" + gameid + "_thumb"
		GameList[gameid - 1].author = "Paul Grayston"
		GameList[gameid - 1].authorurl = "dev.cruel-gaming.com"
		GameList[gameid - 1].info = "Aliens are planning to take over the world it's your job to save us all. Original HUH! "
		'Print "GameList " + GameList[0].name
		
	End
	
	#Rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		diddyGame.screenFade.Start(50, False)
		background = LoadImage("graphics/game1/menu.png")
		blockscorefont = New BitmapFont2("graphics/game1/block_score.txt", True)
		blockfont = New BitmapFont2("graphics/game1/block.txt", True)
		'blockfont.DrawShadow = False
		
		#IF TARGET="glfw"
			diddyGame.MusicPlay("demon_menu.wav", True)
		#ELSE
			diddyGame.MusicPlay("demon_menu.mp3", True)
		#END
			
		endscoreplayed = False
		
		if HighScore > OldHighScore
			Self.mySave()
		else
			Self.myLoad()
		EndIf
		
		
	End
	
	
	#Rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		DrawImage(background, 0, 0)
		blockscorefont.DrawText(HighScore, DEVICE_WIDTH / 2, 180, 2)
		'blockscorefont.DrawText("1 2 3 4 5 6 7 8 9 0", DEVICE_WIDTH / 2, 180, 2)
	End

	#Rem
	summary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	and all use input.
	#End
	Method Update:Void()
	
		if KeyHit(KEY_SPACE)
			FadeToScreen(Game1PlayScr)
		EndIf
	
		if TouchHit() or TouchDown()
			
			if MouseOver(15, 214, 264, 203)
				'back		
				FadeToScreen(TitleScr)
			EndIf
			
			if MouseOver(366, 214, 264, 203)
				'play
				FadeToScreen(Game1PlayScr)
			EndIf
		EndIf

			
	End method

	Method myLoad:bool()
		Local filein:FileStream
		Local filehandler:FileSystem
		filehandler = FileSystem.Create()
		
		if filehandler.FileExists("game1/score.dat")
		
			filein = filehandler.ReadFile("game1/score.dat")
			if filein
				HighScore = filein.ReadInt()
				'Print "Loading Score " + HighScore
			End if
			
		Else
			Self.mySave()
		EndIf
		
		
	End Method
	
	Method mySave:Void()
		Local fileout:FileStream
		Local filehandler:FileSystem
		filehandler = FileSystem.Create()
		
		fileout = filehandler.WriteFile("game1/score.dat")
		'Print "Saving Score " + HighScore
		fileout.WriteInt(HighScore)
		
		filehandler.SaveAll()
		
	End Method
End





'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************









#Rem
summary: Tai_Player
Class Created to manage the Player charcter
#End
Class Tai_Player
	Field sprite:GameImage
	Field heart:GameImage
	Field fullheart:GameImage
	
	Field diesound:GameSound
	
	Field x:Int
	Field y:Int
	Field life:Int
	Field state:int
	Field score:Int
	Field held:Int
	
	Field bullettime:Int
	Field bulletstall:Int
	
	Field gunopen:Int
	
	Field power:Int
	
	Field phase:int
	Field phasetime:Int
	Field phaseback:int
	Field phaseduration:Int
	
	Field show:Bool
	
	#Rem
		summary: new
		Create a new Player and provided _x position with the provided _life
	#END
	Method new(_x:Int, _life = 3, _power:Int = 1)
	
		self.sprite = diddyGame.images.Find("game1_player")
		self.fullheart = diddyGame.images.Find("game1_fullheart")
		self.diesound = diddyGame.sounds.Find("explode_01")
		self.heart = diddyGame.images.Find("game1_emptyheart")
		Self.x = _x
		Self.y = 450
		Self.life = _life
		Self.state = 1
		Self.held = 0
		
		self.bullettime = Millisecs()
		Self.bulletstall = 100
		
		Self.gunopen = 0
		Self.power = _power
		Self.show = True
		
		Self.phase = 0
		Self.phasetime = Millisecs()
		Self.phaseback = Millisecs()
		Self.phaseduration = 200
		
		
	End
	
	
	#Rem
		summary: gives the player some points :P
		wooot score muahahahaha
	#END
	Method AddScore(_score:int)
		
		TaiPlayer.score+=_score	
	End Method
	
	
	#Rem
		summary: update
		Update the player , tic through it's timer and handle controls and bound checking
	#END
	Method update()

		Select phase
			Case 1
				self.diesound.Play()
				Self.y += 70 * dt.delta
				phase = 2
			Case 2
				Self.held = 0
				Self.x = 320
				if Self.y > 450 then
					Self.y -= 0.2 * dt.delta
				
					if Millisecs() - phasetime > phaseduration
						phasetime = Millisecs()
						Select show
							Case True
								show = false
							Case false
								show = True
						End Select
					EndIf
				Else
					phase = 3
					phaseback = Millisecs()
				End if
				
			Case 3
				if Millisecs() - phaseback > 1500
					phase = 0
					show = true
				Else
				
					if Millisecs() - phasetime > phaseduration
						phasetime = Millisecs()
						Select show
							Case True
								show = false
							Case false
								show = True
						End Select
					EndIf
				
				End if
			Case 9
				'game complete.. woot.
							
		End Select
		
		
		
		if Millisecs() - Self.bullettime > Self.bulletstall
			Self.bullettime = Millisecs()
			Self.gunopen = 1
		EndIf
	
		if KeyHit(KEY_Z)
			TaiPlayer.Shoot()
		EndIf
		
			
		if TouchDown(0)
		
			if Tai_Touching(Self.x, Self.y, 50, 53, 2) or Self.held = true And phase = 0
				TaiPlayer.x = TouchX()
				Self.held = true
				TaiPlayer.Shoot
			EndIf
			
		Else
			Self.held = false
		EndIf
		
		if Self.x > 617 Then Self.x = 617
		if Self.x < 27 Then self.x = 27
		
	End
	
	'summary:Move Player Left
	Method MoveLeft:void()
		Self.x -= 4 * dt.delta
	End
	
	'summary:Move Player Right
	Method MoveRight:void()
		Self.x += 4* dt.delta
	End
	
	'summary:If the player's gun is not reloading then fire off a round.
	Method Shoot()
		'
		if Self.gunopen = 1 And phase=0 And TaiAlienList.Count()>0
			'fire a bullet
			Self.gunopen = 0
			Self.bullettime = Millisecs()
			CreateShatter(Self.x, Self.y, 5, RED)
			Local shot:Tai_Bullet
			Select Self.power
				Case 1
					shot = new Tai_Bullet(TaiPlayer.x, TaiPlayer.y, 1)
					if shotsound.IsPlaying()
						shotsound.Stop
						shotsound.Play()
					else
						shotsound.Play()
					EndIf
					
				Case 2
					shot = new Tai_Bullet(TaiPlayer.x - 20, TaiPlayer.y + 18, 1)
					shot = new Tai_Bullet(TaiPlayer.x + 20, TaiPlayer.y + 18, 1)
					if shotsound.IsPlaying()
						shotsound.Stop
						shotsound.Play()
					else
						shotsound.Play()
					EndIf
				Case 3
					shot = new Tai_Bullet(TaiPlayer.x, TaiPlayer.y, 1)
					shot = new Tai_Bullet(TaiPlayer.x - 20, TaiPlayer.y + 18, 1)
					shot = new Tai_Bullet(TaiPlayer.x + 20, TaiPlayer.y + 18, 1)
					if shotsound.IsPlaying()
						shotsound.Stop
						shotsound.Play()
					else
						shotsound.Play()
					EndIf
					
				
			End
			
			
		EndIf
		
	End
	
	'summary:Draw the player if it's visible (self.state=1) or dont if its not visible (self.state=0).
	Method render()
		select self.show
			Case true
				DrawImage(Self.sprite.image, Self.x, Self.y)
			Case false
				'hit by something , fade out for a little bit.
				'DrawImage Self.sprite, Self.x, Self.y
		End
	End
End










'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************








Const SWINGLEFT:Int = 1
Const SWINGRIGHT:Int = 2

Global Taiwave:int=0

'summary:Alien List, holds all alien objects once created, used when updating all aliens.
Global TaiAlienList:List<Tai_Alien> = new List<Tai_Alien>

#Rem
	summary:Tai_Alien
	Alien class used to manage and control all alien ships, this class gets instanced and fills up the alienlist.
#END
Class Tai_Alien
	Field sprite:GameImage
	Field x:float
	Field y:float
	Field life:Int
	Field dir:int
	Field speed:float
	Field color:Int
	Field pts:int

	Field bloom:GameImage
	
	Field shottimer:Int
	Field shotinterval:Int ' how long between shots.
	
	Field swing:Int ' left or right
	Field rotation:float ' current angle
	Field swingspeed:float ' amount per move.
	Field swinglimit:Int ' just how far it can rotate before it swings back
	
	#Rem
		summary: new
		Create's a new alien at _x,_y with _life of colour _color and ship type _ship at speed _speed .
		And then adds this new alien to the TaiAlienList
	#END
	Method new(_x:Int, _y:Int, _life:Int, _color:int = 1, _ship:int, _speed:int)
	
		Self.x = _x
		Self.y = _y
		Self.life = _life
		Self.pts = _life * 3
		Self.dir = 1
		Self.speed = _speed
		Self.color = _color
	
		Self.rotation = 1
		Self.swing = SWINGLEFT
		Self.swinglimit = 5
		Self.swingspeed = 1
		
		Self.shottimer = Millisecs()
		' interval should be higher at the start, and maller by stage 4.
		
		Self.shotinterval = 1000 - (TaiWave * 15)
		
		Select _color
			Case BLUE
				Self.sprite = diddyGame.images.Find("game1_alien" + _ship + "_blue")
				Self.bloom = diddyGame.images.Find("game1_glow_blue")
			Case GREEN
				Self.sprite = diddyGame.images.Find("game1_alien" + _ship + "_green")
				Self.bloom = diddyGame.images.Find("game1_glow_green")
			Case ORANGE
				Self.sprite = diddyGame.images.Find("game1_alien" + _ship + "_orange")
				Self.bloom = diddyGame.images.Find("game1_glow_orange")
			Case PURPLE
				Self.sprite = diddyGame.images.Find("game1_alien" + _ship + "_purple")
				Self.bloom = diddyGame.images.Find("game1_glow_purple")
				
		End Select
		
		TaiAlienList.AddLast(Self)
		
	End	
	
		
	'dir 1 = left 2 = right
	'color : 1=red 2=green 3=blue 4=yellow
	'ship 1,2,3,4
	
	'summary:Update aliens.
	Method update()
		
		Select Self.swing
			Case SWINGLEFT
				self.rotation += Self.swingspeed
				if Self.rotation > Self.swinglimit
					Self.swing = SWINGRIGHT
				EndIf
			Case SWINGRIGHT
				self.rotation -= Self.swingspeed
				if Self.rotation < - Self.swinglimit
					Self.swing = SWINGLEFT
				EndIf			
		End Select
	
		if Millisecs() - Self.shottimer > Self.shotinterval
			
			Local dice:Int = int(Rnd(100))
			
			if dice > (95 - Taiwave)
				Self.shootat()
			End if
			
			Self.shottimer = Millisecs()
			
		EndIf
	
		Select Self.dir
			Case 1
				Self.MoveLeft
			Case 2
				Self.MoveRight
		End
	
		
		if Self.y > 480 Then self.life = 0
		
		if Self.x > 617 or Self.x < 27 Then Tai_Shunt = true

		
		if Self.life <= 0
		
			CreateBang(Self.x, Self.y, Self.color, Rnd(10, 20))
			
			
			'if explodesound.IsPlaying()
			'	explodesound.Stop
			'	explodesound.Play()
			'else
				explodesound.Play()
			'EndIf
			
			Local pup:Int = Rnd(1, 10)
			
			Select True
				Case pup > 8
					'change this to drop new powerups
					Local tp:Int = int(Rnd(1, 7))
					if tp > 6 Then
						tp = 6
						Local secondroll:Int = int(Rnd(0, 11))
						if secondroll < 5
							tp = TAIBOMB
						End if
					End if
					
					Local np:TaiPowerUp = new TaiPowerUp(self.x, self.y, tp)
					'Print "Making a POwerup"
			End select
		
			TaiAlienList.Remove(Self)
		End if
	End
	
	'summary:Move alien left
	Method MoveLeft()
		Self.x -= (Self.speed + TaiBaseSpeed) * dt.delta
	End
	
	'summary:Move alien Right
	Method MoveRight()
		Self.x += (Self.speed + TaiBaseSpeed) * dt.delta
	End

	'summary:Draw the alien.
	Method render()
		DrawImage(Self.sprite.image, Self.x, Self.y, Self.rotation, 1, 1)
	End
	
	Method renderbloom()
		DrawImage(Self.bloom.image, Self.x, Self.y)
	End

	Method shoot()
		Local shot:Tai_Bullet
		shot = new Tai_Bullet(self.x, self.y, DOWN, self.color)
	End Method
	
	Method shootat()
		
		if Millisecs() - Self.shottimer > Self.shotinterval
	
			Local shot:Tai_Bullet
			Local angle:float
			angle = ATan2(TaiPlayer.x - Self.x, TaiPlayer.y - Self.y)
			shot = new Tai_Bullet(self.x, self.y, TARGETED, self.color, angle)
			Self.shottimer = Millisecs()
			
		End if
	End Method
End


	
	
	







'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************







	
	

Const DOWN:Int = 0
Const UP:Int = 1
Const TARGETED:Int = 2 'a shot aimed directly at the player.


'summary:Bullet list to manage all the bullets that get fired.
Global TaiBulletList:List<Tai_Bullet> = new List<Tai_Bullet>
#Rem
	summary: Tai_Bullet
	Bullet class used to manage all bullets, will probably make this manage alien and player bullets
#END
Class Tai_Bullet
	Field x:float
	Field y:float
	Field sprite:GameImage
	Field life:Int
	
	Field dx:float
	Field dy:float
	Field speed:Float
	Field angle:Float
	Field rotation:Int
	
	
	Field dir:Int
	
	
	'summary:Create a new bullet at _x,_y traveling in _dir direction (0=down 1=up)
	Method new(_x:Int, _y:Int, _dir:Int = UP, _color:int = RED, _angle = 0)
		Self.rotation = 1
		Select _dir
			Case UP
				'Player Shooting UP
				Self.sprite = diddyGame.images.Find("game1_player_bullet")
			Case DOWN
				'Alien shooting down.
				select _color
					Case BLUE
						Self.sprite = diddyGame.images.Find("game1_bullet_blue")'must rmemebr to fix this image filename.
					Case GREEN
						Self.sprite = diddyGame.images.Find("game1_bullet_green")
					Case ORANGE
						Self.sprite = diddyGame.images.Find("game1_bullet_orange")
					Case PURPLE
						Self.sprite = diddyGame.images.Find("game1_bullet_purple")
				End Select
			Case TARGETED
				'get the angle from the alien to the player.
				'set the dx vectors.
				Self.angle = _angle
				self.dx = Sin(_angle)
				Self.dy = Cos(_angle)
				
				select _color
					Case BLUE
						Self.sprite = diddyGame.images.Find("game1_target_bullet")'must rmemebr to fix this image filename.
					Case GREEN
						Self.sprite = diddyGame.images.Find("game1_target_bullet")
					Case ORANGE
						Self.sprite = diddyGame.images.Find("game1_target_bullet")
					Case PURPLE
						Self.sprite = diddyGame.images.Find("game1_target_bullet")
				End Select
				
		End Select
		
		Self.speed = 8
		Self.x = _x
		Self.y = _y
		Self.dir = _dir
		Self.life = 1
		TaiBulletList.AddLast(self)
	End
	
	'summary:update bullets, moved them in the appropriate direction based on self.dir
	Method update()
	
		Select Self.dir
			Case DOWN ' down
				Self.y += Self.speed * dt.delta
			Case UP ' up
				Self.y -= Self.speed * dt.delta
			Case TARGETED
				Self.x += (Self.dx * Self.speed) * dt.delta
				Self.y += (Self.dy * Self.speed) * dt.delta
				Self.rotation += 10 * dt.delta
		End
		
		if Self.y < 0 or Self.y > DEVICE_HEIGHT or Self.x < 0 or Self.x > DEVICE_WIDTH
			Self.life = 0
		EndIf	
		
		if Self.life <= 0
			'should probably move this, as this will be calling shatter if the bullet hits the top.
			if self.dir = UP then CreateShatter(Self.x, Self.y, 10)
			TaiBulletList.Remove(self)
		EndIf
		
		
		
	End
	
	'summary:Draw bullets.
	Method render()
		Select Self.dir
			Case UP
				DrawImage(Self.sprite.image, Self.x, Self.y)
			Case DOWN
				DrawImage(Self.sprite.image, Self.x, Self.y)
			Case TARGETED
				DrawImage(Self.sprite.image, Self.x, Self.y, Self.rotation, 1, 1)
					
				
		End Select
		
	End
End









'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************




Global TaiPowerUplist:List<TaiPowerUp> = new List<TaiPowerUp>

Const TAIPOWERUP:Int = 1
Const TAIPOWERDOWN:Int = 2
Const TAISPEED:Int = 3
Const TAISLOW:Int = 4
Const TAIBOMB:Int = 5
Const TAIHEART:Int = 6


Class TaiPowerUp
	Field x:Int
	Field y:Int
	Field life:Int
	Field sprite:GameImage
	Field type:Int
	Field pts:Int
	Field color:int
	
	Method new(_x:Int, _y:Int, _power)
		powerupdropsound.Play()
		Self.x = _x
		Self.y = _y
		Self.type = _power
		Self.life = 10
		
		select _power
			Case TAIPOWERUP
				Self.sprite = diddyGame.images.Find("game1_powerup")
				Self.pts = 100
				Self.color = RED
			Case TAIPOWERDOWN
				Self.sprite = diddyGame.images.Find("game1_powerdown")
				Self.pts = -100
				Self.color = BLUE
			Case TAIBOMB
				Self.life = 4
				Self.sprite = diddyGame.images.Find("game1_powerbomb")
				Self.pts = 100
				Self.color = RED
			Case TAISPEED
				Self.sprite = diddyGame.images.Find("game1_powerspeed")
				Self.pts = -100
				Self.color = BLUE
			Case TAISLOW
				Self.sprite = diddyGame.images.Find("game1_powerslow")
				Self.pts = 100
				Self.color = RED
			Case TAIHEART
				Self.sprite = diddyGame.images.Find("game1_fullheart")
				Self.color = RED
				Self.pts = 1000
				Self.life = 1
		End select
				
		
		TaiPowerUplist.AddLast(self)
	End
	
	Method update()
		Self.y += 2 * dt.delta
		
		if Self.y > 640 Then self.life = 0

		'power hit the player
		if RectsOverlap(TaiPlayer.x - 20, TaiPlayer.y - 20, 40, 40, Self.x - 20, Self.y - 20, 40, 40) And TaiPlayer.phase=0
			'Print "Hit"
			Self.life = 0
			poweruppicksound.Play()
			
			select Self.type
				Case TAIPOWERUP
					if TaiPlayer.power <= 2 then TaiPlayer.power += 1
					CreateRing(TaiPlayer.x, TaiPlayer.y, RED)
					
				Case TAIPOWERDOWN
					if TaiPlayer.power >= 2 then TaiPlayer.power -= 1
					CreateRing(TaiPlayer.x, TaiPlayer.y, BLUE)
					
				Case TAIBOMB
					CreateRing(TaiPlayer.x, TaiPlayer.y, RED)
					
					For Local px:Int = 1 to SCREEN_WIDTH / 50
						Local xb:Tai_Bullet = new Tai_Bullet(px * 50, 400, UP, RED)
					next
					
				Case TAISPEED
					CreateRing(TaiPlayer.x, TaiPlayer.y, BLUE)
					if TaiBaseSpeed < 10 TaiBaseSpeed += 0.25
					
				Case TAISLOW
					CreateRing(TaiPlayer.x, TaiPlayer.y, RED)
					if TaiBaseSpeed >= 0.5 Then TaiBaseSpeed -= 0.25
					
				Case TAIHEART
					CreateRing(TaiPlayer.x, TaiPlayer.y, RED)
					TaiPlayer.life += 1
			End select		
					
		EndIf
		
		if Self.life <= 0 Then TaiPowerUplist.Remove(Self)
	End
	
	Method draw()
		DrawImage(Self.sprite.image, Self.x, Self.y)

	End
End










'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************





Global cParticleList:List<cParticle> = new List<cParticle>

#Rem
	summary: Particle Manager
	Basic Particle Manager, wont bother with emiiters.
#END
Class cParticle
	'position
	Field x:float
	field y:Float
	Field dx:Float
	Field dy:float
	Field angle:float
	Field force:float
	
	
	'environment
	Field gravity:Float
	Field friction:Float
	
	Field winddirection:Float
	Field windrange:Float
	Field windforce:Float
	
	
	'data
	Field life:float
	Field sprite:GameImage
	
	Method new(_x:float, _y:float, _color:int)
		Self.x = _x
		Self.y = _y
		Self.angle = Rnd( - 180, 180)
		Self.dx = Sin(Self.angle)
		Self.dy = Cos(Self.angle)
		Self.force = Rnd(10, 15)
		
		Self.gravity = 0.2
		self.friction = 0.9
		Self.life = 100
		
		
		Select _color
			Case BLUE
				Self.sprite = diddyGame.images.Find("game1_bluebit" + int(Rnd(1, 3)))
			Case GREEN
				Self.sprite = diddyGame.images.Find("game1_greenbit" + int(Rnd(1, 3)))
			Case ORANGE
				Self.sprite = diddyGame.images.Find("game1_orangebit" + int(Rnd(1, 3)))
			Case PURPLE
				Self.sprite = diddyGame.images.Find("game1_purplebit" + int(Rnd(1, 3)))
			Case RED
				Self.sprite = diddyGame.images.Find("game1_redbit" + int(Rnd(1, 3)))
		End select
		
		cParticleList.AddLast(Self)
	End Method
	
	Method updatevector()
		Self.dx = Sin(Self.angle)
		Self.dy = Cos(Self.angle)
	End Method
	
	Method update()
	
		'move
		Self.x += (self.dx * Self.force) * dt.delta
		Self.y += (Self.dy * Self.force) * dt.delta
		
		'apply env
		if self.friction <> 0 then Self.force *= Self.friction
		if gravity <> 0 then
				Self.gravity += (0.2 * dt.delta)
				Self.y += (Self.gravity * dt.delta)
		EndIf
		
		if Self.life <= 0 or (Self.x < 0) or (Self.y < 0) or (Self.x > DEVICE_WIDTH) or (Self.y > DEVICE_HEIGHT)
			cParticleList.Remove(Self)
		EndIf
		
	End Method
	
	Method draw()
		DrawImage Self.sprite.image, Self.x, Self.y
	End Method
	
	Method new(_x:float, _y:float, _gravity:float, _friction:float, _winddirection:float, _windrange:float, _windforce:float, _life:float)
		'for a more complex particle.
		'probably not gona need this tho.
	End Method
	
	
End Class



'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************
'*********************************************************************************************

#Rem
	summary: Create a burst of particles.
#END
Function CreateBang:void(_x:Int, _y:Int, _color:Int = BLUE, _count:int = 20)
	
	For Local loop:Int = 1 to _count
		Local part:cParticle = new cParticle(_x, _y, _color)
	Next
		
End Function


Function CreateRing:void(_x:Int, _y:Int, _color:Int = BLUE)
	local loop:Int
	For loop = 1 to 360 step 12
		Local part:cParticle = new cParticle(_x, _y, _color)
			part.gravity = 0
			part.friction = 0
			part.angle = loop
			part.updatevector()
	Next
End function


Function CreateShatter:void(_x:Int, _y:Int, _count:int = 20, _color = RED)
	For Local loop:Int = 1 to _count
		Local part:cParticle = new cParticle(_x, _y, _color)
		part.friction = 0
		part.gravity = 0
		part.angle = 180 + Rnd( - 30, 30)
		part.updatevector()
	Next	
End Function


#Rem
	summary: Check if the player is touching the ship.
	Once the player grabs the ship , match the ships x position to the players finger x, or mouse x.
	paramaters take are x,y,width,height,handle.
	Handle can be 1 - left or 2 - mid.
#END
Function Tai_Touching:Bool(_x:Int, _y:Int, _w:Int, _h:int, _handle:Int = 1)
	Local result:Bool = false
	
		Select _handle
			Case 1 ' left
				if TouchX() > _x And TouchX() < (_x + _w) And TouchY() > _y And TouchY() < (_y + _h)
					result = true
				EndIf			
			Case 2 ' mid
				if TouchX() > _x - (_w / 2) And TouchX() < _x + (_w / 2) And TouchY() > _y - (_h / 2) And TouchY() < _y + (_h / 2)
					result = true
				EndIf			
		End

	
	Return result
End






'summary:Shunts down every alien alive if any alien reaches the side of the screen.
	Function ShuntDown()
	
		For Local t:Tai_Alien = eachin TaiAlienList
			t.y += 10  ' (10 + (TaiWave / 2))
	
			Select t.dir
				Case 1
					t.dir = 2
				Case 2
					t.dir = 1
			End
			
		Next
	End

	
	
	
Global TaiWave:Int = 0
Global TaiBaseSpeed:Float = 0

#Rem
	summary: Creates alien waves.
	waves are created based on current level, and current base speed, which increases a little each new level
	making the ships travel faster the further you progress.
#END
Function CreateWave(_wave:Int = 1)
	
	'level structure, 10 aliens, so 10 waves.
	'after wave ten change alien colour start again but increase
	'thei health and their shooting speed.
	'by stage 4, or 5, it should be dodge and bullet hell. :P

	TaiBaseSpeed = (_wave * 0.25)
	
	
	
	Local _speed:Int = 1
	Local _ship:Int = 1
	Local _color:Int = 1
	Local _life:Int
		
	select true
	
		Case(_wave > 0 and _wave < 11) '1-10
			
			_ship = _wave
			_color = GREEN
			_life = 1
			
		Case(_wave >= 11 And _wave <= 20) '11-20
			
			_ship = (_wave - 10)
			_color = BLUE
			_life = 2
			
		Case(_wave >= 21 And _wave <= 30)
			
			_ship = (_wave - 20)
			_color = PURPLE
			_life = 3
			
		Case(_wave >= 31 And _wave <= 40)
			
			_ship = (_wave-30)
			_color = ORANGE
			_life = 4
		
	End

	Local ta:Tai_Alien
	For Local y:Int = 0 to 3
		For Local x:Int = 0 to 6
			ta = New Tai_Alien(50 + (x * 50), 50 + (y * 50), _life, _color, _ship, _speed)
			CreateRing(50 + (x * 50), 50 + (y * 50), _color)
		Next
	Next
	
End Function



#Rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#end