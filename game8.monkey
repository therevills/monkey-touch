Strict

#rem
header:
[quote]

[b]File Name :[/b] Game8Screen
[b]Author    :[/b] firstname "alias" lastname
[b]About     :[/b]
what it is..
[/quote]
#end

Import main

Global gameScreen:GameScreen
Global gameOverScreen:GameOverScreen
Global nextLevelScreen:NextLevelScreen
Global debugOn:Bool = False
Global player:Player

#rem
summary:Title Screen Class.
Used to manage and deal with all Tital Page stuff.
#End
Class Game8Screen Extends Screen
	Field logo:GameImage
	Field menu:SimpleMenu
	Field star:Star[1024]

	
	Method New()
		name = "Tower Defense"
		Local gameid:Int = 8
		GameList[gameid - 1] = New miniGame
		GameList[gameid - 1].id = gameid - 1
		GameList[gameid - 1].name = "Tower Defense"
		GameList[gameid - 1].iconname = "game" + gameid + "_icon"
		GameList[gameid - 1].thumbnail = "game" + gameid + "_thumb"
		GameList[gameid - 1].author = "Steven Revill"
		GameList[gameid - 1].authorurl = "therevillsgames.com"
		GameList[gameid - 1].info = "Tower Defense Info"
		
		player = New Player()
	End
	
	#rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		gameScreen = New GameScreen
		gameOverScreen = New GameOverScreen
		nextLevelScreen = New NextLevelScreen
		
		diddyGame.images.Load("game8/titleLogo.png")
		logo = diddyGame.images.Find("titleLogo")
		
		menu = New SimpleMenu("ButtonOver", "ButtonClick", 0, 290, 50, True, VERTICAL)
		menu.AddButton("game8/playButton.png", "game8/playButtonMO.png")
		menu.AddButton("game8/backButton.png", "game8/backButtonMO.png")
		
		For Local t:Int = 0 Until star.Length
			star[t] = New Star
		Next
		
		Unit.list.Comparator = New UnitComparator()
		
		#IF TARGET="glfw"
			diddyGame.MusicPlay("HomeBaseGroove.wav", True)
		#ELSE
			diddyGame.MusicPlay("HomeBaseGroove.mp3", True)
		#END
		
	End
		
	#rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		For Local t:Int = 0 Until star.Length
			star[t].Draw()
		Next
		logo.Draw(SCREEN_WIDTH2, 100)
		menu.Draw()
		Local y:Int = 130
		Local gap:Int = 30
		gameScreen.font20.DrawText("By", SCREEN_WIDTH2, y, eDrawAlign.CENTER)
		y += gap
		gameScreen.font20.DrawText("Steven Revill", SCREEN_WIDTH2, y, eDrawAlign.CENTER)
		y += gap
		gameScreen.font16.DrawText("(www.therevillsgames.com)", SCREEN_WIDTH2, y, eDrawAlign.CENTER)
		y += gap
		gameScreen.font16.DrawText("Game Graphics by Daniel Cook (Lostgarden.com)", SCREEN_WIDTH2, y, eDrawAlign.CENTER)
		y += gap
		gameScreen.font16.DrawText("Music by Kevin MacLeod (incompetech.com)", SCREEN_WIDTH2, y, eDrawAlign.CENTER)
	End

	#rem
	sumary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	and all use input.
	#End
	Method Update:Void()
		menu.Update()
		For Local t:Int = 0 Until star.Length
			star[t].Update()
		Next
		If KeyHit(KEY_SPACE) Or KeyHit(KEY_ENTER) Or menu.Clicked("playButton") Then
			player = New Player()
			FadeToScreen(gameScreen, defaultFadeTime, True, True, False)
		End
		
		If KeyHit(KEY_ESCAPE) Or menu.Clicked("backButton")
			FadeToScreen(TitleScr)
		End
	End
End

Class Unit Extends Sprite
	Global list:ArrayList<Unit> = New ArrayList<Unit>

	Method New(img:GameImage, x:Float, y:Float)
		Super.New(img, x, y)
	End
		
	Function DrawAll:Void()
		If Not list Return
		Local r:Unit
		For Local i:Int = 0 Until list.Size
			r = list.Get(i)
			If r <> Null Then r.Draw(diddyGame.scrollX, diddyGame.scrollY)
		Next
	End
		
	Function UpdateAll:Void()
		If Not list Return
		Local r:Unit

		For Local i:Int = 0 Until list.Size
			r = list.Get(i)
			If r <> Null Then
				r.Update()
			End
		Next	
	End
	
	Method Update:Void() Abstract
End

Class Rocket Extends Unit
	Field damage:Float
	Field range:Float
	Field target:Enemy
	Field angle:Float
	Field smokeDelay:Float
	Field slowDown:Float
	
	Method New(img:GameImage, x:Float, y:Float)
		Super.New(img, x, y)
		speed = 4
		Self.SetHitBox(-2, -2, 2, 2)
		list.Add(Self)
	End
	
	Method Kill:Void()
		If Not list Return	
		list.Remove(Self)
	End
	
	Method Update:Void()
		Local xDist:Float = target.x - x
		Local yDist:Float = target.y - y
		Local angle:Float = ATan2(yDist, xDist)
		If angle < 0 angle += 360
		rotation = -angle - 90
				
		MoveForward()
		If smokeDelay > 1
			smokeDelay = 0
			Local p:Particle
			If slowDown > 0
				p = Particle.Create(diddyGame.images.Find("slowBullet"), x, y, 0, 0, 0, 500)
				p.rotation = rotation
			Else
				p = Particle.Create(gameScreen.smokeImage, x, y, -dx / 10, -dy / 10, 0, 500)
				p.SetupRotation(1, 300, True, True)
			End
			
		Else
			smokeDelay += 1 * dt.delta
		End
		
		range -= speed
		
		If Collide(target) Then
			target.health -= Self.damage
			target.slowDown = diddyGame.CalcAnimLength(slowDown)
			New Explosion(gameScreen.explosionSmallImage, Self.x, Self.y, 6, 100)
			Kill()
		End
		
		If range < 0
			Kill()
		End
	End
End

Class UnitTemplate
	Field name:String
	Field desc:String
	Field gunImageName:String
	Field damage:Float
	Field damageBonus:Float
	Field range:Float
	Field fireRate:Int
	Field health:Float
	Field score:Int
	Field imageName:String
	Field speed:Float
	Field cost:Int
	Field firePosX:Float
	Field firePosY:Float
	Field fireType:Int
	Field slowDown:Float
End

Class TankEnemy Extends Enemy
	Method New(name:String, x:Float, y:Float)
		Super.New(diddyGame.images.Find(gameScreen.enemyTemplateMap.Get(name.ToUpper()).imageName), x, y, name)
	End
End

Class Enemy Extends Unit Abstract
	Field currentPath:Int = 0
	Field damage:Float
	Field range:Float
	Field fireRate:Int
	Field health:Float
	Field alive:Bool
	Field route:Int[]
	Field score:Int
	Field slowDown:Float
	Field oSpeed:Float
	
	Method New(img:GameImage, x:Float, y:Float, name:String)
		Super.New(img, x, y)
		SetStats(name)
		oSpeed = speed
		SetPath()
		list.Add(Self)
	End
	
	Method SetStats:Void(name:String)
		Local et:UnitTemplate = gameScreen.enemyTemplateMap.Get(name.ToUpper())
		Self.fireRate = et.fireRate
		Self.damage = et.damage
		Self.range = et.range
		Self.health = et.health
		Self.speed = et.speed
		Self.alive = True
		Self.score = et.score
	End
	
	Method Kill:Void()
		If Not list Return	
		list.Remove(Self)
	End
	
	Method Update:Void()
		If currentPath >= 0 And PathFinder.route.Length() > 0
			Local angle:Float = CalcAngle(x, y, route[currentPath] * gameScreen.TILE_SIZE, route[currentPath + 1] * gameScreen.TILE_SIZE)

			dx = Cos(angle) * speed
			dy = Sin(angle) * speed
			
			Self.Move()
			
			If angle > 22.5 And angle < 67.5
			' down right
				frame = 0
			Elseif angle > 67.5 And angle < 112.5
			' down
				frame = 1
			Elseif angle > 112.5 And angle < 157.5
			' down left
				frame = 2
			Elseif angle > 157.5 And angle < 202.5
			' left
				frame = 5
			Elseif angle > 202.5 And angle < 247.5
			' up left
				frame = 8
			Elseif angle > 247.5 And angle < 292.5
			' up
				frame = 7
			Elseif angle > 292.5 And angle < 337.5
			' up right
				frame = 6
			Else
			' right
				frame = 3
			End
	
			If PointInSpot(x, y, route[currentPath] * gameScreen.TILE_SIZE, route[currentPath + 1] * gameScreen.TILE_SIZE, 3)
				currentPath -= 2
				If currentPath < 0
					gameScreen.health -= damage
					gameScreen.hurtSound.Play()
					alive = False
					Kill()
				End
			End
		End
		If slowDown > 0
			speed = oSpeed / 2
			slowDown -= 1 * dt.delta
		Else
			speed = oSpeed
		End
		
		If Self.health <= 0
			gameScreen.cash += Self.score
			alive = False
			gameScreen.vexplosion.Play()
			New Explosion(gameScreen.explosionImage, x, y, 8, 100)
			Kill()
		End
	End
	
	Method SetPath:Void()
		Local startPos:TileMapObject = gameScreen.tilemap.FindObjectByName("Start")
		Local endPos:TileMapObject = gameScreen.tilemap.FindObjectByName("End")
		PathFinder.FindPath(startPos.x / gameScreen.TILE_SIZE, startPos.y / gameScreen.TILE_SIZE, endPos.x / gameScreen.TILE_SIZE, endPos.y / gameScreen.TILE_SIZE)
		route = PathFinder.route
		currentPath = (PathFinder.paths - 1) * 2
		x = startPos.x
		y = startPos.y
	End
End

Class TurretTower Extends Tower
	Method New(name:String, x:Float, y:Float)
		Super.New(diddyGame.images.Find(gameScreen.towerTemplateMap.Get(name.ToUpper()).imageName), x, y, name)
	End
End

' Towers are NOT midhandled!
Class Tower Extends Unit Abstract
	Field damage:Float
	Field damageBonus:Float
	Field range:Float
	Field lastFire:Float
	Field fireRate:Int
	Field health:Float
	Field target:Enemy
	Field targetDist:Float
	Field firePosX:Int, firePosY:Int
	Field drawLine:Bool
	Field drawLineTime:Float
	Field cost:Int
	Field fireType:Int
	Field dx1:Int, dy1:Int, dx2:Int, dy2:Int
	Field selected:Bool
	Field gunImage:GameImage
	Field gunFrame:Int
	Field gunAngle:Float
	Field slowDown:Float
	
	Const LAZER:Int = 0
	Const ROCKET:Int = 1
	Const SLOW:Int = 2
	
	Method New(img:GameImage, x:Float, y:Float, name:String)
		Super.New(img, x, y)
		SetStats(name)
		list.Add(Self)
	End
	
	Method SetStats:Void(name:String)
		Local t:UnitTemplate = gameScreen.towerTemplateMap.Get(name.ToUpper())
		Self.damage = t.damage
		Self.damageBonus = t.damageBonus
		Self.range = t.range
		Self.health = t.health
		Self.fireRate = t.fireRate
		Self.cost = t.cost
		Self.firePosX = x + Self.image.w2 + t.firePosX
		Self.firePosY = y + Self.image.h2 + t.firePosY
		If t.gunImageName <> "" Then
			Self.gunImage = diddyGame.images.Find(t.gunImageName)
		End
		Self.fireType = t.fireType
		Self.slowDown = t.slowDown
		Self.selected = False
	End
	
	Method Kill:Void()
		If Not list Return
		list.Remove(Self)
	End
	
	Method Draw:Void(offsetX:Float, offsetY:Float, rounded:Bool = False)
		If selected
			SetAlpha 0.2
			DrawCircle(firePosX - diddyGame.scrollX, firePosY - diddyGame.scrollY, range)
			SetAlpha 1
		End
		Super.Draw(diddyGame.scrollX, diddyGame.scrollY)

		If drawLine
			SetColor 255, 0, 0
			DrawLineThick(dx1 - diddyGame.scrollX, dy1 - diddyGame.scrollY, dx2 - diddyGame.scrollX, dy2 - diddyGame.scrollY, 4)
			SetColor 255, 255, 255
			DrawLine dx1 - diddyGame.scrollX, dy1 - diddyGame.scrollY, dx2 - diddyGame.scrollX, dy2 - diddyGame.scrollY
		End
		If gunImage <> Null
			gunImage.Draw(firePosX - diddyGame.scrollX, firePosY - diddyGame.scrollY, gunAngle, 1, 1, gunFrame)
		End
	End
	
	Method SetGunAngle:Void(angle:Float)
		gunAngle = -angle - 90
	
		If angle > 22.5 And angle < 67.5
		' down right
			gunAngle -= 45 * 5
			gunFrame = 3
		Elseif angle > 67.5 And angle < 112.5
		' down
			gunAngle -= 45 * 4
			gunFrame = 4
		Elseif angle > 112.5 And angle < 157.5
		' down left
			gunAngle -= 45 * 3
			gunFrame = 5
		Elseif angle > 157.5 And angle < 202.5
		' left
			gunAngle -= 45 * 2
			gunFrame = 6
		Elseif angle > 202.5 And angle < 247.5
		' up left
			gunAngle -= 45
			gunFrame = 7
		Elseif angle > 247.5 And angle < 292.5
		' up
			gunFrame = 0
		Elseif angle > 292.5 And angle < 337.5
		' up right
			gunAngle += 45
			gunFrame = 1
		Else
		' right
			gunAngle += 45 * 2
			gunFrame = 2
		End	
	
	End
	
	Method Update:Void()
		Local e:Enemy
		If Self.target And Self.target.alive
			lastFire += 1 * dt.delta
			Self.targetDist = CalcDistance(Self.firePosX, Self.firePosY, Self.target.x, Self.target.y)
			Local angle:Float = CalcAngle(Self.firePosX, Self.firePosY, Self.target.x, Self.target.y)
				
			If lastFire > fireRate
				SetGunAngle(angle)
				lastFire = 0
				Select fireType
					Case LAZER
						gameScreen.lazerSound.rate = Rnd(1, 2)
						gameScreen.lazerSound.Play()
						Self.drawLine = True
						dx1 = Self.firePosX
						dy1 = Self.firePosY
						dx2 = Self.target.x
						dy2 = Self.target.y
						Self.target.health -= Self.damage + Rnd(0, Self.damageBonus)
						New Explosion(gameScreen.explosionSmallImage, Self.target.x, Self.target.y, 6, 100)
					Case ROCKET
						gameScreen.rocketSound.rate = Rnd(1, 2)
						gameScreen.rocketSound.Play()
						Local r:Rocket = New Rocket(diddyGame.images.Find("Rocket"), Self.firePosX, Self.firePosY)
						r.rotation = -angle - 90
						r.damage = Self.damage + Rnd(0, Self.damageBonus)
						r.range = Self.range
						r.target = target
						r.slowDown = Self.slowDown
					Case SLOW
						gameScreen.slowSound.rate = Rnd(1, 2)
						gameScreen.slowSound.Play()
						Local r:Rocket = New Rocket(diddyGame.images.Find("slowBullet"), Self.firePosX, Self.firePosY)
						r.rotation = -angle - 90
						r.damage = Self.damage + Rnd(0, Self.damageBonus)
						r.range = Self.range
						r.target = target
						r.slowDown = Self.slowDown
				 End
				
				If Self.target.health <= 0
					Self.target = Null
				End
			End
			If Self.targetDist > Self.range
				Self.target = Null
			End
		Else
			For Local i:Int = 0 Until list.Size
				e = Enemy(list.Get(i))
				If e Then
					Local dist:Float = CalcDistance(Self.firePosX, Self.firePosY, e.x, e.y)
					If Self.target And Self.target.alive
						If dist < Self.targetDist
							Self.targetDist = dist
							Self.target = e
						End
					Else
						If dist < Self.range
							Self.targetDist = dist
							Self.target = e
						End
					End
				End
			Next
		End
		If Self.drawLine
			Self.drawLineTime += 1 * dt.delta
			If Self.drawLineTime > 10
				Self.drawLineTime = 0
				Self.drawLine = False
			End
		End
	End
	
	Function UnselectTowers:Void()
		For Local u:Unit = Eachin list
			If Tower(u) Then
				Local t:Tower = Tower(u)
				t.selected = False
			End
		Next
	End
	
	Function SelectTower:Tower(x:Int, y:Int)
		Local tower:Tower
		For Local u:Unit = Eachin list
			If Tower(u) Then
				Local t:Tower = Tower(u)
				If t.x / gameScreen.TILE_SIZE = x / gameScreen.TILE_SIZE And t.y / gameScreen.TILE_SIZE = y / gameScreen.TILE_SIZE
					t.selected = True
					tower = t
					Exit
				End
			End
		Next
		Return tower
	End
End

Class Explosion Extends Sprite
	Global list:ArrayList<Explosion> = New ArrayList<Explosion>

	Method New(img:GameImage, x:Float, y:Float, frames:Int, animSpeed:Int)
		Super.New(img, x, y)
		Self.SetFrame(0, frames, animSpeed, False, False)
		list.Add(Self)
	End
	
	Method Kill:Void()
		If Not list Return
		list.Remove(Self)
	End
	
	Function DrawAll:Void()
		If Not list Return
		Local e:Explosion
		For Local i:Int = 0 Until list.Size
			e = list.Get(i)
			If e <> Null Then e.Draw(diddyGame.scrollX, diddyGame.scrollY)
		Next
	End
	
	Function UpdateAll:Void()
		If Not list Return
		Local e:Explosion
		For Local i:Int = 0 Until list.Size
			e = list.Get(i)
			If e <> Null Then e.Update()
		Next
	End
	
	Method Update:Void()
		If UpdateAnimation() Then Kill()
	End
End

Class Wave
	Field sequence:Int
	Field initialDelay:Int
	Field initialDelayCounter:Float
	Field enemyMap:IntMap<EnemyWave>
	Field delay:Float
	Field enemySeq:Int
	Field currentEnemyWave:EnemyWave
	Field firstTime:Bool
	Field textAlpha:Float
	
	Method New()
		enemyMap = New IntMap<EnemyWave>
		delay = 0
		enemySeq = 1
		firstTime = True
		initialDelayCounter = 0
	End
	
	Method Update:Int()
		If initialDelayCounter > 0
			textAlpha = 1
		Else
			textAlpha -= 0.03 * dt.delta
		End
		
		If firstTime
			currentEnemyWave = enemyMap.Get(enemySeq)
			firstTime = False
		Else
			If initialDelayCounter > 0
				initialDelayCounter -= 1 * dt.delta
			Else
				If currentEnemyWave <> Null Then
					If currentEnemyWave.count < currentEnemyWave.amount Then
						delay += 1 * dt.delta
						If delay > currentEnemyWave.delay
							delay = 0
							Local startPos:TileMapObject = gameScreen.tilemap.FindObjectByName("Start")
							Local endPos:TileMapObject = gameScreen.tilemap.FindObjectByName("End")
							New TankEnemy(currentEnemyWave.type, startPos.x, startPos.y)
							currentEnemyWave.count += 1
						End
					Else
						enemySeq += 1
						currentEnemyWave = enemyMap.Get(enemySeq)
						If currentEnemyWave = Null
							Return 1
						End
					End
				Else
					Return 1
				End
			End
		End
		Return 0
	End
	
	Method Draw:Void()		
		If textAlpha > 0
			SetAlpha textAlpha
			Local countDown:Int = ( (Round(initialDelayCounter) * (1000.0 / diddyGame.FPS)) / 1000)
			Local x:Int = SCREEN_WIDTH2
			Local oy:Int = SCREEN_HEIGHT2 - 30
			Local y:Int = oy
			Local gap:Int = gameScreen.font20.GetFontHeight() +5
			
			SetColor 0, 0, 0
			For Local i:Int = 0 To 1
				If i = 1
					y = oy
					SetColor 255, 255, 255
					x -= 4
					y -= 4
				End
				gameScreen.font20.DrawText("NEXT WAVE IN...", x, y, eDrawAlign.CENTER)
				y += gap
				gameScreen.font20.DrawText(countDown, x, y, eDrawAlign.CENTER)
			Next
			
			SetAlpha 1
			SetColor 255, 255, 255
		End
	End
End

Class EnemyWave
	Field sequence:Int
	Field type:String
	Field delay:Int
	Field amount:Int
	Field count:Int
End

Class Player
	Field score:Int
	Field level:Int
	
	Method New()
		score = 0
		level = 1
	End
End

Class GameScreen Extends Screen
	Const TILE_SIZE:Int = 20
	Field tilemap:MyTileMap
	Field x:Float, y:Float
	Field grid:Float[]
	Field enemyImage:GameImage
	Field turretBaseImage:GameImage
	Field turretGunImage:GameImage
	Field selectedTower:Tower
	Field delay:Float, maxDelay:Int = 100
	Field buildableLayerOn:Bool = False
	Field gridOn:Bool = False
	Field explosionImage:GameImage
	Field explosionBigImage:GameImage
	Field explosionSmallImage:GameImage
	Field smokeImage:GameImage
	Field gui:Gui
	Field cash:Int
	Field health:Int
	Field maxHealth:Float
	Field gameScrollSpeed:Int = 5
	Field enemyTemplateMap:StringMap<UnitTemplate>
	Field towerTemplateMap:StringMap<UnitTemplate>
	Field level:Int
	Field mapFileName:String
	Field mapName:String
	Field waveMap:IntMap<Wave>
	Field waveCount:Int
	Field currentWave:Wave
	Const MAX_LEVELS:Int = 4
	
	Field font12:BitmapFont2
	Field font16:BitmapFont2
	Field font20:BitmapFont2
	
	Field flagList:ArrayList<Sprite>
	
	Field lazerSound:GameSound
	Field rocketSound:GameSound
	Field slowSound:GameSound
	Field vexplosion:GameSound
	Field hurtSound:GameSound
	
	Method New()
		name = "Tower Defense GameScreen"
		LoadFonts()
	End
	
	Method LoadFonts:Void()
		font12 = New BitmapFont2("fonts/joystix_12.txt", True)
		font16 = New BitmapFont2("fonts/joystix_16.txt", True)
		font20 = New BitmapFont2("fonts/joystix_20.txt", True)
	End
	
	Method LoadEnemyData:Void()
		' load enemy data
		Local file:String = "graphics/game8/enemies.xml"
		Local xmlReader:XMLParser = New XMLParser
		Local doc:XMLDocument = xmlReader.ParseFile(file)
		Local rootElement:XMLElement = doc.Root
		For Local xml:XMLElement = Eachin rootElement.GetChildrenByName("enemy")
			Local t:UnitTemplate = New UnitTemplate()
			
			t.name = xml.GetFirstChildByName("name").Value
			t.imageName = xml.GetFirstChildByName("image").Value
			t.damage = Int(xml.GetFirstChildByName("damage").Value)
			t.range = Float(xml.GetFirstChildByName("range").Value)
			t.health = Float(xml.GetFirstChildByName("health").Value)
			t.speed = Float(xml.GetFirstChildByName("speed").Value)
			t.score = Int(xml.GetFirstChildByName("score").Value)
			
			enemyTemplateMap.Add(t.name.ToUpper(), t)
		Next	
	End
	
	Method LoadTowerData:Void()
		' load enemy data
		Local file:String = "graphics/game8/towers.xml"
		Local xmlReader:XMLParser = New XMLParser
		Local doc:XMLDocument = xmlReader.ParseFile(file)
		Local rootElement:XMLElement = doc.Root
		For Local xml:XMLElement = Eachin rootElement.GetChildrenByName("tower")
			Local t:UnitTemplate = New UnitTemplate()
			
			t.name = xml.GetFirstChildByName("name").Value
			t.desc = xml.GetFirstChildByName("desc").Value
			t.imageName = xml.GetFirstChildByName("image").Value
			t.gunImageName = xml.GetFirstChildByName("gunImage").Value
			t.damage = Float(xml.GetFirstChildByName("damage").Value)
			t.damageBonus = Float(xml.GetFirstChildByName("damageBonus").Value)
			t.range = Float(xml.GetFirstChildByName("range").Value)
			t.health = Float(xml.GetFirstChildByName("health").Value)
			t.fireRate = diddyGame.CalcAnimLength(Int(xml.GetFirstChildByName("fireRate").Value))
			t.cost = Int(xml.GetFirstChildByName("cost").Value)
			t.firePosX = Float(xml.GetFirstChildByName("firePosX").Value)
			t.firePosY = Float(xml.GetFirstChildByName("firePosY").Value)
			Local fireType:String = xml.GetFirstChildByName("fireType").Value
			Select fireType.ToUpper()
				Case "ROCKET"
					t.fireType = Tower.ROCKET
				Case "LAZER"
					t.fireType = Tower.LAZER
				Case "SLOW"
					t.fireType = Tower.SLOW
			End
			t.slowDown = Float(xml.GetFirstChildByName("slowDown").Value)
			
			towerTemplateMap.Add(t.name.ToUpper(), t)
		Next
	End
	
	Method LoadLevelData:Void(level:Int)
		' load level data
		Local file:String = "graphics/game8/level" + level + ".xml"
		Local xmlReader:XMLParser = New XMLParser
		Local doc:XMLDocument = xmlReader.ParseFile(file)
		Local rootElement:XMLElement = doc.Root
		
		For Local xml:XMLElement = Eachin rootElement.GetChildrenByName("data")
			mapName = xml.GetFirstChildByName("name").Value
			cash = Int(xml.GetFirstChildByName("cash").Value)
			mapFileName = xml.GetFirstChildByName("map").Value
			
			For Local waveXml:XMLElement = Eachin xml.GetChildrenByName("wave")
				Local wave:Wave = New Wave()
				wave.sequence = Int(waveXml.GetFirstChildByName("sequence").Value)
				wave.initialDelay = diddyGame.CalcAnimLength(Int(waveXml.GetFirstChildByName("initialDelay").Value))
				wave.initialDelayCounter = wave.initialDelay
				For Local enemiesXml:XMLElement = Eachin waveXml.GetChildrenByName("enemies")
				
					For Local enemyXml:XMLElement = Eachin enemiesXml.GetChildrenByName("enemy")
						Local ew:EnemyWave = New EnemyWave()
						ew.sequence = Int(enemyXml.GetFirstChildByName("sequence").Value)
						ew.type = enemyXml.GetFirstChildByName("type").Value
						ew.amount = Int(enemyXml.GetFirstChildByName("amount").Value)
						ew.delay = diddyGame.CalcAnimLength(Int(enemyXml.GetFirstChildByName("delay").Value))
						wave.enemyMap.Add(ew.sequence, ew)
					Next
					
				Next
				
				waveMap.Add(wave.sequence, wave)
				
			Next
			
		Next
		
		
		' calculate the max damage based off the number of enemies per level
		Local maxDamage:Float
		For Local waveKey:Int = Eachin waveMap.Keys()
			Local wave:Wave = waveMap.Get(waveKey)
			For Local enemyKey:Int = Eachin wave.enemyMap.Keys()
				Local enemyWave:EnemyWave = wave.enemyMap.Get(enemyKey)
				Local amount:Int = enemyWave.amount
				Local type:String = enemyWave.type
				Local t:UnitTemplate = enemyTemplateMap.Get(type.ToUpper())
				maxDamage += t.damage * amount
			Next
		Next
		
		' then set the health to be half that
		maxHealth = maxDamage / 2
		health = maxHealth
		
	End
	
	Method LoadData:Void()
		LoadEnemyData()
		LoadTowerData()
		LoadLevelData(player.level)
	End
	
	Method LoadMap:Void()
		Local reader:MyTiledTileMapReader = New MyTiledTileMapReader
		Local tm:TileMap = reader.LoadMap("graphics/game8/" + mapFileName + ".tmx")
		tilemap = MyTileMap(tm)
		Local startPos:TileMapObject = tilemap.FindObjectByName("Start")
		Local endPos:TileMapObject = tilemap.FindObjectByName("End")

		Local layer:TileMapTileLayer = tilemap.FindLayerByName(tilemap.COLLISION_LAYER)
		grid = New Float[tilemap.width * tilemap.height]
		
		' convert the tile map to a float grid for the pathfinder
		For Local i:Int = 0 Until layer.mapData.tiles.Length
			grid[i] = layer.mapData.tiles[i]
		Next
		
		' set the map for the pathfinder using diagonals(2) and randomise it a tad(1)
		PathFinder.SetMap(grid, tilemap.width, tilemap.height, 2, 1)
		
		' flags 1 and 2 are the start
		' flags 3 and 4 are the end
		flagList = New ArrayList<Sprite>
		Local img:String = "flagGreen"
		For Local i:Int = 1 To 4
			Local flag:TileMapObject = tilemap.FindObjectByName("flag" + i)
			If i > 2 Then
				img = "flag"
			End
			Local flagSprite:Sprite = New Sprite(diddyGame.images.Find(img), flag.x, flag.y)
			flagSprite.SetFrame(0, 4, 100, True, True)
			flagList.Add(flagSprite)
		Next

	End
	
	Method LoadImages:Void()
		Local tmpImage:Image
		Local path:String = "game8/"
		
		enemyImage = diddyGame.images.LoadAnim(path + "tank7.png", 20, 20, 9, tmpImage)
		diddyGame.images.LoadAnim(path + "Tank5b.png", 20, 20, 9, tmpImage)
		diddyGame.images.LoadAnim(path + "hardtank.png", 40, 40, 9, tmpImage)
		turretBaseImage = diddyGame.images.LoadAnim(path + "turretBase.png", 40, 28, 2, tmpImage, False)
		
		diddyGame.images.LoadAnim(path + "Artil3.png", 40, 40, 9, tmpImage, False)
		
		diddyGame.images.LoadAnim(path + "flag.png", 20, 20, 5, tmpImage)
		diddyGame.images.LoadAnim(path + "flaggreen.png", 20, 20, 5, tmpImage)
		
		diddyGame.images.Load(path + "rocket.png")
		diddyGame.images.Load(path + "slowBullet.png")
		smokeImage = diddyGame.images.Load(path + "smoke.png")
		diddyGame.images.Load(path + "empty.png")
		
		diddyGame.images.Load(path + "ArtilBase.png", "", False)
		diddyGame.images.LoadAnim(path + "ArtilGun.png", 40, 40, 8, tmpImage)
		diddyGame.images.LoadAnim(path + "slowGun.png", 40, 40, 8, tmpImage)

		turretGunImage = diddyGame.images.LoadAnim(path + "turretGun.png", 52, 45, 8, tmpImage)
		explosionImage = diddyGame.images.LoadAnim(path + "explosn.png", 20, 20, 9, tmpImage)
		explosionBigImage = diddyGame.images.LoadAnim(path + "exploBig.png", 40, 40, 14, tmpImage)
		explosionSmallImage = diddyGame.images.LoadAnim(path + "expSmall.png", 20, 20, 7, tmpImage)
		
		diddyGame.images.Load("game8/gui.png", "", False)
	End
	
	Method LoadSounds:Void()
		lazerSound = diddyGame.sounds.Load("Firelaser",,, 250)
		rocketSound = diddyGame.sounds.Load("Firemissile",,, 250)
		rocketSound.volume = 0.35
		slowSound = diddyGame.sounds.Load("slow",,, 250)
		slowSound.volume = 0.25
		vexplosion = diddyGame.sounds.Load("vexplosion",,, 250)
		hurtSound = diddyGame.sounds.Load("Hurt",,, 250)
	End
	
	Method Start:Void()
		enemyTemplateMap = New StringMap<UnitTemplate>
		towerTemplateMap = New StringMap<UnitTemplate>
		waveMap = New IntMap<Wave>
		
		diddyGame.scrollX = TILE_SIZE
		diddyGame.scrollY = TILE_SIZE
		delay = maxDelay
		LoadData()
		LoadImages()
		LoadSounds()
		LoadMap()

		gui = New Gui
		waveCount = 1
		currentWave = waveMap.Get(waveCount)
		
	End
	
	Method Render:Void()
		Unit.list.Sort() ' add a z-order order via the y coordinate
		
		Cls
		tilemap.RenderMap(diddyGame.scrollX, diddyGame.scrollY, SCREEN_WIDTH, SCREEN_HEIGHT)

		For Local f:Sprite = Eachin flagList
			f.Draw(diddyGame.scrollX, diddyGame.scrollY)
		Next
		
		If gridOn
			'Draw grid lines
			SetColor 255, 255, 255
			SetAlpha 0.3
			For Local fx:Int = 0 To tilemap.width
				DrawLine fx * TILE_SIZE - diddyGame.scrollX, 0 - diddyGame.scrollY, fx * TILE_SIZE - diddyGame.scrollX, tilemap.width * TILE_SIZE - diddyGame.scrollY
				DrawLine 0 - diddyGame.scrollX, fx * TILE_SIZE - diddyGame.scrollY, tilemap.width * TILE_SIZE - diddyGame.scrollX, fx * TILE_SIZE - diddyGame.scrollY
			Next
			SetAlpha 1
		End
		
		If buildableLayerOn
			SetColor 255, 0, 0
			SetAlpha 0.3
			Local layer:TileMapTileLayer = tilemap.FindLayerByName(gameScreen.tilemap.BUILD_LAYER)

			For Local fx:Int = 0 Until tilemap.width
				For Local fy:Int = 0 Until tilemap.height
					If layer.mapData.Get(fx, fy) > 0
						DrawRect fx * TILE_SIZE - diddyGame.scrollX, fy * TILE_SIZE - diddyGame.scrollY, TILE_SIZE, TILE_SIZE
					End
				Next
			Next
			SetAlpha 1
			SetColor 255, 255, 255
		End
		
		Unit.DrawAll()
		Explosion.DrawAll()
		Particle.DrawAll(diddyGame.scrollX, diddyGame.scrollY)
		
		If gui.mode = gui.TURRET
			Local nx:Float = Floor( (diddyGame.mouseX + diddyGame.scrollX) / TILE_SIZE)
			Local ny:Float = Floor( (diddyGame.mouseY + diddyGame.scrollY) / TILE_SIZE)
			nx = nx * TILE_SIZE - diddyGame.scrollX
			ny = ny * TILE_SIZE - diddyGame.scrollY

			Local tower:UnitTemplate = towerTemplateMap.Get(gui.selectedButton.ToUpper())
			Local img:GameImage = diddyGame.images.Find(tower.imageName)
			Local gimg:GameImage = diddyGame.images.Find(tower.gunImageName)
			img.Draw(nx, ny)
			If gimg <> Null Then
				gimg.Draw(nx + tower.firePosX + img.w2, ny + tower.firePosY + img.h2)
			End
		End
		
		gui.Draw()
		
		If currentWave <> Null Then currentWave.Draw()

		If debugOn Then DrawDebugInfo()
	End

	Method DrawDebugInfo:Void()
		Local y:Int = 10
		Local gap:Int = 13
		SetAlpha 0.4
		If gridOn
			DrawText "Grid: On (F1)", 10, y
		Else
			DrawText "Grid: Off (F1)", 10, y
		End
		
		y += gap
		
		If buildableLayerOn
			DrawText "Build Layer: On (F2)", 10, y
		Else
			DrawText "Build Layer: Off (F2)", 10, y
		End
		SetAlpha 1
	End

	Method UpdateWave:Void()
		If currentWave <> Null Then
			If currentWave.Update()
				waveCount += 1
				currentWave = waveMap.Get(waveCount)
			End
		End	
	End
	
	Method Update:Void()
		For Local f:Sprite = Eachin flagList
			f.UpdateAnimation()
		Next
		
		UpdateWave()
		Unit.UpdateAll()
		Explosion.UpdateAll()
		Particle.UpdateAll()
		Controls()
		CheckLevel()
	End
	
	Method CheckLevel:Void()
		' game over
		If health <= 0 Then
			health = 0
			FadeToScreen(gameOverScreen, defaultFadeTime, True, True, False)
		End
		
		' win
		Local found:Bool = False
		For Local u:Unit = Eachin Unit.list
			If Enemy(u) Then
				found = True
				Exit
			End
		Next
		
		If Not found And currentWave = Null Then
			FadeToScreen(nextLevelScreen, defaultFadeTime, True, True, True)
		End
	End
	
	Method Controls:Void()
		gui.Update()
		If debugOn
			If KeyHit(KEY_SPACE)
				Local startPos:TileMapObject = tilemap.FindObjectByName("Start")
				Local endPos:TileMapObject = tilemap.FindObjectByName("End")
				New TankEnemy("EasyTank", startPos.x, startPos.y)
			End
			If KeyHit(KEY_F2)
				buildableLayerOn = Not buildableLayerOn
			End
			If KeyHit(KEY_F1)
				gridOn = Not gridOn
			End
			
			If KeyDown(KEY_LEFT)
				diddyGame.scrollX -= Floor(gameScrollSpeed * dt.delta)
			End
			If KeyDown(KEY_RIGHT)
				diddyGame.scrollX += Floor(gameScrollSpeed * dt.delta)
			End
			If KeyDown(KEY_UP)
				diddyGame.scrollY -= Floor(gameScrollSpeed * dt.delta)
			End
			If KeyDown(KEY_DOWN)
				diddyGame.scrollY += Floor(gameScrollSpeed * dt.delta)
			End
		End
		Local scrollGap:Int = 20
		If diddyGame.mouseX < scrollGap
			diddyGame.scrollX -= Floor(gameScrollSpeed * dt.delta)
		End
		If diddyGame.mouseY < scrollGap
			diddyGame.scrollY -= Floor(gameScrollSpeed * dt.delta)
		End
		If diddyGame.mouseX > SCREEN_WIDTH - scrollGap
			diddyGame.scrollX += Floor(gameScrollSpeed * dt.delta)
		End
		If diddyGame.mouseY > SCREEN_HEIGHT - scrollGap
			diddyGame.scrollY += Floor(gameScrollSpeed * dt.delta)
		End
		' tower defense maps have a border of TILE_SIZE around them so dont display that extra tile
		If diddyGame.scrollX < TILE_SIZE Then diddyGame.scrollX = TILE_SIZE
		If diddyGame.scrollY < TILE_SIZE Then diddyGame.scrollY = TILE_SIZE
		If diddyGame.scrollX + SCREEN_WIDTH > tilemap.width * TILE_SIZE - TILE_SIZE Then diddyGame.scrollX = tilemap.width * TILE_SIZE - SCREEN_WIDTH - TILE_SIZE
		If diddyGame.scrollY + SCREEN_HEIGHT - gui.limit > tilemap.height * TILE_SIZE - TILE_SIZE Then diddyGame.scrollY = tilemap.height * TILE_SIZE - SCREEN_HEIGHT + gui.limit - TILE_SIZE
		
		If KeyHit(KEY_DELETE)
			If selectedTower <> Null
				gameScreen.tilemap.SetTile(selectedTower.x, selectedTower.y, 0, gameScreen.tilemap.BUILD_LAYER)
				gameScreen.tilemap.SetTile( (selectedTower.x + TILE_SIZE), selectedTower.y, 0, gameScreen.tilemap.BUILD_LAYER)
				
				New Explosion(explosionBigImage, selectedTower.x + selectedTower.image.w2, selectedTower.y + selectedTower.image.h2, 13, 80)
				selectedTower.Kill()
			End
		End
		
		If KeyHit(KEY_1) And gameScreen.cash >= gameScreen.towerTemplateMap.Get("TURRET").cost
			Local sb:SimpleButton = gui.menu.FindButton("turretButton")
			gui.DeselectAllButtons()
			gui.selectedButton = "TURRET"
			gui.mode = gui.TURRET
			sb.selected = True
		End

		If KeyHit(KEY_2) And gameScreen.cash >= gameScreen.towerTemplateMap.Get("ROCKET").cost
			Local sb:SimpleButton = gui.menu.FindButton("rocketButton")
			gui.DeselectAllButtons()
			gui.selectedButton = "ROCKET"
			gui.mode = gui.TURRET
			sb.selected = True
		End

		If KeyHit(KEY_3) And gameScreen.cash >= gameScreen.towerTemplateMap.Get("SLOW").cost
			Local sb:SimpleButton = gui.menu.FindButton("slowButton")
			gui.DeselectAllButtons()
			gui.selectedButton = "SLOW"
			gui.mode = gui.TURRET
			sb.selected = True
		End
						
		If diddyGame.mouseHit
			Tower.UnselectTowers()
			selectedTower = Null
			If diddyGame.mouseY < gui.y Then
				Local mx:Int = diddyGame.mouseX + diddyGame.scrollX
				Local my:Int = diddyGame.mouseY + diddyGame.scrollY
				
				If gameScreen.tilemap.CollisionTile(mx + TILE_SIZE, my, gameScreen.tilemap.BUILD_LAYER) = 0 And
				gameScreen.tilemap.CollisionTile(mx, my, gameScreen.tilemap.BUILD_LAYER) = 0 Then
					If gui.mode = gui.TURRET
						Local nx:Float = Floor(mx / TILE_SIZE)
						Local ny:Float = Floor(my / TILE_SIZE)
						Local t:TurretTower = New TurretTower(gui.selectedButton, nx * TILE_SIZE, ny * TILE_SIZE)
						cash -= t.cost
						
						gameScreen.tilemap.SetTile(mx, my, 1, gameScreen.tilemap.BUILD_LAYER)
						gameScreen.tilemap.SetTile(mx + TILE_SIZE, my, 1, gameScreen.tilemap.BUILD_LAYER)
						selectedTower = Tower.SelectTower(mx, my)
						
						gui.Reset()
					End
				Else
					If gui.mode = gui.NONE
						If gameScreen.tilemap.CollisionTile(mx, my, gameScreen.tilemap.BUILD_LAYER) = 1
							selectedTower = Tower.SelectTower(mx, my)
						End
					End
				End
			End
		End
	
		If KeyHit(KEY_ESCAPE)
			FadeToScreen(Game8Scr, defaultFadeTime, True, True, False)
		End
	End
	
	Method Kill:Void()
		ClearItems()
	End
	
	Method ClearItems:Void()
		flagList.Clear()
		Particle.Clear()
		enemyTemplateMap.Clear()
		towerTemplateMap.Clear()
		waveMap.Clear()
		Unit.list.Clear()
		If Explosion.list
			Explosion.list.Clear()
		End
	End
End

Class Gui
	Const FULL:Int = 2
	Const SCROLL_UP:Int = 1
	Const SCROLL_DOWN:Int = 3
	Const HIDE:Int = 0
	Const NONE:Int = 0
	Const TURRET:Int = 1
	Field selectedButton:String
	Field mouseControlGui:Bool = false
	Field showGUI:Int
	Field x:Float
	Field y:Float
	Field menu:SimpleMenu
	Field mode:Int
	Field limit:Int
	Field override:Int = 0
	Field backgroundImage:GameImage
	Field speedY:Float = 1.2
	Field lip:Int = 20
	Field enableScroll:Bool
	Field menuOffsetY:Int = 7
	Field mouseOverText:String
	Field mouseOverX:Int
	Field mouseOverY:Int
	Field mouseOverAlpha:Float
	Field mouseOverFade:Float = 0.04
	
	Method New()
		showGUI = SCROLL_UP
		mode = NONE
		x = 0
		y = SCREEN_HEIGHT
		override = 0
		menu = New SimpleMenu("ButtonOver", "ButtonClick", 0, 0, 20, True, HORIZONTAL)
		Local b:SimpleButton = menu.AddButton("game8/turretButton.png", "game8/turretButtonMO.png")
		b.SetSelectedImage("game8/turretButtonSelected.png", "game8/turretButtonSelectedMO.png")
		b = menu.AddButton("game8/rocketButton.png", "game8/rocketButtonMO.png")
		b.SetSelectedImage("game8/rocketButtonSelected.png", "game8/rocketButtonSelectedMO.png")
		b = menu.AddButton("game8/slowButton.png", "game8/slowButtonMO.png")
		b.SetSelectedImage("game8/slowButtonSelected.png", "game8/slowButtonSelectedMO.png")

		backgroundImage = diddyGame.images.Find("gui")
		limit = 50
		enableScroll = True
		If Not enableScroll
			y = SCREEN_HEIGHT - 50
		End

		menu.SetY(y + menuOffsetY)
		menu.SetX(10)

	End
	
	Method ShowHideGUI:Void()
		If enableScroll
			If mouseControlGui
				If diddyGame.mouseY < SCREEN_HEIGHT - limit And override = 0 showGUI = SCROLL_DOWN
				If diddyGame.mouseY >= SCREEN_HEIGHT - lip showGUI = SCROLL_UP
			End
			
			If showGUI = SCROLL_UP
				y -= speedY * dt.delta
				If y < SCREEN_HEIGHT - limit
					showGUI = FULL
					y = SCREEN_HEIGHT - limit
				End
			End
	
			If showGUI = SCROLL_DOWN
				y += speedY * dt.delta
				If y > SCREEN_HEIGHT - lip
					showGUI = 0
					override = 0
					y = SCREEN_HEIGHT - lip
				End
			End
		End
	End
	
	Method Reset:Void()
		mode = NONE
		For Local b:SimpleButton = Eachin Self.menu
			b.selected = False
		Next
	End
	
	Method DeselectAllButtons:Void()
		For Local b:SimpleButton = Eachin menu
			b.selected = False
		Next
	End
	
	Method SetMouseOverText:Void(name:String)
		Local tower:UnitTemplate
		Select name.ToUpper()
			Case "TURRETBUTTON"
				tower = gameScreen.towerTemplateMap.Get("TURRET")
				mouseOverText = "$" + tower.cost + " " + tower.desc
			Case "ROCKETBUTTON"
				tower = gameScreen.towerTemplateMap.Get("ROCKET")
				mouseOverText = "$" + tower.cost + " " + tower.desc
			Case "SLOWBUTTON"
				tower = gameScreen.towerTemplateMap.Get("SLOW")
				mouseOverText = "$" + tower.cost + " " + tower.desc
		End
	End
	
	Method Update:Void()
		menu.Update()
		menu.SetY(y + menuOffsetY)
		
		For Local b:SimpleButton = Eachin menu
			If b.mouseOver
				SetMouseOverText(b.name)
				mouseOverAlpha = 1
				mouseOverX = b.x
				mouseOverY = b.y - 30
			End
		Next

		If mouseOverAlpha > 0
			mouseOverAlpha -= mouseOverFade * dt.delta
		Else
			mouseOverAlpha = 0
		End
		
		If menu.Clicked("turretButton") And gameScreen.cash >= gameScreen.towerTemplateMap.Get("TURRET").cost
			Local sb:SimpleButton = menu.FindButton("turretButton")
			If sb.selected = True
				mode = NONE
				sb.selected = False
			Else
				DeselectAllButtons()
				selectedButton = "TURRET"
				mode = TURRET
				sb.selected = True
			End
		End
		
		If menu.Clicked("rocketButton") And gameScreen.cash >= gameScreen.towerTemplateMap.Get("ROCKET").cost
			Local sb:SimpleButton = menu.FindButton("rocketButton")
			If sb.selected = True
				mode = NONE
				sb.selected = False
			Else
				DeselectAllButtons()
				selectedButton = "ROCKET"
				mode = TURRET
				sb.selected = True
			End
		End
		
		If menu.Clicked("slowButton") And gameScreen.cash >= gameScreen.towerTemplateMap.Get("SLOW").cost
			Local sb:SimpleButton = menu.FindButton("slowButton")
			If sb.selected = True
				mode = NONE
				sb.selected = False
			Else
				DeselectAllButtons()
				selectedButton = "SLOW"
				mode = TURRET
				sb.selected = True
			End
		End

		ShowHideGUI()
	End
	
	Method Draw:Void()
		backgroundImage.Draw(x, y)
		menu.Draw()
		
		If mouseOverAlpha > 0
			SetAlpha mouseOverAlpha
			gameScreen.font12.DrawText(mouseOverText, mouseOverX, mouseOverY, eDrawAlign.LEFT)
			SetAlpha 1
		End
		
		Local cashX:Int = SCREEN_WIDTH - 70
		Local cashY:Int = y + 10
		Local gapX:Int = 5
		gameScreen.font12.DrawText("CASH : ", cashX, cashY, eDrawAlign.RIGHT)
		gameScreen.font12.DrawText(gameScreen.cash, cashX + gapX, cashY, eDrawAlign.LEFT)
		Local levelX:Int = cashX
		Local levelY:Int = y + 30
		gameScreen.font12.DrawText("LEVEL: ", levelX, levelY, eDrawAlign.RIGHT)
		gameScreen.font12.DrawText(player.level, levelX + gapX, levelY, eDrawAlign.LEFT)

		Local healthX:Int = 200
		Local healthY:Int = y + 17
		Local hr:Int, hg:Int, hb:Int
		Local br:Int, bg:Int, bb:Int
		hr = 0; hg = 255; hb = 0
		br = 0; bg = 0; bb = 0

		If gameScreen.health < gameScreen.maxHealth * 0.70 Then
			hr = 255
			hg = 255
			hb = 0
		End
		If gameScreen.health < gameScreen.maxHealth * 0.40 Then
			hr = 255
			hg = 0
			hb = 0
		End
		
		DrawHealthBar(healthX, healthY, 300, 20, Float(gameScreen.health / gameScreen.maxHealth), hr, hg, hb, br, bg, bb)

	End
	
	Method DrawHealthBar:Void(x:Int, y:Int, width:Int, height:Int, percent:Float, r1:Int, g1:Int, b1:Int, r2:Int, g2:Int, b2:Int)
		Local fill:Float = (width - 2) * percent
		Local w:Int = width - 1
		Local h:Int = height - 1
		SetColor(r1, g1, b1)
		DrawRect(x + 1, y + 1, fill, h - 1)
		SetColor(r2, g2, b2)
		DrawRectOutline(x, y, w, h)
		SetColor 255, 255, 255
	End
	
End

Class MyTiledTileMapReader Extends TiledTileMapReader
	Method CreateMap:TileMap()
		graphicsPath = "game8/"
		Return New MyTileMap
	End
End

Class MyTileMap Extends TileMap
	Const GRAVITY:Float = 0.5
	Const COLLISION_LAYER:String = "CollisionLayer"
	Const BUILD_LAYER:String = "BuildableLayer"
		
	Method ConfigureLayer:Void(tileLayer:TileMapLayer)
		SetAlpha(tileLayer.opacity)
	End
	
	Method DrawTile:Void(tileLayer:TileMapTileLayer, mapTile:TileMapTile, x:Int, y:Int)
		mapTile.image.DrawTile(x, y, mapTile.id, 0, 1, 1)
	End
End


Class GameOverScreen Extends Screen
	Method New()
		name = "GameOverScreen"
	End
	
	Method Start:Void()
		
	End
	
	Method Render:Void()
		Cls
		gameScreen.font20.DrawText("GAME OVER!", SCREEN_WIDTH2, 240, eDrawAlign.CENTER)
	End
	
	Method Update:Void()
		If KeyHit(KEY_SPACE) Or KeyHit(KEY_ESCAPE) Or MouseHit() Then
			FadeToScreen(Game8Scr)
		End
	End
End

Class NextLevelScreen Extends Screen
	Method New()
		name = "NextlevelScreen"
	End
	
	Method Start:Void()
	End
	
	Method Render:Void()
		Cls
		gameScreen.font20.DrawText("WELL DONE!", SCREEN_WIDTH2, 240, eDrawAlign.CENTER)
		gameScreen.font20.DrawText("LEVEL " + player.level + " COMPLETE", SCREEN_WIDTH2, 270, eDrawAlign.CENTER)
	End
	
	Method Update:Void()
		If KeyHit(KEY_SPACE) Or KeyHit(KEY_ESCAPE) Or MouseHit() Then
			FadeToScreen(gameScreen)
		End
	End
	
	Method Kill:Void()
		player.level += 1
		If player.level > gameScreen.MAX_LEVELS
			player.level = 1
		End		
	End
	
End

Class UnitComparator Extends IComparator
	' Compare should return 0 if the items are equal, a negative value if o1 < o2, and a positive value if o1 > o2
	Method Compare:Int(o1:Object, o2:Object)
		Local u1:Unit = Unit(o1)
		Local u2:Unit = Unit(o2)
		
		If u2 = u1 Return 0
		
		If u1.y = u2.y
			Return Sgn(u1.x - u2.x)
		End
				
		Return Sgn(u1.y - u2.y)
	End
	
	Method Equals:Bool(o1:Object, o2:Object)
		Return o1 = o2
	End
End

Class Star
	Field x:Float, y:Float, z:Float
	
	Method New()
		x = Rnd(-100, 100)
		y = Rnd(-100, 100)
		z = Rnd(-100, 100)
	End

	Method Update:Void()
		z -= 1 * dt.delta
		x -= ( (diddyGame.mouseX - SCREEN_WIDTH2) / 200) * dt.delta
		y -= ( (diddyGame.mouseY - SCREEN_HEIGHT2) / 200) * dt.delta
		If z <= - 100 z += 200
		If x <= - 100 x += 200
		If y <= - 100 y += 200
		If x >= 100 x -= 200
		If y >= 100 y -= 200
	End
	
	Method Draw:Void()
		Local i:Int = z + 121
		Local px:Int = x * 450 / (z + 151)
		Local py:Int = y * 350 / (z + 151)
		SetColor 255 - i, 255 - i, 255 - i
		DrawRect(SCREEN_WIDTH2 + px, SCREEN_HEIGHT2 + py, 1, 1)
		SetColor 255, 255, 255
	End
End

#rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#end