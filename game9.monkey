#rem
header:
[quote]

[b]File Name :[/b] Game9Screen
[b]Author    :[/b] Shane "Samah" Woolcock
[b]About     :[/b] Music by SouljahdeShiva: http://opengameart.org/content/upbeat-techno-spacenomad-2
Touhou Clone
[/quote]
#End

Strict

Public
Import main

#rem
summary:Title Screen Class.
Used to manage and deal with all Title Page stuff.
#End
Class Game9Screen Extends Screen
	Field loaded:Bool = False
	
	Method New()
		name = "DanMonkey"
		Local gameid:Int = 9
		GameList[gameid - 1] = New miniGame
		GameList[gameid - 1].id = gameid - 1
		GameList[gameid - 1].name = "DanMonkey"
		GameList[gameid - 1].iconname = "game" + gameid + "_icon"
		GameList[gameid - 1].thumbnail = "game" + gameid + "_thumb"
		GameList[gameid - 1].author = "Shane Woolcock"
		GameList[gameid - 1].authorurl = "????"
		GameList[gameid - 1].info = "A bullet hell diddyGame... in Monkey ;)"
	End
	
	#rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		If Not loaded Then LoadMedia()
		
		'diddyGame.images.LoadAnim("Ship1.png", 64, 64, 7, tmpImage)
		smhGameScreen = New Smh_GameScreen
	End
	
	#rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		TitleFont.DrawText(Self.name, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 2)
	End

	#rem
	summary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	And all use input.
	#End
	Method Update:Void()
		If KeyHit(KEY_ESCAPE) Then
			FadeToScreen(TitleScr)
		End
		If KeyHit(KEY_SPACE) Or MouseHit() Then
			FadeToScreen(smhGameScreen)
		End
	End
	
	Method LoadMedia:Void()
		loaded = True
		diddyGame.images.LoadAtlas("game9/game9_bullets1.txt", ImageBank.LIBGDX_ATLAS, True)
		diddyGame.images.LoadAtlas("game9/game9_bullets2.txt", ImageBank.LIBGDX_ATLAS, True)
		diddyGame.images.LoadAtlas("game9/game9_ships.txt", ImageBank.LIBGDX_ATLAS, True)
		Local tmpImage:GameImage = Null
		diddyGame.images.Load("game9/game9_ship2.png",,False).image.SetHandle(9, 12)
		diddyGame.images.Load("game9/game9_explode1.png")
		diddyGame.images.LoadAnim("game9/game9_ship6.png", 39, 39, 3, Null)
		diddyGame.images.LoadAnim("game9/game9_cube.png", 24, 28, 21, Null)
		diddyGame.images.Load("game9/game9_starfield.jpg",,False)
		diddyGame.images.Load("game9/game9_bg.png",,False)
		
		diddyGame.sounds.Load("game9_death")
		diddyGame.sounds.Load("game9_explosion1")
		diddyGame.sounds.Load("game9_explosion2")
		diddyGame.sounds.Load("game9_explosion3")
		diddyGame.sounds.Load("game9_laser1")
		diddyGame.sounds.Load("game9_laser2")
		diddyGame.sounds.Load("game9_laser3")
		diddyGame.sounds.Load("game9_laser4")
		diddyGame.sounds.Load("game9_pickup1")
	End
End

Class Smh_GameOverScreen Extends Screen
	Method Start:Void()
		
	End
	
	Method Render:Void()
		Cls
		TitleFont.DrawText("Game Over!", SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 2)
	End
	
	Method Update:Void()
		If KeyHit(KEY_ESCAPE) Or KeyHit(KEY_SPACE) Or MouseHit() Then
			FadeToScreen(Game9Scr)
		End
	End
End

Private

Global smhGameScreen:Smh_GameScreen

Global psys:ParticleSystem
Global explosions:ParticleGroup
Global sparks:ParticleGroup
Global explode1:Emitter
Global grazeEmitter:Emitter

Global playarea:Smh_PlayArea
Global enemyBullets:Smh_BulletPool
Global playerBullets:Smh_BulletPool
Global powerups:Smh_PowerupPool
Global enemies:Smh_EnemyPool
Global player:Smh_Player
Global boss:Smh_Boss

Global currentStage:Smh_Stage

Class Smh_GameScreen Extends Screen
	Const GRAZE_INTERVAL:Int = 200
	Field nextGrazeBonus:Int = -1
	
	Method Start:Void()
		CreateParticleSystem()
		
		playarea = New Smh_PlayArea("graphics/game9/game9_background1.tmx")
		playarea.x = 0
		playarea.y = 0
		playarea.height = SCREEN_HEIGHT' - playarea.y*2
		playarea.width = 380
		playarea.boundsLeft = 0
		playarea.boundsTop = 0
		playarea.boundsRight = playarea.width
		playarea.boundsBottom = playarea.height
		
		enemyBullets = New Smh_BulletPool
		enemyBullets.parent = playarea
		
		playerBullets = New Smh_BulletPool
		playerBullets.parent = playarea
		
		powerups = New Smh_PowerupPool
		powerups.parent = playarea
		
		player = New Smh_Player
		player.parent = playarea
		player.x = playarea.x + playarea.width * 0.5
		player.y = playarea.y + playarea.height * 0.8
		
		enemies = New Smh_EnemyPool
		enemies.parent = playarea
		
		currentStage = New Smh_Stage1
		
		diddyGame.MusicPlay("game9_bgm.mp3")
	End
	
	Method Kill:Void()
		StopMusic()
		
		playarea = Null
		enemyBullets = Null
		playerBullets = Null
		player = Null
		enemies = Null
		boss = Null
		currentStage = Null
	End
	
	Method Update:Void()
		If KeyHit(KEY_ESCAPE) Then
			FadeToScreen(Game9Scr)
		End

		' update everything
		currentStage.Update(dt.frametime)
		
		playarea.DoUpdate(dt.frametime)
		enemies.DoUpdate(dt.frametime)
		If boss Then boss.DoUpdate(dt.frametime)
		enemyBullets.DoUpdate(dt.frametime)
		playerBullets.DoUpdate(dt.frametime)
		powerups.DoUpdate(dt.frametime)
		player.DoUpdate(dt.frametime)
		
		psys.Update(dt.frametime)
		
		ResolveCollisions()
	End
	
	Method Render:Void()
		' clear the screen
		Cls
		
		' draw the main background image
		DrawImage(diddyGame.images.Find("game9_bg").image, 0, 0)
		
		' draw the gui
		DrawGUI()
		
		' draw the play area
		playarea.DoRender()
		
		' draw the timer
		If boss Then
			SetAlpha(0.8)
			SetColor(255,255,255)
			DrawRect(playarea.x+15, playarea.y+15, (playarea.width-60) * Float(boss.currentHP)/Float(boss.maxHP), 10)
			SetAlpha(1)
			TitleFont.DrawText(""+Int(Max(0.0,Ceil(boss.timeRemainingMillis/1000.0))), playarea.x + playarea.width - 10, 10, eDrawAlign.RIGHT)
		End
		
		SetColor 255,255,255
		DrawLine(playarea.x+playarea.width, playarea.y, playarea.x+playarea.width, playarea.y+playarea.height)
		
		If player.godMode Then DrawText("God Mode", 0, 0)
	End
	
	Method DrawGUI:Void()
		' labels
		TitleFont.DrawText("Player", playarea.x+playarea.width+20, 100)
		TitleFont.DrawText("Bomb", playarea.x+playarea.width+20, 150)
		TitleFont.DrawText("Score", playarea.x+playarea.width+20, 200)
		TitleFont.DrawText("Graze", playarea.x+playarea.width+20, 250)
		' draw player/bomb counters
		Local markerX:Float = playarea.x+playarea.width+100
		Local cubes:GameImage = diddyGame.images.Find("game9_cube")
		For Local i:Int = 0 Until Smh_Player.MAX_LIVES
			If (i+1) * Smh_Player.POWER_PER_LIFE <= player.lifePower
				SetAlpha(1)
				cubes.Draw(markerX+(cubes.image.Width()+2)*i, 110,,,,20)
			Else
				SetAlpha(0.5)
				cubes.Draw(markerX+(cubes.image.Width()+2)*i, 110,,,,18)
				If i = Int(player.lifePower / Smh_Player.POWER_PER_LIFE) Then
					SetAlpha(1)
					Local ratio:Float = (player.lifePower Mod Smh_Player.POWER_PER_LIFE) / Smh_Player.POWER_PER_LIFE
					cubes.DrawSubImage(markerX+(cubes.image.Width()+2)*i, 110, 0, 0, cubes.image.Width()*ratio, cubes.image.Height(),,,,20)
				End
			End
		Next
		
		For Local i:Int = 0 Until Smh_Player.MAX_BOMBS
			If (i+1) * Smh_Player.POWER_PER_BOMB <= player.bombPower
				SetAlpha(1)
				cubes.Draw(markerX+(cubes.image.Width()+2)*i, 160,,,,17)
			Else
				SetAlpha(0.5)
				cubes.Draw(markerX+(cubes.image.Width()+2)*i, 160,,,,15)
				If i = Int(player.bombPower / Smh_Player.POWER_PER_BOMB) Then
					SetAlpha(1)
					Local ratio:Float = (player.bombPower Mod Smh_Player.POWER_PER_BOMB) / Smh_Player.POWER_PER_BOMB
					cubes.DrawSubImage(markerX+(cubes.image.Width()+2)*i, 160, 0, 0, cubes.image.Width()*ratio, cubes.image.Height(),,,,17)
				End
			End
		Next
	End
	
	Method ResolveCollisions:Void()
		Local bullet:Smh_Bullet = Null
		Local enemy:Smh_Enemy = Null
		
		' resolve collisions of boss with player
		If boss Then
			Local dx:Float = player.x-boss.x
			Local dy:Float = player.y-boss.y
			If dx*dx + dy*dy <= boss.radius + player.radius Then
				player.currentHP = 0
			End
		End
		
		' resolve collisions of enemies with player
		enemy = enemies.FindFirstCollision(player)
		If enemy Then
			player.currentHP = 0
		End
		
		' resolve collisions of enemy bullets with player
		bullet = enemyBullets.FindFirstCollision(player)
		If bullet Then
			player.currentHP = 0
		End
		
		' resolve collisions of player bullets with boss
		If boss Then
			bullet = playerBullets.FindFirstCollision(boss)
			If bullet Then
				' damage
				bullet.alive = False
				bullet.active = False
				boss.currentHP -= 5
				If boss.currentHP < 0 Then boss.currentHP = 0
			End
		End
		
		' resolve collisions of player bullets with enemies
		For Local i:Int = 0 Until enemies.aliveCount
			bullet = playerBullets.FindFirstCollision(enemies.children[i])
			If bullet Then
				' damage
				bullet.alive = False
				bullet.active = False
				enemies.children[i].currentHP -= 5
				If enemies.children[i].currentHP < 0 Then
					enemies.children[i].currentHP = 0
				End
			End
		Next
		
		' find graze count
		If nextGrazeBonus < dt.currentticks Then
			Local grazeCount% = enemyBullets.GetGrazeCount(player, 15)
			player.AddBombPower(grazeCount)
			nextGrazeBonus = dt.currentticks + GRAZE_INTERVAL
			If grazeCount > 0 Then grazeEmitter.EmitAt(5*grazeCount, player.x, player.y)
		End
	End
	
	Method CreateParticleSystem:Void()
		Local parser:XMLParser = New XMLParser
		Local doc:XMLDocument = parser.ParseFile("graphics/game9/psystem.xml")
		psys = New ParticleSystem(doc)
		explosions = psys.GetGroup("explosions")
		sparks = psys.GetGroup("sparks")
		explode1 = psys.GetEmitter("explode1")
		explode1.ParticleImage = diddyGame.images.Find("game9_explode1").image
		grazeEmitter = psys.GetEmitter("graze")
		grazeEmitter.ParticleImage = diddyGame.images.Find("game9_bullet1").image
	End
End


Class Smh_Entity
	' used for HSL conversion
	Global rgbArray:Int[] = New Int[3]
	
	' misc
	Field parent:Smh_Entity
	Field alive:Bool = False ' used for pooling
	Field active:Bool = True
	Field activeDelayMillis:Int = 0
	Field logicHandler:Smh_EntityLogicHandler = Null
	Field activeTimeMillis:Int = 0 ' the game time that this entity became active
	Field entityTypeId:Int = 0 ' arbitrary value
	
	' custom fields for the logic handler
	Field logicVar1:Int
	Field logicVar2:Int
	Field logicVar3:Int
	
	' position/velocities (velocity in units per second)
	Field x#, y# ' position
	Field width#, height# ' size
	Field dx#, dy# ' cartesian velocity if usePolar = False
	Field accelX#, accelY# ' cartesian acceleration if usePolar = False
	Field polarAngle#, polarVelocity# ' polar velocity if usePolar = True
	Field polarAccel# ' polar acceleration if usePolar = True
	Field terminalVelocity# ' can never move faster than this (if not interping)
	Field usePolar?
	Field recalcPolar?
	Field boundsRestrict? = False
	Field boundsPurge? = False
	Field useParentBounds? = True
	Field boundsLeft#, boundsRight#, boundsTop#, boundsBottom#
	Field boundsInset# = 0
	Field radius# = 0
	
	' interpolation
	Field sourceX#, sourceY# ' starting point
	Field targetX#, targetY# ' ending point
	Field interpTotalMillis% ' total interp time millis
	Field interpRemainingMillis% ' interp time remaining millis
	Field interpSmooth%
	Field interping?
	
	' visual
	Field image:GameImage ' for a simple single image
	Field anim:Smh_AnimStrip
	Field animFrame:Int
	Field animDelayMillis:Int
	Field animDirection:Int
	Field animForcedDirection:Int
	Field rotation# = 0
	Field rotationSpeed# = 0
	Field rotateWithHeading? = True
	Field scaleX# = 1
	Field scaleY# = 1
	Field hue# = 0
	Field saturation# = 1
	Field luminance# = 0.5
	Field red% = 255
	Field green% = 255
	Field blue% = 255
	Field useHSL? = False
	Field recalcHSL?
	Field alpha# = 1
	Field visible? = True
	Field visibleWhileInactive? = False
	Field fadeInTimeMillis% = 0
	Field blendMode# = AlphaBlend
	Field scissor? = False
	
	Method CalcBoundsLeft:Float()
		Local current:Smh_Entity = Self
		While current.parent And current.useParentBounds
			current = current.parent
		End
		Return current.boundsLeft + boundsInset
	End
	
	Method CalcBoundsRight:Float()
		Local current:Smh_Entity = Self
		While current.parent And current.useParentBounds
			current = current.parent
		End
		Return current.boundsRight - boundsInset
	End
	
	Method CalcBoundsTop:Float()
		Local current:Smh_Entity = Self
		While current.parent And current.useParentBounds
			current = current.parent
		End
		Return current.boundsTop + boundsInset
	End
	
	Method CalcBoundsBottom:Float()
		Local current:Smh_Entity = Self
		While current.parent And current.useParentBounds
			current = current.parent
		End
		Return current.boundsBottom - boundsInset
	End
	
	Method SetVelocityCartesian:Void(dx#, dy#)
		Self.dx = dx
		Self.dy = dy
		Self.usePolar = False
		Self.recalcPolar = False
		Self.interping = False
	End
	
	Method SetVelocityPolar:Void(polarAngle#, polarVelocity#)
		Self.polarAngle = polarAngle
		Self.polarVelocity = polarVelocity
		Self.usePolar = True
		Self.interping = False
		RecalcPolar()
	End
	
	Method SetInterpOverTime:Void(sourceX#, sourceY#, targetX#, targetY#, millis%, smooth% = 0)
		Self.sourceX = sourceX
		Self.sourceY = sourceY
		Self.targetX = targetX
		Self.targetY = targetY
		Self.interpTotalMillis = millis
		Self.interpRemainingMillis = millis
		Self.interpSmooth = smooth
		Self.interping = True
	End
	
	Method SetInterpWithVelocity:Void(sourceX#, sourceY#, targetX#, targetY#, velocity#, smooth% = 0)
		Local distance# = Sqrt((targetX-sourceX)*(targetX-sourceX)+(targetY-sourceY)*(targetY-sourceY))
		Local time# = distance/velocity
		SetInterpOverTime(sourceX, sourceY, targetX, targetY, Int(time*1000), smooth)
	End
	
	' Warning: don't call this with parameters that would give an impossible movement, or it'll infinite loop!
	Method SetInterpRandomOverTime:Void(sourceX#, sourceY#, minDistance#, maxDistance#, millis%, smooth% = 0)
		Local rndX# = 0
		Local rndY# = 0
		Local calc# = 0
		Repeat
			rndX = Rnd(boundsLeft+boundsInset, boundsRight-boundsInset)
			rndY = Rnd(boundsTop+boundsInset, boundsBottom-boundsInset)
			calc = (sourceX-rndX)*(sourceX-rndX)+(sourceY-rndY)*(sourceY-rndY)
		Until calc >= minDistance*minDistance And calc <= maxDistance*maxDistance
		SetInterpOverTime(sourceX, sourceY, rndX, rndY, millis, smooth)
	End
	
	Method RecalcPolar:Void()
		Self.recalcPolar = False
		Self.dx = Cos(polarAngle) * polarVelocity
		Self.dy = Sin(polarAngle) * polarVelocity
	End
	
	Method RecalcHSL:Void()
		Self.recalcHSL = False
		HSLtoRGB(hue, saturation, luminance, rgbArray)
		red = rgbArray[0]; green = rgbArray[1]; blue = rgbArray[2]
	End
	
	Method PreUpdate:Float(millis%)
		If Not active And activeDelayMillis > 0 Then
			activeDelayMillis -= millis
			If activeDelayMillis <= 0 Then
				millis = -activeDelayMillis
				activeDelayMillis = 0
				activeTimeMillis = dt.currentticks
				active = True
			End
		End
		If Not active Then Return 0
		Return millis
	End
	
	Method PostUpdate:Void(millis%)
		' update position based on interp or velocity
		If interping Then
			interpRemainingMillis -= millis
			If interpRemainingMillis <= 0 Then
				interping = False
				x = targetX
				y = targetY
				interpRemainingMillis = 0
			Else
				Local alpha# = 1 - Float(interpRemainingMillis)/Float(interpTotalMillis)
				For Local i% = 0 Until interpSmooth
					alpha *= alpha * (3 - 2 * alpha)
				Next
				x = sourceX + (targetX-sourceX)*alpha
				y = sourceY + (targetY-sourceY)*alpha
				If usePolar Then polarAngle = ATan2(targetY-y, targetX-x)
			End
		Else
			' update polar accel
			If usePolar Then
				If polarAccel <> 0 Then
					polarVelocity += polarAccel * millis / 1000.0
					recalcPolar = True
				End
				If recalcPolar Then RecalcPolar()
			' update cartesian accel
			Else
				dx += accelX * millis / 1000.0
				dy += accelY * millis / 1000.0
			End
			
			' do terminal velocity
			If terminalVelocity > 0 And dx*dx + dy*dy > terminalVelocity*terminalVelocity Then
				Local length:Float = Sqrt(dx*dx + dy*dy)
				dx *= terminalVelocity / length
				dy *= terminalVelocity / length
				polarVelocity = terminalVelocity
			End
			
			' update position
			x += dx * millis / 1000.0
			y += dy * millis / 1000.0
		End
		
		' update rotation
		If rotationSpeed <> 0 Then
			rotation += rotationSpeed * millis / 1000.0
			While rotation < 0 rotation += 360 End
			While rotation >= 360 rotation -= 360 End
		End
		
		' get bounds
		Local current:Smh_Entity = Self
		While current.parent And current.useParentBounds
			current = current.parent
		End
		Local bl:Float = current.boundsLeft + boundsInset
		Local br:Float = current.boundsRight - boundsInset
		Local bt:Float = current.boundsTop + boundsInset
		Local bb:Float = current.boundsBottom - boundsInset
		
		' restrict
		If boundsRestrict Then
			If x < bl Then x = bl
			If x > br Then x = br
			If y < bt Then y = bt
			If y > bb Then y = bb
		End

		' mark for purging
		If boundsPurge Then
			If x < bl Or x > br Or y < bt Or y > bb Then alive = False
		End
	End
	
	' This should be called in OnUpdate() or by a parent entity
	Method DoUpdate:Void(millis%)
		millis = PreUpdate(millis)
		If millis > 0 Then
			Update(millis)
			PostUpdate(millis)
		End
	End
	
	' Entities should implement this method
	Method Update:Void(millis%)
		If logicHandler Then logicHandler.UpdateLogic(Self, millis)
	End
	
	Method PreRender:Bool()
		If Not active And Not visibleWhileInactive Then Return False
		If fadeInTimeMillis > 0 Then alpha = Max(0.0,Min(1.0,1.0-(Float(activeDelayMillis) / Float(fadeInTimeMillis))))
		Local rot:Float = rotation
		If rotateWithHeading And usePolar Then rot -= polarAngle
		PushMatrix
		Translate x, y
		Scale scaleX, scaleY
		Rotate rot
		If scissor Then SetScissor(x+boundsLeft, y+boundsTop, boundsRight-boundsLeft, boundsBottom-boundsTop)
		Return True
	End
	
	Method PostRender:Void()
		' we have to use device width/height rather than screen width/height as the scissor is not affected by scaling
		If scissor Then SetScissor(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)
		PopMatrix
	End
	
	' This should be called in OnRender() or by a parent entity
	Method DoRender:Void()
		If PreRender() Then
			Render()
			PostRender()
		End
	End
	
	' Entities should override this method if they want anything special
	Method Render:Void()
		If image Or anim Then
			Local oldalpha:Float = GetAlpha()
			Local oldblend:Int = GetBlend()
			SetBlend(blendMode)
			If useHSL And recalcHSL Then RecalcHSL()
			If blendMode = AlphaBlend Then
				SetAlpha(alpha)
				SetColor(red, green, blue)
			Else
				SetAlpha(1)
				SetColor(red*alpha, green*alpha, blue*alpha)
			End
			If image Then
				DrawImage(image.image, 0, 0)
			Elseif anim Then
				anim.Render(Self, 0, 0)
			End
			SetBlend(oldblend)
			If blendMode = AlphaBlend Then
				SetAlpha(oldalpha)
			Else
				SetColor(red, green, blue)
			End
		End
	End
	
	Method AbsoluteX:Float() Property
		If parent = Null Then Return x
		Return x + parent.AbsoluteX
	End
	
	Method AbsoluteY:Float() Property
		If parent = Null Then Return y
		Return y + parent.AbsoluteY
	End
	
	' summary: Copies specific fields from another entity to this one.
	' This is so we can reuse entities and populate them with templates.
	Method CopyFrom:Smh_Entity(source:Smh_Entity)
		parent = source.parent
		'active = source.active
		'activeDelayMillis = source.activeDelayMillis
		'alive = source.alive
		entityTypeId = source.entityTypeId
		logicHandler = source.logicHandler
		logicVar1 = source.logicVar1
		logicVar2 = source.logicVar2
		logicVar3 = source.logicVar3
		x = source.x
		y = source.y
		width = source.width
		height = source.height
		dx = source.dx
		dy = source.dy
		accelX = source.accelX
		accelY = source.accelY
		polarAngle = source.polarAngle
		polarVelocity = source.polarVelocity
		polarAccel = source.polarAccel
		terminalVelocity = source.terminalVelocity
		usePolar = source.usePolar
		recalcPolar = source.recalcPolar
		boundsLeft = source.boundsLeft
		boundsRight = source.boundsRight
		boundsTop = source.boundsTop
		boundsBottom = source.boundsBottom
		boundsPurge = source.boundsPurge
		boundsRestrict = source.boundsRestrict
		boundsInset = source.boundsInset
		radius = source.radius
		sourceX = source.sourceX
		sourceY = source.sourceY
		targetX = source.targetX
		targetY = source.targetY
		interpTotalMillis = source.interpTotalMillis
		interpRemainingMillis = source.interpRemainingMillis
		interpSmooth = source.interpSmooth
		interping = source.interping
		image = source.image
		rotation = source.rotation
		rotationSpeed = source.rotationSpeed
		rotateWithHeading = source.rotateWithHeading
		scaleX = source.scaleX
		scaleY = source.scaleY
		hue = source.hue
		saturation = source.saturation
		luminance = source.luminance
		red = source.red
		green = source.green
		blue = source.blue
		useHSL = source.useHSL
		recalcHSL = source.recalcHSL
		alpha = source.alpha
		blendMode = source.blendMode
		visible = source.visible
		visibleWhileInactive = source.visibleWhileInactive
		fadeInTimeMillis = source.fadeInTimeMillis
		scissor = source.scissor
		anim = source.anim
		animFrame = source.animFrame
		animDelayMillis = source.animDelayMillis
		animDirection = source.animDirection
		animForcedDirection = source.animForcedDirection
		Return Self
	End
	
	Method SuckToPlayer:Void(template:Smh_Entity, millis:Int)
		Local oldX:Int = x
		Local oldY:Int = y
		If template Then CopyFrom(template)
		SetInterpOverTime(oldX, oldY, player.x, player.y, millis, 1)
	End
End

' Implement this interface if you want to provide logic shared amongst entities without having to extend them.
' This is useful for applying different functionality to pooled objects (like bullets).
Interface Smh_EntityLogicHandler
	Method UpdateLogic:Void(entity:Smh_Entity, millis%)
End

Class Smh_AnimStrip
	Field image:GameImage
	Field frameCount:Int
	Field frameDelays:Int[]
	Field frameOffsets:Int[]
	Field frameDirections:Int[]
	
	Method New(name:String, frameCount:Int)
		Self.image = diddyGame.images.Find(name)
		Self.frameCount = frameCount
		frameDelays = New Int[frameCount]
		frameOffsets = New Int[frameCount]
		frameDirections = New Int[frameCount]
		For Local i:Int = 0 Until frameCount
			frameOffsets[i] = 1
			frameDirections[i] = 0
		Next
	End
	
	Method Update:Void(entity:Smh_Entity, millis%)
		' die if paused and not forced
		If entity.animDirection = 0 And entity.animForcedDirection = 0 Then Return
		' loop while we have millis
		While millis > 0
			' update the delay
			entity.animDelay -= millis
			If entity.animDelay >= 0 Then
				millis = 0
			Else
				millis = -entity.animDelay
			End
			
			' if we should move to the next frame
			If entity.animDelay <= 0 Then
				' if we're forcing a direction, use that
				If entity.animForcedDirection <> 0 Then
					entity.animFrame += entity.animForcedDirection
				Else
					entity.animFrame += frameOffsets[entity.animFrame]*entity.animDirection
				End
				' clip it
				If entity.animFrame < 0 Then entity.animFrame = 0
				If entity.animFrame >= frameCount Then entity.animFrame = frameCount-1
				' update the direction if not forced
				If entity.animForcedDirection = 0 And frameDirections[entity.animFrame] <> 0 Then
					entity.animDirection = frameDirections[entity.animFrame]
				End
				entity.animDelay = frameDelays[entity.animFrame]
			End
		End
	End
	
	Method Render:Void(entity:Smh_Entity, x#, y#)
		DrawImage(image.image, x, y, entity.animFrame)
	End
End

Class Smh_EntityGroup Extends Smh_Entity
	Field children:ArrayList<Smh_Entity> = New ArrayList<Smh_Entity>(100)
	
	Method Update:Void(millis%)
		For Local i:Int = 0 Until children.Size
			Local child:Smh_Entity = children.Get(i)
			If child.active Then child.DoUpdate(millis)
		Next
	End
	
	Method Render:Void()
		For Local i:Int = 0 Until children.Size
			Local child:Smh_Entity = children.Get(i)
			If child.active Then child.DoRender()
		Next
	End
End

Class Smh_Pool<T> Extends Smh_Entity
	Field children:T[]
	Field aliveCount:Int = 0
	Field autoPurgeMillis:Int = 500
	Field nextPurgeMillis:Int = -1
	
	Method New(capacity:Int)
		active = True
		PopulatePool(capacity)
	End
	
	Method PopulatePool:Void(capacity:Int)
		If children.Length > 0 Then Return ' throw exception?
		If capacity <= 0 Then Return ' throw exception?
		children = New T[capacity]
		For Local i:Int = 0 Until capacity
			children[i] = New T
		Next
	End
	
	Method GetEntity:T(template:Smh_Entity=Null)
		If aliveCount = children.Length Then Purge()
		If aliveCount = children.Length Then Return Null
		aliveCount += 1
		children[aliveCount-1].alive = True
		If template Then children[aliveCount-1].CopyFrom(template)
		Return children[aliveCount-1]
	End
	
	Method ReleaseEntity:Void(entity:T)
		' TODO: improve performance with a reverse pointer lookup?
		For Local i:Int = 0 Until aliveCount
			If children[i] = entity Then
				entity.alive = False
				Exit
			End
		Next
		Purge()
	End
	
	Method Purge:Void()
		Local current:Int = 0
		While current < aliveCount
			' if the low index is alive
			If children[current].alive Then
				' move to the next index
				current += 1
			Else
				' else, reduce the alive count until we find one to swap with
				While current < aliveCount And Not children[aliveCount-1].alive
					aliveCount -= 1
				End
				' if we have an alive to swap, do it
				If current < aliveCount Then
					Local oldChild:T = children[current]
					children[current] = children[aliveCount-1]
					children[aliveCount-1] = oldChild
					aliveCount -= 1
				End
			End
		End
	End
	
	Method Clear:Void()
		For Local i% = 0 Until aliveCount
			children[i].alive = False
		Next
		Purge()
	End
	
	Method FindFirstCollision:T(other:Smh_Entity)
		For Local i% = 0 Until aliveCount
			If children[i].alive Then
				Local dx# = other.x-children[i].x
				Local dy# = other.y-children[i].y
				Local dist# = other.radius+children[i].radius
				If dx*dx + dy*dy < dist*dist Then Return children[i]
			End
		Next
		Return Null
	End
	
	Method GetGrazeCount:Int(other:Smh_Entity, grazeProximity:Float)
		Local count:Int = 0
		For Local i% = 0 Until aliveCount
			If children[i].alive Then
				Local dx# = other.x-children[i].x
				Local dy# = other.y-children[i].y
				Local dist# = other.radius+children[i].radius+grazeProximity
				If dx*dx + dy*dy < dist*dist Then count += 1
			End
		Next
		Return count
	End
	
	Method Update:Void(millis%)
		For Local i:Int = 0 Until aliveCount
			If children[i].alive Then children[i].DoUpdate(millis)
		Next
		If autoPurgeMillis > 0 Then
			If nextPurgeMillis < dt.frametime Then
				Purge()
				nextPurgeMillis = dt.frametime + autoPurgeMillis
			End
		End
	End
	
	Method Render:Void()
		For Local i:Int = 0 Until aliveCount
			If children[i].alive Then children[i].DoRender()
		Next
	End
End

Class Smh_PlayArea Extends Smh_Entity
	Field scrollX:Float
	Field scrollY:Float
	Field scrollSpeed:Float = 50
	Field tilemap:TileMap
	
	Method New(mapfile:String)
		Local reader:MyTiledTileMapReader = New MyTiledTileMapReader
		Local tm:TileMap = reader.LoadMap(mapfile)
		tilemap = MyTileMap(tm)
		active = True
		scissor = True
	End
	
	Method Render:Void()
		SetAlpha(1)
		'SetColor(128, 128, 128)
		
		' render starfield
		Local starfield:GameImage = diddyGame.images.Find("game9_starfield")
		Local y:Float = scrollY/2
		While y > 0
			y -= starfield.h
		End
		While y < height
			DrawImage(starfield.image, 0, y)
			y += starfield.h
		End
		
		tilemap.RenderMap(scrollX, (tilemap.height*tilemap.tileHeight)-scrollY, SCREEN_WIDTH, SCREEN_HEIGHT)'boundsRight, boundsBottom)
		
		' temporary
		SetColor(0,0,0)
		SetAlpha(0.5)
		DrawRect(x, Self.y, width, height)
		SetAlpha(1)
		
		SetColor(255, 255, 255)
		enemies.DoRender()
		If boss Then boss.DoRender()
		playerBullets.DoRender()
		powerups.DoRender()
		player.DoRender()
		psys.Render()
		enemyBullets.DoRender()
	End
	
	Method Update:Void(millis:Int)
		scrollY += scrollSpeed * (Float(millis)/1000)
	End
End

Class MyTileMap Extends TileMap
	Method ConfigureLayer:Void(tileLayer:TileMapLayer)
		SetAlpha(tileLayer.opacity)
	End
	
	Method DrawTile:Void(tileLayer:TileMapTileLayer, mapTile:TileMapTile, x:Int, y:Int)
		mapTile.image.DrawTile(x, y, mapTile.id, 0, 1, 1)
	End
End

Class MyTiledTileMapReader Extends TiledTileMapReader
	Method CreateMap:TileMap()
		graphicsPath = "game9/"
		Return New MyTileMap
	End
End

Class Smh_Stage
	Field currentSection:Int = 0
	Field currentSectionStep:Int = 0
	Field waitTimeMillis:Int = 0
	
	Method Update:Void(millis%)
		' if waiting, reduce wait time
		If waitTimeMillis > 0 Then
			waitTimeMillis -= millis
			millis = 0
			If waitTimeMillis < 0 Then
				millis = -waitTimeMillis
				waitTimeMillis = 0
			End
		End
		
		' if we have no millis left, die
		If millis = 0 Then Return
		
		DoLogic(millis)
	End
	
	Method DoLogic:Void(millis%) Abstract
End

Class Smh_Unit Extends Smh_Entity
	Field currentHP:Int
	Field maxHP:Int
	Field died:Bool
	
	Method Update:Void(millis%)
		Super.Update(millis)
		If currentHP <= 0 And Not died Then
			died = True
			Died()
		End
	End
	
	Method Died:Void()
	End
	
	Method CopyFrom:Smh_Entity(source:Smh_Entity)
		Local unit:Smh_Unit = Smh_Unit(source)
		If Not unit Then Return Null ' error, wrong entity type
		Super.CopyFrom(source)
		currentHP = unit.currentHP
		maxHP = unit.maxHP
		died = unit.died
		Return Self
	End
End

Class Smh_Player Extends Smh_Unit
	Const POWER_PER_BOMB# = 80
	Const POWER_PER_LIFE# = 150
	Const MAX_BOMBS% = 5
	Const MAX_LIVES% = 5
	Field firingSpeed:Int = 100
	Field nextShotAvailableMillis:Int = 0
	Field shotSoundDelayMillis:Int = 200
	Field nextShotSoundMillis:Int = 0
	Field playerShot:Smh_Bullet
	Field bulletPowerup:Smh_Powerup
	Field grazeCount:Int
	Field score:Int = 0
	Field bombPower:Float = POWER_PER_BOMB
	Field lifePower:Float = 3 * POWER_PER_LIFE
	Field godMode:Bool = False
	
	Method New()
		alive = True
		active = True
		alpha = 1
		boundsRestrict = True
		boundsPurge = False
		boundsInset = 20
		currentHP = 1
		maxHP = 1
		
		playerShot = New Smh_Bullet
		playerShot.image = diddyGame.images.Find("game9_bullet5")
		playerShot.rotation = 0
		playerShot.rotationSpeed = 360
		playerShot.scaleX = 1.5
		playerShot.scaleY = 1.5
		playerShot.radius = 10
		playerShot.blendMode = AdditiveBlend
		
		bulletPowerup = New Smh_Powerup
		bulletPowerup.CopyFrom(playerShot)
		bulletPowerup.powerValue = 1
		bulletPowerup.scaleX = 1
		bulletPowerup.scaleY = 1
		bulletPowerup.playerInterp = True
		
		image = diddyGame.images.Find("game9_player")
		rotation = 90
		scaleX = 1.25
		scaleY = 1.25
	End
	
	Method Update:Void(millis%)
		Super.Update(millis)
		
		' movement
		Local xdir:Int = 0, ydir:Int = 0
		If KeyDown(KEY_LEFT) Then xdir -= 1
		If KeyDown(KEY_RIGHT) Then xdir += 1
		If KeyDown(KEY_UP) Then ydir -= 1
		If KeyDown(KEY_DOWN) Then ydir += 1
		
		' hard coded for now
		Local playerSpeed:Float = 200
		dx = playerSpeed * xdir
		dy = playerSpeed * ydir
		If KeyDown(KEY_SHIFT) Then
			dx *= 0.4
			dy *= 0.4
		End
		
		' attack
		If KeyDown(KEY_Z) And nextShotAvailableMillis < dt.currentticks Then
			' fire bullet(s)
			playerBullets.FireBulletLinear(playerShot, playerBullets, x, y, -90, 400, 1, 1)
			' update next available
			nextShotAvailableMillis = dt.currentticks + firingSpeed
		End
		If KeyDown(KEY_Z) And nextShotSoundMillis < dt.currentticks Then
			PlaySound(diddyGame.sounds.Find("game9_laser1").sound)
			nextShotSoundMillis = dt.currentticks + shotSoundDelayMillis
		End
		
		' bomb
		If KeyHit(KEY_X) And bombPower >= POWER_PER_BOMB Then
			bombPower -= POWER_PER_BOMB
			enemyBullets.ConvertToPowerups()
		End
		
		' god mode
		If KeyHit(KEY_Q) Then godMode = Not godMode
	End
	
	Method AddBombPower:Void(amt#)
		bombPower += amt
		If bombPower > MAX_BOMBS * POWER_PER_BOMB Then
			bombPower = MAX_BOMBS * POWER_PER_BOMB
		End
	End
	
	Method AddLifePower:Void(amt#)
		lifePower += amt
		If lifePower > MAX_LIVES * POWER_PER_LIFE Then
			lifePower = MAX_LIVES * POWER_PER_LIFE
		End
	End
	
	Method Died:Void()
		PlaySound(diddyGame.sounds.Find("game9_death").sound)
		lifePower -= POWER_PER_LIFE
		If lifePower < 0 Then
			lifePower = 0
			' TODO: game over
			If Not godMode Then smhGameScreen.FadeToScreen(New Smh_GameOverScreen)
		Else
			' destroy bullets
			enemyBullets.Clear()
			' TODO: reset player
			currentHP = maxHP
			died = False
			' TODO: some kind of special effect
		End
	End
End

Class Smh_Enemy Extends Smh_Unit
	Method Update:Void(millis%)
		Super.Update(millis)
	End
	
	Method Died:Void()
		alive = False
		explode1.EmitAt(20, x, y)
		Local pu:Smh_Powerup = Smh_Powerup(powerups.GetEntity(player.bulletPowerup))
		pu.parent = playarea
		pu.x = x
		pu.y = y
		pu.dx = 0
		pu.dy = -50
		pu.accelX = 0
		pu.accelY = 50
		pu.terminalVelocity = 75
		pu.playerInterp = False
		pu.active = True
		pu.boundsPurge = True
		pu.radius = 20
		pu.powerValue = 5
	End
End

Class Smh_Boss Extends Smh_Enemy Abstract
	Field phaseCount:Int = 1
	Field currentPhase:Int = -1
	Field currentPhaseStep:Int = 0
	Field timeRemainingMillis:Int
	Field bossInterping:Bool = False
	Field waitTimeMillis:Int
	Field defeated:Bool = False
	
	' coordinates that boss was when it last interped out of the screen
	Field lastX:Float, lastY:Float
	
	Method New()
		active = True
		boundsRestrict = False
		boundsPurge = False
		rotateWithHeading = True
		usePolar = True
		
		boundsLeft = playarea.boundsLeft
		boundsRight = playarea.boundsRight
		boundsTop = playarea.boundsTop
		boundsBottom = playarea.boundsTop + (playarea.boundsBottom - playarea.boundsTop) * 0.4
		boundsInset = 20
		useParentBounds = False
	End
	
	Method Reset:Void(resetMillis:Bool=True,resetHealth:Bool=True)
		If resetMillis Then timeRemainingMillis = 30000
		If resetHealth Then
			maxHP = 100
			currentHP = 100
		End
		waitTimeMillis = 0
	End
	
	Method Update:Void(millis%)
		' call super
		Super.Update(millis)
		
		' if leaving just die
		If Not bossInterping Then
			' if the boss has run out of health, we go to the next phase
			If currentPhase < 0 Or currentHP <= 0 Then
				currentPhase += 1
				currentPhaseStep = 0
				' if this was the last phase, we win!
				If currentPhase > phaseCount Then
					defeated = True
				Else
					Reset()
					enemyBullets.ConvertToPowerups()
				End
				Return
			End
			
			' update time remaining (this could go negative if we're waiting)
			timeRemainingMillis -= millis
			
			' if we've run out of time, interp off screen
			If timeRemainingMillis <= 0 Then
				InterpOut()
				timeRemainingMillis = 0
				bossInterping = True
				' bullets to powerups
				enemyBullets.ConvertToPowerups()
				Return
			End
		End
		
		' if waiting, reduce wait time
		If waitTimeMillis > 0 Then
			waitTimeMillis -= millis
			millis = 0
			If waitTimeMillis < 0 Then
				millis = -waitTimeMillis
				waitTimeMillis = 0
			End
		End
		
		' if we have no millis left, die
		If millis = 0 Then
			If bossInterping And timeRemainingMillis <= 0 And boss.y < -10 Then
				' boss is gone
				boss = Null
				bossInterping = False
			End
			Return
		End
		
		' time left, do the main boss logic if we're not interping
		If Not bossInterping Then DoLogic(millis)
	End
	
	Method DoLogic:Void(millis%) Abstract
	
	Method InterpOut:Void()
		lastX = x
		lastY = y
		If x < boundsLeft + (boundsRight-boundsLeft)/2 Then
			SetInterpOverTime(x, y, boundsLeft, boundsTop - 100, 2000, 1)
		Else
			SetInterpOverTime(x, y, boundsRight, boundsTop - 100, 2000, 1)
		End
		waitTimeMillis = 2000
	End
	
	Method InterpIn:Void(millis%=2000)
		If lastX < -1000 Or lastY < -1000 Then
			lastX = boundsLeft+(boundsRight-boundsLeft)/2
			lastY = boundsTop+(boundsBottom-boundsTop)/2
		End
		InterpIn(lastX, lastY, millis)
	End
	
	Method InterpIn:Void(targetX:Float, targetY:Float, millis%=2000)
		' interp from a random point
		If targetX < boundsLeft + (boundsRight-boundsLeft)/2 Then
			SetInterpOverTime(Rnd(boundsLeft,(boundsRight-boundsLeft)/2), -100, targetX, targetY, millis, 1)
		Else
			SetInterpOverTime(Rnd((boundsRight-boundsLeft)/2,boundsRight), -100, targetX, targetY, millis, 1)
		End
		waitTimeMillis = millis
	End
End

Class Smh_PowerupPool Extends Smh_Pool<Smh_Powerup>
	Method New(capacity:Int=2000)
		Super.New(capacity)
	End
	
	Method CreateBulletPowerup:Smh_Powerup(template:Smh_Powerup, parent:Smh_Entity, bullet:Smh_Bullet, millis%)
		Purge()
		Local powerup:Smh_Powerup = Null
		If Not parent Then parent = Self
		powerup = GetEntity(template)
		If Not powerup Then Return Null
		powerup.parent = parent
		powerup.active = True
		powerup.x = bullet.x
		powerup.y = bullet.y
		powerup.SetInterpOverTime(bullet.x, bullet.y, player.x, player.y, millis, 1)
		Return powerup
	End
End

Class Smh_BulletPool Extends Smh_Pool<Smh_Bullet>
	Method New(capacity:Int=2000)
		Super.New(capacity)
	End
	
	' fires one or more identical bullets with an optional delay between them
	Method FireBullet:Smh_Bullet(template:Smh_Bullet, parent:Smh_Entity, x:Float, y:Float, delayMillis:Int=0, bulletCount:Int=1)
		' if we're firing more than an arbitrary number, purge
		'If bulletCount > 10 Then Purge()
		Purge()
		Local bullet:Smh_Bullet = Null
		If Not parent Then parent = Self
		For Local i:Int = 1 To bulletCount
			bullet = GetEntity(template)
			If Not bullet Then Return Null
			bullet.parent = parent
			bullet.active = False
			bullet.activeDelayMillis = delayMillis * i
			bullet.x = x
			bullet.y = y
		Next
		Return bullet
	End
	
	' fires one or more identical bullets with an optional delay between them
	Method FireBulletLinear:Smh_Bullet(template:Smh_Bullet, parent:Smh_Entity, x:Float, y:Float, polarAngle:Float, startVelocity:Float, endVelocity:Float, delayMillis:Int=0, bulletCount:Int=1)
		' if we're firing more than an arbitrary number, purge
		'If bulletCount > 10 Then Purge()
		Purge()
		Local bullet:Smh_Bullet = Null
		If Not parent Then parent = Self
		Local velocity:Float = startVelocity
		For Local i:Int = 1 To bulletCount
			bullet = GetEntity(template)
			If Not bullet Then Return Null
			bullet.parent = parent
			bullet.active = False
			bullet.activeDelayMillis = delayMillis * i
			bullet.x = x
			bullet.y = y
			bullet.SetVelocityPolar(polarAngle, velocity)
			velocity += (endVelocity-startVelocity)/bulletCount
		Next
		Return bullet
	End
	
	Method FireBulletSpray:Smh_Bullet(template:Smh_Bullet, parent:Smh_Entity,
			x:Float, y:Float, distance:Float, ' the coordinates to fire from, with a distance offset so that they don't stack on the parent
			startAngle:Float, endAngle:Float, ' the start and end angles for the spray arc
			firstDelayMillis:Int, intervalDelayMillis:Int, ' the delay before the first bullet, and the delay between each bullet
			firstSpeed:Float, lastSpeed:Float, ' the speed of the first and last bullets (the rest are linearly interpolated)
			bulletCount:Int) ' the number of bullets to fire
		' if we're firing more than an arbitrary number, purge
		'If bulletCount > 10 Then Purge()
		Purge()
		Local bullet:Smh_Bullet = Null
		Local delayMillis:Int = firstDelayMillis
		If Not parent Then parent = Self
		For Local i:Int = 0 Until bulletCount
			Local ratio:Float = 0
			If bulletCount > 0 Then ratio = Float(i)/(bulletCount-1)
			Local angle:Float = startAngle + (endAngle-startAngle) * ratio
			While angle > 360 angle -= 360 End
			While angle < 0 angle += 360 End
			bullet = GetEntity(template)
			If Not bullet Then Return Null
			bullet.parent = parent
			bullet.active = False
			bullet.activeDelayMillis = delayMillis
			delayMillis += intervalDelayMillis
			bullet.x = x + distance*Cos(angle)
			bullet.y = y + distance*Sin(angle)
			bullet.SetVelocityPolar(angle, firstSpeed + (lastSpeed-firstSpeed) * ratio)
		Next
		Return bullet
	End
	
	Method ConvertToPowerups:Void(template:Smh_Powerup=Null, millis:Int=1000)
		For Local i:Int = 0 Until aliveCount
			If children[i].alive Then
				If Not template Then template = player.bulletPowerup
				powerups.CreateBulletPowerup(template, Null, children[i], millis)
				children[i].alive = False
			End
		Next
		Purge()
	End
End

Class Smh_EnemyPool Extends Smh_Pool<Smh_Enemy>
	Method New(capacity:Int=200)
		Super.New(capacity)
	End
	
	Method AreAllDead:Bool()
		Purge()
		For Local i:Int = 0 Until aliveCount
			If children[i].alive And children[i].currentHP > 0 Then Return False
		Next
		Return True
	End
	
	Method CreateEnemyWave:Smh_Enemy(template:Smh_Enemy, parent:Smh_Entity,
			x:Float, y:Float,
			polarAngle:Float, polarSpeed:Float,
			firstDelayMillis:Int, intervalDelayMillis:Int,
			enemyCount:Int)
		Purge()
		Local enemy:Smh_Enemy = Null
		Local delayMillis:Int = firstDelayMillis
		If Not parent Then parent = Self
		For Local i:Int = 0 Until enemyCount
			enemy = GetEntity(template)
			If Not enemy Then Return Null
			enemy.parent = parent
			enemy.active = False
			enemy.activeDelayMillis = delayMillis
			delayMillis += intervalDelayMillis
			enemy.x = x
			enemy.y = y
			enemy.SetVelocityPolar(polarAngle, polarSpeed)
		Next
		Return enemy
	End
End

Class Smh_Bullet Extends Smh_Entity
	Method New()
		alive = False
		active = False
		boundsRestrict = False
		boundsPurge = True
		boundsInset = -30
	End
	
	Method Render:Void()
		Super.Render()
	End
End

Class Smh_Powerup Extends Smh_Entity
	Field playerInterp:Bool = False
	Field powerValue:Float = 5
	
	Method New()
		alive = False
		active = True
		boundsRestrict = False
		boundsPurge = True
		boundsInset = -30
	End
	
	Method Update:Void(millis%)
		Super.Update(millis)
		
		' update the interp position
		If playerInterp And interping Then
			targetX = player.x
			targetY = player.y
			polarAngle = ATan2(targetY-y, targetX-x)
		End
		
		' check if we've collected it
		Local pdx# = x-player.x
		Local pdy# = y-player.y
		If pdx*pdx + pdy*pdy <= radius*radius Or playerInterp And Not interping Then
			' collect it
			player.AddLifePower(powerValue)
			active = False
			alive = False
			interping = False
			' trigger a collect on all other powerups if we collected near the top
			If Not playerInterp And player.y < boundsTop+(playarea.boundsBottom-playarea.boundsTop)*0.25 Then
				For Local i:Int = 0 Until powerups.aliveCount
					If powerups.children[i].alive And Not powerups.children[i].playerInterp Then
						powerups.children[i].SuckToPlayer(Null, 1000)
					End
				Next
			End
		End
	End
	
	Method Render:Void()
		#Rem
		Local oldalpha:Float = GetAlpha()
		If useHSL And recalcHSL Then RecalcHSL()
		SetColor(red, green, blue)
		SetAlpha(alpha)
		DrawCircle(0,0,3)
		SetAlpha(oldalpha)
		#End
		Super.Render()
	End
	
	Method CopyFrom:Smh_Entity(source:Smh_Entity)
		Super.CopyFrom(source)
		Local other:Smh_Powerup = Smh_Powerup(source)
		If Not other Then Return Self
		playerInterp = other.playerInterp
		powerValue = other.powerValue
		Return Self
	End
End

''''''''''''''''''''''''' BOSSES '''''''''''''''''''''''''
Class Smh_Stage1 Extends Smh_Stage Implements Smh_EntityLogicHandler
	Field firstBoss:Smh_Boss = New Smh_Stage1Boss1
	Field trash1:Smh_Enemy
	Field trash1Bullet:Smh_Bullet
	
	Method New()
		trash1 = New Smh_Enemy
		trash1.currentHP = 10
		trash1.maxHP = 10
		trash1.boundsInset = -50
		trash1.boundsPurge = True
		trash1.boundsRestrict = False
		trash1.entityTypeId = 0
		trash1.logicHandler = Self
		trash1.logicVar1 = 1500 ' time until next fire
		trash1.logicVar2 = 1000 ' firing frequency
		trash1.image = diddyGame.images.Find("game9_ship2")
		
		trash1Bullet = New Smh_Bullet
		trash1Bullet.image = diddyGame.images.Find("game9_bullet4")
		trash1Bullet.rotation = 0
		trash1Bullet.scaleX = 2
		trash1Bullet.scaleY = 2
		trash1Bullet.radius = 3
		trash1Bullet.blendMode = AdditiveBlend
	End
	
	Method DoLogic:Void(millis%)
		Select currentSection
			Case 0 ' first trash section
				Select currentSectionStep
					Case 0 ' spawn some basic trash
						' spawn trash
						enemies.CreateEnemyWave(
								trash1, playarea,
								-20, playarea.boundsTop+(playarea.boundsBottom-playarea.boundsTop)*0.2,
								15, 100,
								1, 500,
								10)
						enemies.CreateEnemyWave(
								trash1, playarea,
								(playarea.boundsRight-playarea.boundsLeft)+20, playarea.boundsTop+(playarea.boundsBottom-playarea.boundsTop)*0.2,
								180-15, 100,
								3000, 500,
								10)
						currentSectionStep = 1
						waitTimeMillis = 0'3000
						
					Case 1 ' wait until all dead
						' dead check
						If enemies.AreAllDead() Then
							boss = firstBoss
							boss.Reset(True, False)
							boss.InterpIn()
							currentSectionStep = 2
						End
						
					Case 2 ' wait until boss is dead or timed out
						If boss Then
							If boss.defeated Then
								boss = Null
								currentSection = 1
								currentSectionStep = 0
							End
						Else
							currentSectionStep = 0
							waitTimeMillis = 1000
						End
				End
				
			Case 1 ' second trash section
				Select currentSectionStep
					Case 0 ' spawn some trash
						currentSectionStep = 1
						waitTimeMillis = 3000
						
					Case 1 ' wait until all dead
						If enemies.AreAllDead() Then
							currentSectionStep = 2
						End
					
					Case 2 ' we've won, this time
						' TODO: win
				End
		End
	End
	
	Method UpdateLogic:Void(entity:Smh_Entity, millis%)
		Select entity.entityTypeId
			' first trash mob will wait for a certain number of millis, then fire a bullet regularly until dead or offscreen
			Case 0
				' logicVar1 = millis remaining until next fire
				' logicVar2 = fire delay millis
				If entity.alive Then
					While millis > 0
						entity.logicVar1 -= millis
						millis = 0
						If entity.logicVar1 <= 0 Then
							millis = -entity.logicVar1
							entity.logicVar1 = entity.logicVar2
							Local bullet:Smh_Bullet = enemyBullets.FireBulletLinear(trash1Bullet, Null, entity.x, entity.y, ATan2(player.y-entity.y, player.x-entity.x), 75, 75)
							bullet.active = True
							If millis > 0 Then bullet.Update(millis)
						End
					End
				End
		End
	End
End

Class Smh_Stage1Boss1 Extends Smh_Boss Implements Smh_EntityLogicHandler
	Const HOMING_BULLET:Int = 1
	Const RIGHTANGLE_BULLET:Int = 2
	
	Field firstBullet:Smh_Bullet = New Smh_Bullet
	Field secondBullet:Smh_Bullet = New Smh_Bullet
	Field thirdBullet:Smh_Bullet = New Smh_Bullet
	Field fourthBullet:Smh_Bullet = New Smh_Bullet
	
	Field bulletFireCount:Int = 0
	
	Method New()
		radius = 20
		lastX = -10000
		lastY = -10000
		phaseCount = 3
		
		' phase 1
		firstBullet.image = diddyGame.images.Find("game9_bullet1")
		firstBullet.rotation = 45
		firstBullet.scaleX = 1.5
		firstBullet.scaleY = 1.5
		firstBullet.radius = 4
		firstBullet.blendMode = AdditiveBlend
		firstBullet.visibleWhileInactive = True
		firstBullet.fadeInTimeMillis = 1000
		
		secondBullet.image = diddyGame.images.Find("game9_bullet2")
		secondBullet.rotation = 90
		secondBullet.scaleX = 2
		secondBullet.scaleY = 2
		secondBullet.radius = 4
		secondBullet.blendMode = AdditiveBlend
		secondBullet.visibleWhileInactive = False
		secondBullet.fadeInTimeMillis = 1000
		
		thirdBullet.image = diddyGame.images.Find("game9_bullet3")
		thirdBullet.rotation = 90
		thirdBullet.scaleX = 1.5
		thirdBullet.scaleY = 1.5
		thirdBullet.radius = 4
		thirdBullet.blendMode = AdditiveBlend
		thirdBullet.visibleWhileInactive = False
		thirdBullet.fadeInTimeMillis = 1000
		thirdBullet.entityTypeId = HOMING_BULLET
		thirdBullet.logicHandler = Self
		
		' phase 2
		fourthBullet.image = diddyGame.images.Find("game9_bullet1")
		fourthBullet.rotation = 45
		fourthBullet.scaleX = 1.5
		fourthBullet.scaleY = 1.5
		fourthBullet.radius = 4
		fourthBullet.blendMode = AdditiveBlend
		fourthBullet.visibleWhileInactive = False
		fourthBullet.fadeInTimeMillis = 0
		fourthBullet.entityTypeId = RIGHTANGLE_BULLET
		fourthBullet.logicHandler = Self
		
		image = diddyGame.images.Find("game9_ship6")
		rotation = 90
		'anim = New Smh_AnimStrip(images.Find("Ship1"))
		' FIXME: first frame always skipped
	End
	
	Method DoLogic:Void(millis%)
		Local boundsWidth:Float = boundsRight-boundsLeft
		Local boundsHeight:Float = boundsBottom-boundsTop
		Select currentPhase
			Case 0 ' first phase
				Select currentPhaseStep
					Case 0
						'Reset()
						currentPhaseStep = 1
						polarAngle = 90
						
					Case 1
						' fire and wait
						Local direction:Float = ATan2(player.y-y,player.x-x)
						Local srcX:Float = x - Cos(direction)*5
						Local srcY:Float = y - Sin(direction)*5
						Local intervalAngle:Float = 45.0/8.0
						Local firstAngle:Float = direction - intervalAngle
						Local speed:Float = 150
						Local intervalSpeed:Float = 20
						Local delay:Float = 10
						For Local i:Int = 3 To 8
							enemyBullets.FireBulletSpray(
								firstBullet, Null,
								srcX, srcY, 0,
								firstAngle, firstAngle+intervalAngle*(i-1),
								1000+delay*(i-3), 0,
								speed-(i-3)*intervalSpeed, speed-(i-3)*intervalSpeed,
								i)
							firstAngle -= intervalAngle/2
						Next
						polarAngle = direction
						waitTimeMillis = 3000
				End
				
			Case 1 ' second phase
				Select currentPhaseStep
					Case 0
						' interp to top right
						'Reset()
						SetInterpOverTime(x, y, boundsLeft+boundsWidth*0.75, boundsHeight/2, 3000, 1)
						waitTimeMillis = 1000
						currentPhaseStep = 1
						
					Case 1
						' fire second bullet type (while moving)
						enemyBullets.FireBulletSpray(
							secondBullet, Null,
							x, y, 0,
							0, 360*(19.0/20.0),
							1, 0,
							50, 50,
							20)
						waitTimeMillis = 1000
						currentPhaseStep = 2
						
					Case 2
						' fire third bullet type (while moving)
						enemyBullets.FireBulletSpray(
							thirdBullet, Null,
							x, y, 0,
							0, 360*(39.0/40.0),
							1, 0,
							100, 100,
							40)
						waitTimeMillis = 1000
						currentPhaseStep = 3
						
					Case 3
						' fire second bullet type (while moving)
						enemyBullets.FireBulletSpray(
							secondBullet, Null,
							x, y, 0,
							0, 360*(19.0/20.0),
							1, 0,
							50, 50,
							20)
						currentPhaseStep = 4
						waitTimeMillis = 2000
						
					Case 4
						' random interp, loop to 1
						SetInterpRandomOverTime(x, y, 80, 110, 2000, 1)
						currentPhaseStep = 1
				End
				
			Case 2 ' third phase
				Select currentPhaseStep
					Case 0
						' interp to the middle
						'Reset()
						SetInterpOverTime(x, y, boundsLeft+(boundsRight-boundsLeft)/2, boundsTop+(boundsBottom-boundsTop)/2, 2000, 1)
						waitTimeMillis = 3000
						currentPhaseStep = 1
						bulletFireCount = 0
						
					Case 1
						' face down
						polarAngle = 90
						' fire bullet 4
						enemyBullets.FireBulletLinear(
							fourthBullet, Null,
							x, y,
							5*(bulletFireCount-1), 40, 200,
							1, 3)
						enemyBullets.FireBulletLinear(
							fourthBullet, Null,
							x, y,
							180-5*(bulletFireCount-1), 40, 200,
							1, 3)
						bulletFireCount += 1
						If bulletFireCount = 11 Then bulletFireCount = 0
						waitTimeMillis = 1000
				End
		End
	End
	
	Method UpdateLogic:Void(entity:Smh_Entity, millis%)
		' homing bullets
		If entity.entityTypeId = HOMING_BULLET Then
			If entity.logicVar1 = 0 Then
				entity.polarVelocity -= 55 * Float(millis) / 1000.0
				If entity.polarVelocity < 0 Then
					entity.polarVelocity = 100
					entity.polarAngle = ATan2(player.y-entity.y,player.x-entity.x)
					entity.logicVar1 = 1
				End
				entity.recalcPolar = True
			End
		Elseif entity.entityTypeId = RIGHTANGLE_BULLET Then
			If entity.logicVar2 <= 0 Then entity.logicVar2 = entity.polarVelocity
			If entity.logicVar1 = 0 Then
				Local targetTime# = 2500
				Local currentTime# = dt.currentticks - entity.activeTimeMillis
				Local ratio:Float = Min(1.0, currentTime / targetTime)
				ratio *= ratio
				entity.polarVelocity = entity.logicVar2 * (1-ratio)
				' assume they've all stopped at a certain life value
				If currentTime >= targetTime Then
					entity.polarVelocity = 40
					If entity.polarAngle > 90 Then
						entity.polarAngle -= 90
					Else
						entity.polarAngle += 90
					End
					entity.logicVar1 = 1
				End
				entity.recalcPolar = True
			End
		End
	End
End

#rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#End