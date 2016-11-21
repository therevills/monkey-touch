#Rem
header:
[quote]

[b]File Name :[/b] Game12
[b]Author    :[/b] Paul "tiresius" Apgar
[b]About     :[/b]
As simple a Dungeon Crawler as you can get!
Go through the random levels to the bottom and retrieve
the Lost Wand!  This game is heavily inspired by
[i]Sword of Fargoal[/i] by Jeff McCord.
A game from 1982, for the Commodore 64.
[/quote]
#End

Strict

Import main

Global Game12PlayScr:Screen = New Game12PlayScreen()
Global Game12TransScr:Screen = New Game12TransitionScreen()
Global Game12EndScr:Screen = New Game12EndScreen()
Global Game12Gfx:Game12Graphics = New Game12Graphics()
Global Game12Snd:Game12Sounds = New Game12Sounds()

#Rem
summary:Title Screen Class.
Used To manage And deal with all Title Page stuff.
#End
Class Game12Screen Extends Screen
	
	Method New()
		name = "The Lost Wand"
		Local gameid:Int = 12
		GameList[gameid - 1] = New miniGame
		GameList[gameid - 1].id = gameid - 1
		GameList[gameid - 1].name = "Lost Wand"
		GameList[gameid - 1].iconname = "game" + gameid + "_icon"
		GameList[gameid - 1].thumbnail = "game" + gameid + "_thumb"
		GameList[gameid - 1].author = "Paul Apgar"
		GameList[gameid - 1].authorurl = "funcygames.com"
		GameList[gameid - 1].info = "Crawl your way through the dungeon and get The Lost Wand!"
	End Method
	
	#Rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		diddyGame.screenFade.Start(50, False)

		#If TARGET="glfw"
			diddyGame.MusicPlay("", False)
		#Else
			diddyGame.MusicPlay("", False)
		#End
		InitGraphics()   ' InitGraphics not needed if Atlas Sheet Done
		LoadGraphics()
		LoadFonts()
		InitSounds()
		LoadSounds()
		InitGame()
	End Method
	
	#Rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		Game12Gfx.Title.Draw(0, 0)
	End Method

	#Rem
	summary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	And all user input.
	#End
	Method Update:Void()

		' Keyboard short cuts
		If KeyHit(KEY_ESCAPE)
			FadeToScreen(TitleScr)
		Endif
		
		If KeyHit(KEY_SPACE)
			FadeToScreen(Game12TransScr)
		EndIf
		
		' Mouse input
		if TouchHit() or TouchDown()
			If diddyGame.mouseX < SCREEN_WIDTH2
				FadeToScreen(TitleScr)
			Else
				FadeToScreen(Game12TransScr)
			EndIf
		EndIf
	End Method
	
	' This Method can go away if we have these images loaded into the Atlas sprite sheet
	Method InitGraphics:Void()
		diddyGame.images.Load("game12/title3.png","g12Title",False)
		diddyGame.images.Load("game12/wall.png","g12Wall",True)
		diddyGame.images.Load("game12/floor.png","g12Floor",True)
		diddyGame.images.Load("game12/hidden.png","g12Hidden",True)
		diddyGame.images.Load("game12/player.png","g12Player",True)
		diddyGame.images.Load("game12/ustair.png","g12UStair",True)
		diddyGame.images.Load("game12/dstair.png","g12DStair",True)
		diddyGame.images.Load("game12/heart.png","g12Heart",True)
		diddyGame.images.Load("game12/sword.png","g12Sword",True)
		diddyGame.images.Load("game12/shield.png","g12Shield",True)
		diddyGame.images.Load("game12/gold.png","g12Gold",True)
		diddyGame.images.Load("game12/battle.png","g12Battle",True)
		diddyGame.images.Load("game12/heal.png","g12Heal",True)
		diddyGame.images.Load("game12/unknown.png","g12Unknown",True)
		diddyGame.images.Load("game12/temple.png","g12Temple",True)
		diddyGame.images.Load("game12/crown.png","g12Crown",True)
		diddyGame.images.Load("game12/goldbar.png","g12GoldBar",True)
		diddyGame.images.Load("game12/food.png","g12Food",True)
		diddyGame.images.Load("game12/shovel.png","g12Shovel",True)
		diddyGame.images.Load("game12/bolt.png","g12Bolt",True)
		diddyGame.images.Load("game12/explosion.png","g12Explosion",True)
		diddyGame.images.Load("game12/fireball.png","g12Fireball",True)
		diddyGame.images.Load("game12/poison.png","g12Poison",True)
		diddyGame.images.Load("game12/punji.png","g12Punji",True)
		diddyGame.images.Load("game12/pit.png","g12Pit",True)
		diddyGame.images.Load("game12/skull.png","g12Skull",True)
		diddyGame.images.Load("game12/splat.png","g12Splat",True)
		diddyGame.images.Load("game12/miss.png","g12Miss",True)
		diddyGame.images.Load("game12/healbutton.png","g12HealButton",True)
		diddyGame.images.Load("game12/digbutton.png","g12DigButton",True)
		diddyGame.images.Load("game12/exitbutton.png","g12ExitButton",True)
		diddyGame.images.Load("game12/orc.png","g12Orc",True)
		diddyGame.images.Load("game12/spider.png","g12Spider",True)
		diddyGame.images.Load("game12/goblin.png","g12Goblin",True)
		diddyGame.images.Load("game12/giant.png","g12Giant",True)
		diddyGame.images.Load("game12/ghost.png","g12Ghost",True)
		diddyGame.images.Load("game12/staffman.png","g12Fighter",True)
		diddyGame.images.Load("game12/beholder.png","g12Beholder",True)
		diddyGame.images.Load("game12/reddragon.png","g12RedDragon",True)
		diddyGame.images.Load("game12/roc.png","g12Roc",True)
		diddyGame.images.Load("game12/bee.png","g12Bee",True)
		diddyGame.images.Load("game12/skeleton.png","g12Skeleton",True)
		diddyGame.images.Load("game12/bat.png","g12Bat",True)
		diddyGame.images.Load("game12/plant.png","g12Plant",True)
		diddyGame.images.Load("game12/wolf.png","g12Wolf",True)
		diddyGame.images.Load("game12/ooze.png","g12Ooze",True)
		diddyGame.images.Load("game12/smashsplat.png","g12SmashSplat",True)
		diddyGame.images.Load("game12/smashbutton.png","g12SmashButton",True)
		diddyGame.images.Load("game12/wand.png","g12Wand",True)
	End Method
	
	Method InitSounds:Void()
		diddyGame.sounds.Load("g12_coin", "g12coin")
		diddyGame.sounds.Load("g12_explosion", "g12explosion")
		diddyGame.sounds.Load("g12_goingdown", "g12goingdown")
		diddyGame.sounds.Load("g12_goingup", "g12goingup")
		diddyGame.sounds.Load("g12_goody", "g12goody")
		diddyGame.sounds.Load("g12_heal", "g12heal")
		diddyGame.sounds.Load("g12_hithurt1", "g12hithurt1")
		diddyGame.sounds.Load("g12_hithurt2", "g12hithurt2")
		diddyGame.sounds.Load("g12_hithurt3", "g12hithurt3")
		diddyGame.sounds.Load("g12_hithurt4", "g12hithurt4")
		diddyGame.sounds.Load("g12_levelup", "g12levelup")
		diddyGame.sounds.Load("g12_miss1", "g12miss1")
		diddyGame.sounds.Load("g12_miss2", "g12miss2")
		diddyGame.sounds.Load("g12_miss3", "g12miss3")
		diddyGame.sounds.Load("g12_smash", "g12smash")
		diddyGame.sounds.Load("g12_temple", "g12temple")
		diddyGame.sounds.Load("g12_combat", "g12combat")
	End Method
	
	Method LoadSounds:Void()
		Game12Snd.coin = diddyGame.sounds.Find("g12coin")
		Game12Snd.explode = diddyGame.sounds.Find("g12explosion")
		Game12Snd.godown = diddyGame.sounds.Find("g12goingdown")
		Game12Snd.goody = diddyGame.sounds.Find("g12goody")
		Game12Snd.heal = diddyGame.sounds.Find("g12heal")
		Game12Snd.goup = diddyGame.sounds.Find("g12goingup")
		Game12Snd.hit1 = diddyGame.sounds.Find("g12hithurt1")
		Game12Snd.hit2 = diddyGame.sounds.Find("g12hithurt2")
		Game12Snd.hit3 = diddyGame.sounds.Find("g12hithurt3")
		Game12Snd.hit4 = diddyGame.sounds.Find("g12hithurt4")
		Game12Snd.levelup = diddyGame.sounds.Find("g12levelup")
		Game12Snd.miss1 = diddyGame.sounds.Find("g12miss1")
		Game12Snd.miss2 = diddyGame.sounds.Find("g12miss2")
		Game12Snd.miss3 = diddyGame.sounds.Find("g12miss3")
		Game12Snd.smash = diddyGame.sounds.Find("g12smash")
		Game12Snd.temple = diddyGame.sounds.Find("g12temple")
		Game12Snd.combat = diddyGame.sounds.Find("g12combat")
	End Method
	
	Method InitGame:Void()
		levelDepth = 1
		lastLevelDepth = 1
		nextLevelDepth = 1
		player = New Player
		currAnim = Null
	End Method
		
	Method LoadGraphics:Void()
		Game12Gfx.Title = diddyGame.images.Find("g12Title")
		Game12Gfx.Wall = diddyGame.images.Find("g12Wall")
		Game12Gfx.Floor = diddyGame.images.Find("g12Floor")
		Game12Gfx.Hidden = diddyGame.images.Find("g12Hidden")
		Game12Gfx.Player = diddyGame.images.Find("g12Player")
		Game12Gfx.Heart = diddyGame.images.Find("g12Heart")
		Game12Gfx.StairsUp = diddyGame.images.Find("g12UStair")
		Game12Gfx.StairsDown = diddyGame.images.Find("g12DStair")
		Game12Gfx.Sword = diddyGame.images.Find("g12Sword")
		Game12Gfx.Shield = diddyGame.images.Find("g12Shield")
		Game12Gfx.Gold = diddyGame.images.Find("g12Gold")
		Game12Gfx.Battle = diddyGame.images.Find("g12Battle")
		Game12Gfx.Heal = diddyGame.images.Find("g12Heal")
		Game12Gfx.Unknown = diddyGame.images.Find("g12Unknown")
		Game12Gfx.Temple = diddyGame.images.Find("g12Temple")
		Game12Gfx.Crown = diddyGame.images.Find("g12Crown")
		Game12Gfx.GoldBar = diddyGame.images.Find("g12GoldBar")
		Game12Gfx.Food = diddyGame.images.Find("g12Food")
		Game12Gfx.Shovel = diddyGame.images.Find("g12Shovel")
		Game12Gfx.Bolt = diddyGame.images.Find("g12Bolt")
		Game12Gfx.Explosion = diddyGame.images.Find("g12Explosion")
		Game12Gfx.Fireball = diddyGame.images.Find("g12Fireball")
		Game12Gfx.Poison = diddyGame.images.Find("g12Poison")
		Game12Gfx.Punji = diddyGame.images.Find("g12Punji")
		Game12Gfx.Pit = diddyGame.images.Find("g12Pit")
		Game12Gfx.Skull = diddyGame.images.Find("g12Skull")
		Game12Gfx.Splat = diddyGame.images.Find("g12Splat")
		Game12Gfx.SmashSplat = diddyGame.images.Find("g12SmashSplat")
		Game12Gfx.Miss = diddyGame.images.Find("g12Miss")
		Game12Gfx.SmashButton = diddyGame.images.Find("g12SmashButton")
		Game12Gfx.HealButton = diddyGame.images.Find("g12HealButton")
		Game12Gfx.DigButton = diddyGame.images.Find("g12DigButton")
		Game12Gfx.ExitButton = diddyGame.images.Find("g12ExitButton")
		Game12Gfx.Orc = diddyGame.images.Find("g12Orc")
		Game12Gfx.Spider = diddyGame.images.Find("g12Spider")
		Game12Gfx.Goblin = diddyGame.images.Find("g12Goblin")
		Game12Gfx.Giant = diddyGame.images.Find("g12Giant")
		Game12Gfx.Ghost = diddyGame.images.Find("g12Ghost")
		Game12Gfx.Bee = diddyGame.images.Find("g12Bee")
		Game12Gfx.Fighter = diddyGame.images.Find("g12Fighter")
		Game12Gfx.Beholder = diddyGame.images.Find("g12Beholder")
		Game12Gfx.RedDragon = diddyGame.images.Find("g12RedDragon")
		Game12Gfx.Roc = diddyGame.images.Find("g12Roc")
		Game12Gfx.Skeleton = diddyGame.images.Find("g12Skeleton")
		Game12Gfx.Bat = diddyGame.images.Find("g12Bat")
		Game12Gfx.Plant = diddyGame.images.Find("g12Plant")
		Game12Gfx.Wolf = diddyGame.images.Find("g12Wolf")
		Game12Gfx.Ooze = diddyGame.images.Find("g12Ooze")
		Game12Gfx.Wand = diddyGame.images.Find("g12Wand")
	End Method

	Method LoadFonts:Void()
		font20 = New BitmapFont2("fonts/joystix_20.txt", True)
	End Method

End Class

Class Game12Graphics
	Field Title:GameImage
	Field Wall:GameImage
	Field Floor:GameImage
	Field Hidden:GameImage
	Field Player:GameImage
	Field Heart:GameImage
	Field StairsUp:GameImage
	Field StairsDown:GameImage
	Field Temple:GameImage
	Field Gold:GameImage
	Field Crown:GameImage
	Field Unknown:GameImage
	Field Sword:GameImage
	Field Shield:GameImage
	Field Battle:GameImage
	Field Heal:GameImage
	Field GoldBar:GameImage
	Field Food:GameImage
	Field Shovel:GameImage
	Field Bolt:GameImage
	Field Explosion:GameImage
	Field Fireball:GameImage
	Field Poison:GameImage
	Field Punji:GameImage
	Field Pit:GameImage
	Field Skull:GameImage
	Field Splat:GameImage
	Field SmashSplat:GameImage
	Field Miss:GameImage
	Field SmashButton:GameImage
	Field HealButton:GameImage
	Field DigButton:GameImage
	Field ExitButton:GameImage
	Field Orc:GameImage
	Field Spider:GameImage
	Field Goblin:GameImage
	Field Giant:GameImage
	Field Ghost:GameImage
	Field Bee:GameImage
	Field Fighter:GameImage
	Field Beholder:GameImage
	Field RedDragon:GameImage
	Field Roc:GameImage
	Field Skeleton:GameImage
	Field Bat:GameImage
	Field Plant:GameImage
	Field Wolf:GameImage
	Field Ooze:GameImage
	Field Wand:GameImage
End Class

Class Game12Sounds
	Field coin:GameSound
	Field explode:GameSound
	Field godown:GameSound
	Field goup:GameSound
	Field goody:GameSound
	Field heal:GameSound
	Field hit1:GameSound
	Field hit2:GameSound
	Field hit3:GameSound
	Field hit4:GameSound
	Field levelup:GameSound
	Field miss1:GameSound
	Field miss2:GameSound
	Field miss3:GameSound
	Field smash:GameSound
	Field temple:GameSound
	Field combat:GameSound
End Class

Global font20:BitmapFont2

Global levelDepth:Int
Global lastLevelDepth:Int
Global nextLevelDepth:Int
Global player:Player
Global currLevel:Level
Global currAnim:Anim

Class Game12PlayScreen Extends Screen

	Field timer:Int

	Method New()
	End Method

	Method Start:Void()
		Seed = Millisecs()
		levelDepth = nextLevelDepth
		currLevel = New Level(levelDepth)
		currLevel.GenerateLevel()
		If lastLevelDepth = levelDepth = nextLevelDepth Or player.state = STATE_DIGGING
			currLevel.PlacePlayerStart(True)
		Else
			currLevel.PlacePlayerStart()
		EndIf
		currLevel.ShowSquare(player.x, player.y)
		lastLevelDepth = levelDepth
		timer = Millisecs()
		player.state = STATE_START
		diddyGame.screenFade.Start(50, False)
	End Method

	Method Render:Void()
		Cls
		currLevel.Render()
	End Method

	Method Update:Void()
		
		Select player.state
			Case STATE_START
				' Pause the initial level for 1 second
				If Millisecs() > (timer + 1000)
					player.state = STATE_ACTIVE
					player.ResetTimer()
					currLevel.ResetEntityTimers()
					AnimList.Clear()
				EndIf
			Case STATE_ACTIVE
				player.Update()
				currLevel.UpdateEntities()

				' Updates may have changed player state, confirm we can still do input
				If player.state = STATE_ACTIVE
					If KeyHit(KEY_ENTER) Or KeyHit(KEY_SPACE) Or (MouseHit() And player.ClickRelativeDir(DIR_NONE, False) = True)
						Local item:Item
						item = currLevel.FindItemByLocation(player.x, player.y)
						If item Then player.ActivateItem(item)
					EndIf
					player.CheckButtonClick()
				EndIf
	
			Case STATE_INACTIVE
			Case STATE_FALLING
				nextLevelDepth = levelDepth + 2
				If nextLevelDepth > 18 Then nextLevelDepth = 18
				player.state = STATE_INACTIVE
				Game12PlayScr.FadeToScreen(Game12TransScr)
			Case STATE_ANIM
				If currAnim
					If currAnim.Done() = True
						currAnim = GetNextAnimation()
					Else
						currAnim.Update()
					EndIf
				Else
					currAnim = GetNextAnimation()
					' If done with animations go back to playing game !
					If currAnim = Null
						currLevel.ResetEntityTimers()
						If player.nextState <> STATE_NONE
							player.state = player.nextState
							player.nextState = STATE_NONE
						Else
							player.state = STATE_ACTIVE
						EndIf
					EndIf
				EndIf
			Case STATE_COMBAT_START
				If player.firstHit
					player.nextCombatTime = player.currTime + COMBAT_SPEED
					player.attacker.nextCombatTime = player.attacker.currTime + COMBAT_SPEED * 1.5
				Else
					player.attacker.nextCombatTime = player.attacker.currTime + COMBAT_SPEED
					player.nextCombatTime = player.currTime + COMBAT_SPEED * 1.5
				EndIf
				player.state = STATE_COMBAT
			Case STATE_COMBAT
				player.Update()
				player.UpdateCombat()
				If player.attacker
					player.attacker.Update()
					player.attacker.UpdateCombat()
					If player.attacker.hitAnim = Null
						If player.attacker.alive = False
							player.state = STATE_COMBAT_END
						EndIf
					EndIf
				EndIf
				player.CheckButtonClick()
				If KeyHit(KEY_SPACE) Then player.TrySmashAttack()
			Case STATE_COMBAT_ANIM
				If player.combatAnim.Done() = False Then player.combatAnim.Update()
				If player.attacker.combatAnim.Done() = False Then player.attacker.combatAnim.Update()
				If player.combatAnim.Done() And player.attacker.combatAnim.Done() Then player.state = STATE_COMBAT_START
			Case STATE_COMBAT_END
				player.EndCombat()
				currLevel.ResetEntityTimers()
				If player.alive = False
					QueueAnimation(Game12Gfx.Skull, player.x * TILE_SIZE + (TILE_SIZE / 2), player.y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.explode)
				EndIf
				' Maybe add an ending animation where player zooms back out ??
			Case STATE_DEAD
				' Call Death Screen ?
				FadeToScreen(Game12EndScr)
			Case STATE_WIN
				' Add to score?
				FadeToScreen(Game12EndScr)
		End Select

		' Always allow player to escape game back to Title screen ...		
		If KeyHit(KEY_ESCAPE)
			player.state = STATE_INACTIVE
			FadeToScreen(Game12Scr)
		Endif
	End Method
		
End Class

Class Game12TransitionScreen Extends Screen

	Field timer:Int

	Method New()
	End Method

	Method Start:Void()
		timer = Millisecs()
		diddyGame.screenFade.Start(50, False)
	End Method

	Method Render:Void()
		Cls
		If player.state = STATE_DIGGING
			font20.DrawText("Digging Down To Level " + String(nextLevelDepth), SCREEN_WIDTH2, SCREEN_HEIGHT2, 2)
		ElseIf nextLevelDepth = lastLevelDepth+1 Or levelDepth-1 = lastLevelDepth
			font20.DrawText("Descending To Level " + String(nextLevelDepth), SCREEN_WIDTH2, SCREEN_HEIGHT2, 2)
		ElseIf nextLevelDepth = lastLevelDepth-1 Or levelDepth+1 = lastLevelDepth
			font20.DrawText("Ascending To Level " + String(nextLevelDepth), SCREEN_WIDTH2, SCREEN_HEIGHT2, 2)
		ElseIf nextLevelDepth > lastLevelDepth+1 Or levelDepth > lastLevelDepth+1
			font20.DrawText("Falling To Level " + String(nextLevelDepth), SCREEN_WIDTH2, SCREEN_HEIGHT2, 2)
		Else
			font20.DrawText("Entering the Dungeon!", SCREEN_WIDTH2, SCREEN_HEIGHT2, 2)
		EndIf
	End Method

	Method Update:Void()
		If Millisecs() > timer + 500
			lastLevelDepth = levelDepth
			FadeToScreen(Game12PlayScr)
		Endif
	End Method
		
End Class

Class Game12EndScreen Extends Screen

	Method New()
	End Method

	Method Start:Void()
		diddyGame.screenFade.Start(50, False)
	End Method

	Method Render:Void()
		Cls
		If player.alive = False
			font20.DrawText("You Died!", SCREEN_WIDTH2, SCREEN_HEIGHT2 / 3, 2)
			Game12Gfx.Skull.DrawStretched(SCREEN_WIDTH2, SCREEN_HEIGHT2, TILE_SIZE * 7, TILE_SIZE * 7)
		Else
			font20.DrawText("You Found The Wand!", SCREEN_WIDTH2, SCREEN_HEIGHT2 / 3, 2)
			Game12Gfx.Wand.DrawStretched(SCREEN_WIDTH2, SCREEN_HEIGHT2, TILE_SIZE * 7, TILE_SIZE * 7)
		EndIf
		
	End Method

	Method Update:Void()
		If KeyHit(KEY_ENTER) Or KeyHit(KEY_SPACE) Or KeyHit(KEY_ESCAPE) Or TouchHit()
			lastLevelDepth = levelDepth
			FadeToScreen(Game12Scr)
		Endif
	End Method

End Class

' Map constants
Const MAPX:Int = 18
Const MAPY:Int = 15

' Tile constants
Const TILE_SIZE:Int = 32
Const TILE_FLOOR:Int = 0
Const TILE_WALL:Int = 1
Const ANIM_SIZE:Float = 3.0		' How many tiles wide will the animation get?

' Balancing variables
Const LEV_EXP :Int = 100		' Experience needed per Level to go up another Level
Const PLYR_HEAL_RATE:Int = 15
Const MONS_BATTLESKILL:Float = 5.0' Monster battle skill per level
Const MONS_HITPOINTS:Int = 5	' Monster hit points per level
Const MONS_HEAL_RATE:Int = 30	' Monsters should heal more slowly than players
Const MONS_MOVE_RATE:Int = 5000 ' Monsters movement ever ## millisecs
Const MONS_EXP:Int = 25         ' How much experience given to player per level
Const TRAP_DAM:Int = 3			' Max damage of traps, per level depth

Const COMBAT_SPEED:Int = 2000   ' Number of milliseconds between strikes
Const COMBAT_BASE_ATTACK:Int = 2 ' Base attack for starting out

' Direction constants
Const DIR_NONE:Int = 0
Const DIR_NORTH:Int = 1
Const DIR_NORTHEAST:Int = 2
Const DIR_EAST:Int = 3
Const DIR_SOUTHEAST:Int = 4
Const DIR_SOUTH:Int = 5
Const DIR_SOUTHWEST:Int = 6
Const DIR_WEST:Int = 7
Const DIR_NORTHWEST:Int = 8

Class Tile
	Field type:Int			' Type of tile
	Field visible:Bool		' Is tile visible to player?
	Field blockable:Bool	' Is tile blockable for entity?
End Class

' Item Constants for type of item
Const ITEM_UNKNOWN:Int = 1			' Unused
Const ITEM_GOLD:Int = 2				' Bag of Gold
Const ITEM_USTAIR:Int = 3			' Up Stairs
Const ITEM_DSTAIR:Int = 4			' Down Stairs
Const ITEM_TEMPLE:Int = 5			' Temple where player can heal
Const ITEM_GENERATOR:Int = 6		' Generator of monsters
Const ITEM_HEAL:Int = 7				' Healing potion
Const ITEM_SWORD:Int = 8			' Enchanted Weapon +1
Const ITEM_SHIELD:Int = 9			' Enchanted Armor +1
Const ITEM_GOLDBAR:Int = 10			' Gold Bar (lots of gold)
Const ITEM_FOOD:Int = 11			' Food (heals player)
Const ITEM_SHOVEL:Int = 12			' Shovel (allows player to dig down)
Const ITEM_WAND:Int = 13 			' Wand (win the game!)

' Traps are items too, for simplicity sake and all do the same calculated damage
Const ITEM_FIREBALL:Int = 20		' Fireball (hurt player)
Const ITEM_EXPLOSION:Int = 21		' Explosion (hurt player)
Const ITEM_POISON:Int = 22			' Poison Cloud (hurt player, not cumulative)
Const ITEM_BOLT:Int = 23			' Lightning Bolt (hurt player)
Const ITEM_PUNJI:Int = 24			' Punji sticks (hurt player)
Const ITEM_PIT:Int = 25				' Pit to fall in (hurt player, may travel down several levels)


Class Item
	Field type:Int				' Type of Item
	Field image:GameImage		' Image of the item
	Field instantAction:Bool	' If land on item, instant action?
	Field seenYet:Bool			' Has this item been seen yet?  (landed upon)
	Field unknown:Bool			' Is it still an Unknown?
	Field x:Int					' X Coordinate of item on Map
	Field y:Int					' Y Coordinate of item on Map
	Field snd:GameSound			' For items which have immediate sound (not tied to animation)

	Method New(type:Int, image:GameImage, x:Int, y:Int)
		Self.type = type
		Self.image = image
		Self.x = x
		Self.y = y
	End Method
	
	Method Render:Void()
		' If can't see them, don't draw them!
		If currLevel.tiles[x][y].visible = False Then Return
		
		' Since graphics are centered with mid-handle, need to translate display
		PushMatrix()
		Translate TILE_SIZE / 2, TILE_SIZE / 2
		
		If unknown = True
			Game12Gfx.Unknown.Draw(x*TILE_SIZE, y*TILE_SIZE)
		Else
			image.Draw(x*TILE_SIZE, y*TILE_SIZE)
		EndIf
		PopMatrix()
	End Method

	Method DoAction:Bool()
		Print "Item Action Undefined"
		Return True
	End Method
End Class

Class DownStairs Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_DSTAIR, Game12Gfx.StairsDown, x, y)
		snd = Game12Snd.godown
	End Method
	
	Method DoAction:Bool()
		nextLevelDepth += 1
		player.state = STATE_INACTIVE
		Game12Snd.godown.Play(1)
		Game12PlayScr.FadeToScreen(Game12TransScr)
		Return False
	End Method
End Class

Class UpStairs Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_USTAIR, Game12Gfx.StairsUp, x, y)
		snd = Game12Snd.goup
	End Method
	
	Method DoAction:Bool()
		nextLevelDepth -= 1
		player.state = STATE_INACTIVE
		Game12Snd.goup.Play(1)
		Game12PlayScr.FadeToScreen(Game12TransScr)
		Return False
	End Method
End Class

Class GoldBag Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_GOLD, Game12Gfx.Gold, x, y)
		instantAction = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.coin)
		Local amt:Int = Rnd(levelDepth * 3) + (levelDepth * 5)
		player.AddGold(amt)
		Return True
	End Method
End Class

Class GoldBar Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_GOLDBAR, Game12Gfx.GoldBar, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.goody)
		Local amt:Int = Rnd(levelDepth * 10) + (levelDepth * 20)
		player.AddGold(amt)
		Return True
	End Method
End Class

Class Temple Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_TEMPLE, Game12Gfx.Temple, x, y)
		instantAction = True
	End Method
	
	Method DoAction:Bool()
		' This will prevent the zoom-in effect for something the player has already landed on
		If seenYet = False Then QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.temple)
		seenYet = True
		If player.gold > 0
			Game12Snd.coin.Play(1)
			player.AddExp(player.gold)
			player.EmptyGold()
		EndIf
		Return False
	End Method
End Class

Class Food Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_FOOD, Game12Gfx.Food, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.goody)
		Local amt:Int = Rnd(levelDepth * 5) + 10
		player.Heal(amt)
		Return True
	End Method
End Class


Class Heal Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_HEAL, Game12Gfx.Heal, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.heal)
		player.healPotions += 1
		Return True
	End Method
End Class

Class Shovel Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_SHOVEL, Game12Gfx.Shovel, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.goody)
		player.shovels += 1
		Return True
	End Method
End Class


Class Sword Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_SWORD, Game12Gfx.Sword, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.goody)
		player.weaponPower += 1
		Return True
	End Method
End Class

Class Shield Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_SHIELD, Game12Gfx.Shield, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.goody)
		player.armorPower += 1
		Return True
	End Method
End Class

Class Fireball Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_FIREBALL, Game12Gfx.Fireball, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.explode)
		player.Damage(Rnd(levelDepth * TRAP_DAM)+1)
		Return True
	End Method
End Class

Class Explosion Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_EXPLOSION, Game12Gfx.Explosion, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.explode)
		player.Damage(Rnd(levelDepth * TRAP_DAM)+1)
		Return True
	End Method
End Class

Class Punji Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_PUNJI, Game12Gfx.Punji, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.explode)
		player.Damage(Rnd(levelDepth * TRAP_DAM)+1)
		Return True
	End Method
End Class

Class Poison Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_POISON, Game12Gfx.Poison, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.explode)
		player.Damage(Rnd(levelDepth * TRAP_DAM)+1)
		Return True
	End Method
End Class

Class Bolt Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_BOLT, Game12Gfx.Bolt, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.explode)
		player.Damage(Rnd(levelDepth * TRAP_DAM)+1)
		Return True
	End Method
End Class

Class Pit Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_PIT, Game12Gfx.Pit, x, y)
		instantAction = True
		unknown = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.godown)
		player.Damage(Rnd(levelDepth * TRAP_DAM)+1)
		' If we don't die from the pit fall, have player fall down a couple levels
		If player.nextState <> STATE_DEAD Then player.nextState = STATE_FALLING
		Return True
	End Method
End Class

Class Wand Extends Item
	Method New(x:Int, y:Int)
		Super.New(ITEM_WAND, Game12Gfx.Wand, x, y)
		instantAction = True
	End Method

	Method DoAction:Bool()
		QueueAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.goody)
		player.nextState = STATE_WIN
		Return True
	End Method
End Class




Class Room
	Field x:Int
	Field y:Int
	Field sizeX:Int
	Field sizeY:Int
	
	Method New(x:Int=1, y:Int=1, sizeX:Int=1, sizeY:Int=1)
		Self.x = x
		Self.y = y
		Self.sizeX = sizeX
		Self.sizeY = sizeY
	End Method
End Class

Class Level
	Field depth:Int
	Field width:Int
	Field height:Int
	Field wall:GameImage
	Field tiles:Tile[][]
	Field entities:List<Entity> = New List<Entity>
	Field items:List<Item> = New List<Item>
	Field rooms:List<Room> = New List<Room>
	
	
	Method New(depth:Int=1, width:Int=MAPX, height:Int=MAPY)
		Self.depth = depth
		Self.width = width
		Self.height = height
		
		' Construct The 2D array and instantiate each tile
		tiles = New Tile[width][]
		For Local x:Int = 0 Until width
			tiles[x] = New Tile[height]
		Next
	End Method
	
	Method Render:Void()
		RenderMap()

		For Local item:Item = EachIn items
			item.Render()
		Next
		For Local entity:Entity = EachIn entities
			entity.Render()
		Next
		player.Render()

		' Render any special effects here
		If currAnim Then currAnim.Render()
		
		If player.combatAnim
			player.combatAnim.Render()
			If player.hitAnim Then player.hitAnim.Render()
			
		EndIf
		If player.attacker
			If player.attacker.combatAnim
				player.attacker.combatAnim.Render()
			EndIf
			If player.attacker.hitAnim Then player.attacker.hitAnim.Render()
		EndIf
	End Method

	Method RenderMap:Void()
		' Since graphics are centered with mid-handle, need to translate display
		PushMatrix()
		Translate TILE_SIZE / 2, TILE_SIZE / 2
		For Local x:Int = 0 Until width
			For Local y:Int = 0 Until height
				If tiles[x][y].visible = False
					Game12Gfx.Hidden.Draw(x*TILE_SIZE,y*TILE_SIZE)
				Else
					Select tiles[x][y].type
						Case TILE_WALL ; Game12Gfx.Wall.Draw(x*TILE_SIZE,y*TILE_SIZE)
						Case TILE_FLOOR ; Game12Gfx.Floor.Draw(x*TILE_SIZE,y*TILE_SIZE)
					End Select
				EndIf
			Next
		Next
		PopMatrix()
	End Method

	Method PlacePlayerStart:Void(onEmpty:Bool = False)
		Local stairs:Item
		Local x:Int, y:Int
		Local found:Bool = False
		
		' If on first level then there is no Up Stairs, so place player on empty space
		' Also place player on empty space if they fell through a PIT
		If onEmpty = True
			repeat
				x = Rnd(MAPX-1) + 1
				y = Rnd(MAPY-1) + 1
				found = TileIsEmpty(x, y)
			Until found = True
			player.MoveTo(x, y, True)
		Else
			' Place player on meaningful stairs
			If levelDepth > lastLevelDepth + 1
				stairs = Null
			ElseIf levelDepth > lastLevelDepth
				stairs = FindItemByType(ITEM_USTAIR)
			ElseIf levelDepth < lastLevelDepth
				stairs = FindItemByType(ITEM_DSTAIR)
			Else
				stairs = Null
			EndIf
			' If can't find stairs for some reason just find empty space
			If stairs = Null
				PlacePlayerStart(True)
			Else
				player.MoveTo(stairs.x, stairs.y, True)
				stairs.seenYet = True
			EndIf
		EndIf
	End Method
	
	Method FindItemByType:Item(type:Int)
		For Local item:Item = EachIn items
			If item.type = type Then Return item
		Next
		Return Null
	End Method

	Method FindItemByLocation:Item(x:Int,y:Int)
		For Local item:Item = EachIn items
			If item.x = x And item.y = y Then Return item
		Next
		Return Null
	End Method

	Method RemoveItemByLocation:Void(x:Int,y:Int)
		For Local item:Item = EachIn items
			If item.x = x And item.y = y Then items.Remove(item)
		Next
	End Method

	Method RemoveItem:Void(item:Item)
		items.Remove(item)
	End Method

			
	Method GenerateLevel:Void()
		Local numGold:Int = Rnd(3)+2
		Local numItems:Int = Rnd(3)+2
		Local numMonsters:Int = Rnd(3)+2

		' Build rooms and hallways
		InitializeTiles()
		BuildRooms()
		CarveTunnels()

		If levelDepth > 1 Then PlaceItem(ITEM_USTAIR)
		If levelDepth < 20 Then PlaceItem(ITEM_DSTAIR)
		' Guaranteed Temple on each level
		PlaceItem(ITEM_TEMPLE)

		' Put in goodies
		For Local gold:Int = 1 To numGold
			PlaceItem(ITEM_GOLD)
		Next
		
		Repeat
			Local item:Int
			item = GetRandomItem()
			' Special rules here
			If item = ITEM_PIT And levelDepth > 15 Then Continue
			If item = ITEM_SWORD And player.weaponPower >= levelDepth Then Continue
			If item = ITEM_SHIELD And player.armorPower >= levelDepth Then Continue
			If item = ITEM_UNKNOWN Then Continue
			PlaceItem(item)
			numItems -= 1
		Until numItems = 0
		
		' Put in monsters
		Repeat
			Local mon:Monster
			Local x:Int, y:Int
			Local found:Bool = False
			mon = MakeMonster(levelDepth)
			' Find empty space
			repeat
				x = Rnd(MAPX-1) + 1
				y = Rnd(MAPY-1) + 1
				found = TileIsEmpty(x, y)
			Until found = True
			mon.x = x
			mon.y = y
			entities.AddLast(mon)
			numMonsters -= 1
		Until numMonsters = 0
				
		' If depth low enough, include Generators (?)
		
		' If depth is level 20, include the Wand!
		If levelDepth = 20 Then PlaceItem(ITEM_WAND)
		
	End Method

	
	Method GetRandomItem:Int()
		Local rand:Int = Rnd(16)+1
		
		Select rand
			Case 1,2 ; Return ITEM_HEAL
			Case 3,4 ; Return ITEM_SWORD
			Case 5,6 ; Return ITEM_SHIELD
			Case 7,8 ; Return ITEM_GOLDBAR
			Case 9 ; Return ITEM_FOOD
			Case 10 ; Return ITEM_SHOVEL
			Case 11 ; Return ITEM_EXPLOSION
			Case 12 ; Return ITEM_POISON
			Case 13 ; Return ITEM_BOLT
			Case 14 ; Return ITEM_PUNJI
			Case 15 ; Return ITEM_PIT
			Case 16 ; Return ITEM_FIREBALL
			Default ; Return ITEM_UNKNOWN
		End Select
		
	End Method
	
	Method InitializeTiles:Void()
		' Initialize the level tiles to be solid walls and not visible
		For Local x:Int = 0 Until width
			For Local y:Int = 0 Until height
				tiles[x][y] = New Tile
				tiles[x][y].blockable = True
				tiles[x][y].visible = False
				tiles[x][y].type = TILE_WALL
			Next
		Next
	End Method
	
	Method BuildRooms:Void()
		Local numRooms:Int = 7
		Local numTries:Int = 300
		Local x:Int, y:Int, sizeX:Int, sizeY:Int
		Local padRooms:Bool = True
		' Build rooms and hallways
		
		' Keep trying to fit a room until all the rooms are done or we run out of tries
		Repeat
			x = Int(Rnd(1,MAPX-5))
			y = Int(Rnd(1,MAPY-5))
			sizeX = Int(Rnd(1,4))+2		' Range is 3-5
			sizeY = Int(Rnd(1,4))+2		' Range is 3-5
			if x + sizeX > MAPX-1 Then sizeX = MAPX-1 - x
			if y + sizeY > MAPY-1 Then sizeY = MAPY-1 - y
			if CanMakeRoom(x, y, sizeX, sizeY, padRooms) = True
				AddRoom(x, y, sizeX, sizeY)
				numRooms -= 1
			Else
				numTries -= 1
			EndIf
			' If we are running out of tries, do not be so picky about separate rooms
			if numTries < 100 Then padRooms = False
		Until numTries = 0 Or numRooms = 0
	End Method

	Method AddRoom:Void(startX:Int, startY:Int, sizeX:Int, sizeY:Int)
		Local newRoom:Room = new Room(startX, startY, sizeX, sizeY)
		rooms.AddLast(newRoom)
		CarveRoom(startX, startY, sizeX, sizeY)
	End Method
	
	Method CarveRoom:Void(startX:Int, startY:Int, sizeX:Int, sizeY:Int)
		Local endX:Int = startX + sizeX - 1	
		Local endY:Int = startY + sizeY - 1	
	
		For Local x:Int = startX To endX
			For Local y:Int = startY To endY
				tiles[x][y].blockable = False
				tiles[x][y].type = TILE_FLOOR
			Next
		Next
	End Method
	
	Method CanMakeRoom:Bool(startX:Int, startY:Int, sizeX:Int, sizeY:Int, pad:Bool)
		Local endX:Int = startX + sizeX - 1	
		Local endY:Int = startY + sizeY - 1	
	
		If pad = True
			startX -= 1
			startY -= 1
			endX += 1
			endY += 1
		EndIf
		For Local x:Int = startX To endX
			For Local y:Int = startY To endY
				If tiles[x][y].type = TILE_FLOOR Then Return False
			Next
		Next
		Return True
	End Method

	Method CarveTunnels:Void()
		Local x:Int
		Local y:Int
		Local dir:Int
		Local foundSpace:Bool
		Local room:Room
		
		For Local room:Room = EachIn rooms
			' Depending on position in map, direct intiial tunnel position toward center for better connections
			' Favor the East/West directions more by choosing them last.  There can still be islands of rooms left.
			dir = DIR_NONE
			If room.y < MAPY * 0.20 Then dir = DIR_SOUTH
			If room.y + room.sizeY > MAPY * 0.80 Then dir = DIR_NORTH
			If room.x < MAPX * 0.20 Then dir = DIR_EAST
			If room.x + room.sizeX > MAPX * 0.80 Then dir = DIR_WEST
			' If still don't know a direction, pick a random one
			If dir = DIR_NONE
				Local rand:Int = Rnd(100)
				dir = DIR_NORTH
				If rand < 25 Then dir = DIR_EAST
				If rand < 50 Then dir = DIR_SOUTH
				If rand < 75 Then dir = DIR_WEST
			EndIf
			
			' Start tunnel on edge of room based on direction
			Select dir
				Case DIR_EAST
					x = room.x + room.sizeX
					y = room.y + Rnd(room.sizeY-1)
				Case DIR_WEST
					x = room.x - 1 
					y = room.y + Rnd(room.sizeY-1)
				Case DIR_SOUTH
					y = room.y + room.sizeY
					x = room.x + Rnd(room.sizeX-1)
				Case DIR_NORTH
					y = room.y - 1
					x = room.x + Rnd(room.sizeX-1)
			End Select

			' Begin to DIG !			
			foundSpace = False
			Repeat
				' Set the current tile to a Floor type (may already be floor if just turned)
				tiles[x][y].type = TILE_FLOOR
				tiles[x][y].blockable = False
				' Move direction if needed, turning to the right or left when hitting edge
				'Local tempDir:Int
				Local origDir:Int = dir		' Used to dtermine if still in "turning phase"
				Select dir
					Case DIR_EAST
						If x+1 > MAPX-2
							If y < MAPY/2 Then dir = DIR_SOUTH Else dir = DIR_NORTH
						EndIf
					Case DIR_WEST
						If x-1 < 1
							If y < MAPY/2 Then dir = DIR_SOUTH Else dir = DIR_NORTH
						EndIF
					Case DIR_SOUTH
						If y+1 > MAPY-2
							If x < MAPX/2 Then dir = DIR_EAST Else dir = DIR_WEST
						EndIf
					Case DIR_NORTH
						If y-1 < 1
							If x < MAPX/2 Then dir = DIR_EAST Else dir = DIR_WEST
						EndIf
				End Select
				' Check forward and sides in proper direction to see if there is a space
				' If we changed directions, ignore the sides for this iteration
				Select dir
					Case DIR_EAST
						If tiles[x+1][y].blockable = False
							foundSpace = True
						ElseIf origDir = dir And (tiles[x][y-1].blockable = False Or tiles[x][y+1].blockable = False)
							foundSpace = True
						EndIf
					Case DIR_WEST
						If tiles[x-1][y].blockable = False
							foundSpace = True
						ElseIf origDir = dir And (tiles[x][y-1].blockable = False Or tiles[x][y+1].blockable = False)
							foundSpace = True
						EndIf
					Case DIR_NORTH
						If tiles[x][y-1].blockable = False
							foundSpace = True
						ElseIf origDir = dir And (tiles[x-1][y].blockable = False Or tiles[x+1][y].blockable = False)
							foundSpace = True
						EndIf
					Case DIR_SOUTH
						If tiles[x][y+1].blockable = False
							foundSpace = True
						ElseIf origDir = dir And (tiles[x-1][y].blockable = False Or tiles[x+1][y].blockable = False)
							foundSpace = True
						EndIf
				End Select
				if foundSpace = False
					Select dir
						Case DIR_EAST ; x += 1
						Case DIR_WEST ; x -= 1
						Case DIR_SOUTH ; y += 1
						Case DIR_NORTH ; y -= 1
					End Select
				EndIf
			Until foundSpace = True
		Next
	End Method

	Method ShowSquare:Void(midX:Int, midY:Int)
		For Local x:Int = midX - 1 To midX + 1
			For Local y:Int = midY - 1 To midY + 1
				tiles[x][y].visible = True
			Next
		Next
	End Method
	
	Method TileIsEmpty:Bool(x:Int, y:Int, ignoreItems:Bool = False)
		If tiles[x][y].type <> TILE_FLOOR Then Return False
		
		If ignoreItems = False
			For Local item:Item = EachIn items
				If item.x = x And item.y = y Then Return False
			Next
		EndIf
		
		For Local entity:Entity = EachIn entities
			If entity.x = x And entity.y = y Then Return False
		Next
		Return True
	End Method
		
	Method PlaceItem:Void(itemType:Int)
		Local x:Int, y:Int
		Local found:Bool
		Local newItem:Item
		' Find empty space
		repeat
			x = Rnd(MAPX-1) + 1
			y = Rnd(MAPY-1) + 1
			found = TileIsEmpty(x, y)
		Until found = True

		Select itemType
			Case ITEM_USTAIR ; newItem = New UpStairs(x, y)
			Case ITEM_DSTAIR ; newItem = New DownStairs(x, y)
			Case ITEM_GOLD ; newItem = New GoldBag(x, y)
			Case ITEM_TEMPLE ; newItem = New Temple(x, y)
			Case ITEM_HEAL ; newItem = New Heal(x, y)
			Case ITEM_SWORD ; newItem = New Sword(x, y)
			Case ITEM_SHIELD ; newItem = New Shield(x, y)
			Case ITEM_GOLDBAR ; newItem = New GoldBar(x, y)
			Case ITEM_FOOD ; newItem = New Food(x, y)
			Case ITEM_SHOVEL ; newItem = New Shovel(x, y)
			Case ITEM_WAND ; newItem = New Wand(x, y)
			Case ITEM_FIREBALL ; newItem = New Fireball(x, y)
			Case ITEM_PIT ; newItem = New Pit(x, y)
			Case ITEM_BOLT ; newItem = New Bolt(x, y)
			Case ITEM_EXPLOSION ; newItem = New Explosion(x, y)
			Case ITEM_PUNJI ; newItem = New Punji(x, y)
			Case ITEM_POISON ; newItem = New Poison(x, y)
		End Select
		
		If newItem Then items.AddLast(newItem)
	End Method

	Method FindEntityByLocation:Entity(x:Int,y:Int)
		For Local entity:Entity= EachIn entities
			If entity.x = x And entity.y = y Then Return entity
		Next
		Return Null
	End Method

	Method RemoveEntity:Void(entity:Entity)
		entities.Remove(entity)
	End Method

	Method UpdateEntities:Void()
		For Local entity:Entity = EachIn entities
			entity.Update()
		Next
	End Method

	Method ResetEntityTimers:Void()
		For Local entity:Entity = EachIn entities
			entity.ResetTimer()
		Next
	End Method

End Class

Class Entity
	Field image:GameImage	' image of this entity
	Field x:Int				' X coordinate on map
	Field y:Int				' Y coordinate on map
	Field name:String		' Name of this object
	Field level:Int			' Entity experience level
	Field hitPoints:Int		' Hitpoints
	Field hitPointsMax:Int	' Maximum Hitpoints
	Field healRate:Int		' Heal rate divisor (higher means less-often)
	Field alive:Bool		' Is it alive or dead?
	Field battleSkill:Float	' Battle skill = combat bonus (improves with more kills)
	Field weaponPower:Float	' Weapon power = Raw damage
	Field armorPower:Float	' Armor power = Raw defense
	Field experience:Int	' How much experience you have
	Field lastTime:Int		' Timer
	Field currTime:Int		' Current timer for this entity
	Field nextMoveTime:Int	' Minimum time allowed for next move
	Field nextHealTime:Int  ' Minimum time allowed for healing to occur
	Field nextCombatTime:Int	' Minimum time allowed for next move
	Field combatAnim:Anim   ' Animation for moving itself and presenting a scaled sprite 
	Field noMove:Bool       ' Will entity be able to move ?
	Field tryHeal:Bool		' Entity tries to heal during combat (replaces attack round)
	Field healPotions:Int	' Number of health potions / spells entity has
	Field trySmash:Bool		' Entity tries to smash attacker during combat (extra bonus)
	Field superSmashes:Int  ' Number of super smashes left
	Field moveDirX:Int		' Direction of movement to attempt in X axis
	Field moveDirY:Int		' Direction of movement to attempt in Y axis
	Field attacker:Entity	' Who is attacking me ?
	Field hitAnim:Anim		' Hit or Miss image displaying in combat

	Method Render:Void()
		' If can't see them, don't draw them!
		If currLevel.tiles[x][y].visible = False Then Return
		
		' If in combat, do not render image
		If attacker Then Return
		
		' Since graphics are centered with mid-handle, need to translate display
		PushMatrix()
		Translate TILE_SIZE / 2, TILE_SIZE / 2

		If alive
			' Draw a floor under the entity 
			Game12Gfx.Floor.Draw(x*TILE_SIZE, y*TILE_SIZE)
			image.Draw(x*TILE_SIZE, y*TILE_SIZE)
		Else
			' Draw a pile of bones
		EndIf
		PopMatrix()
	End Method

	Method MoveTo:Void(x:Int, y:Int, suppressAction:Bool=False)
		Self.x = x
		Self.y = y
	End Method

	Method TryMove:Bool(dir:Int,noEntity:Bool=False)
		Local tempMoveDirX:Int = 0
		Local tempMoveDirY:Int = 0

		' If it is not time yet to move... exit out
		If currTime < nextMoveTime Then Return False
		'If inCombat = True And GetAwayFailed() Then Return

		Select dir
			Case DIR_NORTHEAST
				If currLevel.tiles[x+1][y-1].blockable = False
					tempMoveDirX = +1
					tempMoveDirY = -1
				EndIf
			Case DIR_SOUTHEAST
				If currLevel.tiles[x+1][y+1].blockable = False
					tempMoveDirX = +1
					tempMoveDirY = +1
				EndIf
			Case DIR_SOUTHWEST
				If currLevel.tiles[x-1][y+1].blockable = False
					tempMoveDirX = -1
					tempMoveDirY = +1
				EndIf
			Case DIR_NORTHWEST
				If currLevel.tiles[x-1][y-1].blockable = False
					tempMoveDirX = -1
					tempMoveDirY = -1
				EndIf
			Case DIR_NORTH
				If currLevel.tiles[x][y-1].blockable = False Then tempMoveDirY = -1
			Case DIR_SOUTH
				If currLevel.tiles[x][y+1].blockable = False Then tempMoveDirY = +1
			Case DIR_EAST
				If currLevel.tiles[x+1][y].blockable = False Then tempMoveDirX = +1
			Case DIR_WEST
				If currLevel.tiles[x-1][y].blockable = False Then tempMoveDirX = -1
		End Select

		If tempMoveDirX <> 0 Or tempMoveDirY <> 0
			' If cannot have entity on square, check this now and do not allow move if true
			If noEntity And currLevel.TileIsEmpty(x + tempMoveDirX, y + tempMoveDirY, True) = False Then Return False

			moveDirX = tempMoveDirX
			moveDirY = tempMoveDirY
			Return True
		EndIf
		Return False
	End Method
	
	Method Update:Void()
		' Update the timers
		currTime += Millisecs() - lastTime
		lastTime = Millisecs()
		
		If moveDirX <> 0 Or moveDirY <> 0
			' Need to add in possibility of moving (running away) chance in Combat
			If attacker = Null
				MoveTo(x + moveDirX, y + moveDirY)
				' Reset the movement flags
				moveDirX = 0
				moveDirY = 0
			EndIf
		EndIf

		If currTime > nextHealTime And (player.state = STATE_ACTIVE) Then Heal()
		
	End Method

	Method ResetTimer:Void()
		lastTime = Millisecs()
	End Method
	
	Method Heal:Void()
		Local temple:Item
		Local amt:Int = (hitPointsMax - hitPoints) / healRate + 1
		
		temple = currLevel.FindItemByType(ITEM_TEMPLE)
		If temple
			If temple.x = x And temple.y = y Then amt *= 3
		EndIF
		
		hitPoints += amt
		If hitPoints > hitPointsMax Then hitPoints = hitPointsMax
		If hitPoints < 10 And (10000 / amt) > 3000
			nextHealTime = currTime + 3000
		Else
			nextHealTime = currTime + (10000 / amt)
		EndIf
	End Method

	Method Heal:Void(amt:Int)
		hitPoints += amt
		If hitPoints > hitPointsMax Then hitPoints = hitPointsMax
	End Method
	
	Method UpdateCombat:Void()
		Local amt:Int	' Amount of damage attempted
		Local ran:Int   ' Random value
		
		' Combat animations take precedence over activity
		If hitAnim
			If hitAnim.Done()
				hitAnim = Null
			Else
				hitAnim.Update()
			EndIf
			Return
		EndIf
		
		If attacker = Null Then	Return
		If alive = False Then Return
		If currTime <= nextCombatTime Then Return
	
		nextCombatTime += COMBAT_SPEED
		
		' Just in case, nil out the animation for this entity when it is their turn to attack
		hitAnim = Null
		
		
		If tryHeal
			If healPotions > 0 And hitPoints < hitPointsMax
				Heal(hitPointsMax / 2)
				healPotions -= 1
			EndIf
			tryHeal = False
			Return
		EndIf

		If trySmash
			If superSmashes > 0
				attacker.hitAnim = MakeAnimation(Game12Gfx.SmashSplat, attacker.combatAnim.x, attacker.combatAnim.y, attacker.combatAnim.x, attacker.combatAnim.y, ANIM_SIZE, ANIM_SIZE, True, True, Game12Snd.smash)
				attacker.Damage(level * 5)
				superSmashes -= 1
			EndIf
			trySmash = False
			Return
		EndIf
		
		Local bs1:Float, bs2:Float
		bs1 = Rnd(battleSkill)
		bs2 = Rnd(attacker.battleSkill / 2)

		ran = Rnd(3) + 1
		Local hitSnd:GameSound
		Local missSnd:GameSound
		Select ran
			Case 1; missSnd = Game12Snd.miss1
			Case 2; missSnd = Game12Snd.miss2
			Default; missSnd = Game12Snd.miss3
		End Select
		ran = Rnd(4) + 1
		Select ran
			Case 1; hitSnd = Game12Snd.hit1
			Case 2; hitSnd = Game12Snd.hit2
			Case 3; hitSnd = Game12Snd.hit3
			Default; hitSnd = Game12Snd.hit4
		End Select
						
		' Match up battle skill to see if successful hit or not
		If bs1 < bs2
			attacker.hitAnim = MakeAnimation(Game12Gfx.Miss, attacker.combatAnim.x, attacker.combatAnim.y, attacker.combatAnim.x, attacker.combatAnim.y, ANIM_SIZE, ANIM_SIZE, True, True, missSnd)
			Return
		EndIf
		
		amt = COMBAT_BASE_ATTACK + Rnd(level / 2) + Rnd(weaponPower) + 1 + (superSmashes / 2)
		
		If attacker.Damage(amt) > 0
			attacker.hitAnim = MakeAnimation(Game12Gfx.Splat, attacker.combatAnim.x, attacker.combatAnim.y, attacker.combatAnim.x, attacker.combatAnim.y, ANIM_SIZE, ANIM_SIZE, True, True, hitSnd)
		Else
			attacker.hitAnim = MakeAnimation(Game12Gfx.Miss, attacker.combatAnim.x, attacker.combatAnim.y, attacker.combatAnim.x, attacker.combatAnim.y, ANIM_SIZE, ANIM_SIZE, True, True, missSnd)
		EndIf
	End Method
	
	Method Damage:Int(amt:Int)
		Return amt
	End Method
	
End Class

' Player states, drives a lot of the logic for Update() and timing for game
Const STATE_NONE:Int = 0		' No state
Const STATE_START:Int = 1		' Player starting out 
Const STATE_ACTIVE:Int = 2		' Player active (can move about, game timer running)
Const STATE_INACTIVE:Int = 3	' Player inactive (cannot move, game timer stops)
Const STATE_ANIM:Int = 4		' Player is viewing an animation (picked up item, etc.)
Const STATE_COMBAT:Int  = 5		' Player is in Combat
Const STATE_COMBAT_ANIM:Int = 6 ' Player doing Combat animation (zooming in player and attacker)
Const STATE_COMBAT_END:Int = 7  ' Player ending Combat animation (zooming out player)
Const STATE_COMBAT_START:Int = 8  ' Player starting combat
Const STATE_FALLING:Int = 9		' Player is falling down pit
Const STATE_DEAD:Int = 10		' Player is dead !!
Const STATE_DIGGING:Int = 11    ' Player is digging down
Const STATE_WIN:Int = 12 		' Won the game !!!

Class Player Extends Entity
	Field gold:Int
	Field killPoints:Float		' Tally of monster level kills
	Field state:Int				' Player state, it drives a lot of actions in the level
	Field nextState:Int			' If player has multiple actions, this will be the "next state" to go into
	Field score:Int				' Player score for the game
	Field firstHit:Bool			' Whether player gets to have first strike or not in combat
	Field shovels:Int			' Number of shovels player has
	
	Method New()
		Local modifier:Int = Rnd(6)
		name = "You"
		level = 1
		experience = 0
		hitPointsMax = 5 + modifier
		hitPoints = hitPointsMax
		alive = True
		battleSkill = 10.0 - modifier
		weaponPower = 1
		armorPower = 1
		healPotions = 2
		shovels = 1
		superSmashes = 1
		image = Game12Gfx.Player
		killPoints= 0
		gold = 0
		healRate = PLYR_HEAL_RATE
		state = STATE_START
		nextState = STATE_NONE
		ResetTimer()
	End Method

	Method MoveTo:Void(x:Int, y:Int, suppressAction:Bool=False)
		nextMoveTime = currTime + 250
		Super.MoveTo(x, y)
		currLevel.ShowSquare(x, y)
		
		If suppressAction = False
			Local monster:Entity
			Local item:Item
			
			monster = currLevel.FindEntityByLocation(x, y)
			If monster
				player.BeginCombat(monster, True)
				Return
			EndIf

			' See if we landed on something good
			item = currLevel.FindItemByLocation(x, y)
			If item
				If item.unknown Then item.unknown = False
				' If instant action, do it now!
				If item.instantAction
					player.ActivateItem(item)
				Else
					player.ShowNewItem(item)
				EndIf
			EndIf
		EndIf
	End Method

	Method Render:Void()
		If player.attacker = Null
			' List the states of the player where they should not be displayed
			Select player.state
				Case STATE_ANIM
				Case STATE_DEAD
				Default; Super.Render()
			End Select
		EndIf

		RenderHUD()
	End Method

	Method RenderHUD:Void()
		Local x:Int, y:Int
		' Since graphics are centered with mid-handle, need to translate display
		PushMatrix()
		Translate TILE_SIZE / 2, TILE_SIZE / 2
	
		' For player we redisplay the HUD
		' The icons are always 2 spaces to the right of the map dimensions
		x = (MAPX + 1) * TILE_SIZE
		y = 0
		Game12Gfx.StairsDown.Draw(x, y)
		font20.DrawText(String(levelDepth), x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		y += TILE_SIZE
		Game12Gfx.Crown.Draw(x, y)
		font20.DrawText(String(level), x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		y += TILE_SIZE
		Game12Gfx.Heart.Draw(x, y)
		If hitPoints > 99
			font20.DrawText("++", x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		Else
			font20.DrawText(String(hitPoints), x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		EndIf
		
		y += TILE_SIZE
		Game12Gfx.Gold.Draw(x, y)
		If gold > 99
			font20.DrawText("++", x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		Else
			font20.DrawText(String(gold), x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		EndIf
		y += TILE_SIZE
		Game12Gfx.Sword.Draw(x, y)
		font20.DrawText(String(weaponPower), x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		y += TILE_SIZE
		Game12Gfx.Shield.Draw(x, y)
		font20.DrawText(String(armorPower), x - TILE_SIZE, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		PopMatrix()

		PushMatrix()
		Translate TILE_SIZE, TILE_SIZE
		x = (MAPX) * TILE_SIZE
		y = (MAPY-2) * TILE_SIZE
		Game12Gfx.ExitButton.Draw(x, y)
		y -= TILE_SIZE * 2
		Game12Gfx.DigButton.Draw(x, y)
		font20.DrawText(String(player.shovels), x, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		y -= TILE_SIZE * 2
		Game12Gfx.HealButton.Draw(x, y)
		font20.DrawText(String(player.healPotions), x, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		y -= TILE_SIZE * 2
		Game12Gfx.SmashButton.Draw(x, y)
		font20.DrawText(String(player.superSmashes), x, y - (TILE_SIZE / 3), eDrawAlign.CENTER)
		PopMatrix()

	End Method
		
	Method Update:Void()
		Local canMove:Bool = False
	
		If (KeyDown(KEY_UP) And KeyDown(KEY_RIGHT)) Or ClickRelativeDir(DIR_NORTHEAST)
			canMove = TryMove(DIR_NORTHEAST)
		ElseIf (KeyDown(KEY_RIGHT) And KeyDown(KEY_DOWN)) Or ClickRelativeDir(DIR_SOUTHEAST)
			canMove = TryMove(DIR_SOUTHEAST)
		ElseIf (KeyDown(KEY_LEFT) And KeyDown(KEY_DOWN)) Or ClickRelativeDir(DIR_SOUTHWEST)
			canMove = TryMove(DIR_SOUTHWEST)
		ElseIf (KeyDown(KEY_UP) And KeyDown(KEY_LEFT)) Or ClickRelativeDir(DIR_NORTHWEST)
			canMove = TryMove(DIR_NORTHWEST)
		EndIf
		If canMove = False
			If KeyDown(KEY_UP) Or ClickRelativeDir(DIR_NORTH) Then canMove = TryMove(DIR_NORTH)
			If KeyDown(KEY_DOWN) Or ClickRelativeDir(DIR_SOUTH) And canMove = False Then canMove = TryMove(DIR_SOUTH)
			If KeyDown(KEY_RIGHT) Or ClickRelativeDir(DIR_EAST) And canMove = False Then canMove = TryMove(DIR_EAST)
			If KeyDown(KEY_LEFT) Or ClickRelativeDir(DIR_WEST) And canMove = False Then canMove = TryMove(DIR_WEST)
		EndIf

		If KeyDown(KEY_H) Then TryHealPotion()

		If KeyDown(KEY_D) Then TryDig()
		
		
		Super.Update()
		
	End Method
	
	Method ClickRelativeDir:Bool(dir:Int, checkMouse:Bool = True)
		' Determine which "cell" the mouse is on
		Local mX:Int, mY:Int
		mX = Int(diddyGame.mouseX / TILE_SIZE)
		mY = Int(diddyGame.mouseY / TILE_SIZE)
		
		' If not within the bounds of the playing field (actual level) return false
		If mX >= MAPX Or mY >= MAPY Then Return False
		
		If MouseDown() Or checkMouse = False
			Select dir
				Case DIR_NORTHEAST
					If player.x < mX And player.y > mY Then Return True
				Case DIR_EAST
					If player.x < mX Then Return True
				Case DIR_SOUTHEAST
					If player.x < mX And player.y < mY Then Return True
				Case DIR_SOUTH
					If player.y < mY Then Return True
				Case DIR_SOUTHWEST
					If player.x > mX And player.y < mY Then Return True
				Case DIR_WEST
					If player.x > mX Then Return True
				Case DIR_NORTHWEST
					If player.x > mX And player.y > mY Then Return True
				Case DIR_NORTH
					If player.y > mY Then Return True
				Case DIR_NONE
					If player.x = mX And player.y = mY Then Return True
			End Select
		EndIf
		Return False
	End Method

	Method CheckButtonClick:Void()

			' Determine which "cell" the mouse is on
		Local mX:Int, mY:Int
		mX = Int(diddyGame.mouseX / TILE_SIZE)
		mY = Int(diddyGame.mouseY / TILE_SIZE)

		' If not within the bounds of the button area  return false
		If mX < MAPX Then Return
		If mX > MAPX + 2 Then Return
		If mY > MAPY Then Return
		If MouseHit()
			If mY > MAPY - 3
				' Clicked Exit
				player.state = STATE_INACTIVE
				Game12PlayScr.FadeToScreen(Game12Scr)
			ElseIf mY > MAPY - 5
				player.TryDig()
			ElseIf mY > MAPY - 7
				'Clicked Heal
				player.TryHealPotion()
			ElseIf mY > MAPY - 9
				'Clicked Smash (special attack)
				player.TrySmashAttack()
			EndIf
		EndIf
	End Method
	
	Method ActivateItem:Void(item:Item)
		If item = Null Then Return
		If item.DoAction() = True
			currLevel.RemoveItemByLocation(x, y)
		EndIf
		item.seenYet = True
	End Method

	Method ShowNewItem:Void(item:Item)
		If item.seenYet = False
			QueueAnimation(item.image, item.x * TILE_SIZE + (TILE_SIZE / 2), item.y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, item.snd)
			item.seenYet = True
		EndIf
	End Method

	Method TryDig:Void()
		If state = STATE_ACTIVE
			' Clicked shovel
			If shovels > 0 And levelDepth < 19
				nextLevelDepth += 1
				state = STATE_DIGGING
				Game12Snd.godown.Play(1)
				Game12PlayScr.FadeToScreen(Game12TransScr)
				shovels -= 1
			EndIf
		EndIf
	End Method
	
	Method TryHealPotion:Void()
		Select state
			Case STATE_ACTIVE
				If healPotions > 0 And hitPoints < hitPointsMax
					QueueAnimation(Game12Gfx.Heart, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.heal)
					Heal(hitPointsMax / 2)
					healPotions -= 1
				EndIf
			Case STATE_COMBAT
				' This will be processed in UpdateCombat() method
				tryHeal = True
		End Select
	End Method
	
	Method TrySmashAttack:Void()
		Select state
			Case STATE_COMBAT
				' This will be processed in UpdateCombat() method
				trySmash = True
		End Select
	
	
	End Method
	Method AddGold:Void(amt:Int)
		gold += amt
		If gold > 999 Then gold = 999
	End Method

	Method EmptyGold:Void()
		gold = 0
	End Method
	
	Method AddExp:Void(amt:Int)
		experience += amt
		If experience >= (level * LEV_EXP) Then LevelUp()
	End Method
	
	Method LevelUp:Void()
		Local modifier:Int
		' Your battle skill is raised by the number of enemies you killed (cumulative levels) and your own level
		battleSkill += killPoints / level
	    killPoints = 0
		experience -= (level * LEV_EXP)
		level += 1
		modifier = level + Rnd(level)
		If modifier < 5 Then modifier = 5
		hitPointsMax += modifier
		If hitPointsMax > 999 Then hitPointsMax = 999
		hitPoints = hitPointsMax
		' Add another super smash to the player!
		superSmashes += 1
		QueueAnimation(Game12Gfx.Crown, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE,,, Game12Snd.levelup)
	End Method

	Method BeginCombat:Void(monster:Entity, firstHit:Bool)
		Self.firstHit = firstHit
		attacker = monster
		monster.attacker = Self
		state = STATE_COMBAT_ANIM
		' Determine how initial animation will go
		Local targX:Float = x+1.5 	' Target X for animation (player move little to the right if can)
		Local targY:Float = y		' Target Y for animation to go
		
		' Player always goes to the right of the monster
		targX = Max(ANIM_SIZE + (ANIM_SIZE/2), targX)
		targX = Min(MAPX-(ANIM_SIZE/2), targX)
		targY = Max(ANIM_SIZE/2, targY)
		targY = Min(MAPY-(ANIM_SIZE/2), targY)
		combatAnim = MakeAnimation(image, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), targX * TILE_SIZE + (TILE_SIZE / 2), targY * TILE_SIZE + (TILE_SIZE / 2), 1.0, ANIM_SIZE, True, False, Game12Snd.combat)
		targX -= ANIM_SIZE
		attacker.combatAnim = MakeAnimation(attacker.image, monster.x * TILE_SIZE + (TILE_SIZE / 2), monster.y * TILE_SIZE + (TILE_SIZE / 2), targX * TILE_SIZE + (TILE_SIZE / 2), targY * TILE_SIZE + (TILE_SIZE / 2), 1.0, ANIM_SIZE, True)
	End Method
	
	Method EndCombat:Void()
		nextCombatTime = 0
		attacker.nextCombatTime = 0
		firstHit = False
		' Player made the killing blow!
		If attacker.alive = False
			state = STATE_ACTIVE
			killPoints += attacker.level
			AddExp(attacker.experience)
		EndIf
		currLevel.RemoveEntity(attacker)
		player.combatAnim = Null
		player.hitAnim = Null
		attacker.combatAnim = Null
		attacker.hitAnim = Null
		attacker = Null
	End Method
	
	Method Damage:Int(amt:Int)
		amt -= Rnd(armorPower)
		If amt <= 0 Then Return 0
		
		hitPoints -= amt
		If hitPoints < 1
			If attacker
				' Skull animation will display after STATE_COMBAT_END
				state = STATE_COMBAT_END
				nextState = STATE_DEAD
			Else
				QueueAnimation(Game12Gfx.Skull, x * TILE_SIZE + (TILE_SIZE / 2), y * TILE_SIZE + (TILE_SIZE / 2), 0, 0, 1.0, ANIM_SIZE)
				nextState = STATE_DEAD
			EndIf
			alive = False
		EndIf
		Return amt
	End Method
	
End Class

Class Monster Extends Entity

	Method New(lev:Int=1, name:String, image:GameImage, noMove:Bool = False)
		' The level of the monster is the floor level / 2
		level = lev / 2 + 1
		Self.name = name
		Self.image = image
		Self.noMove = noMove
		alive = True
		battleSkill = level * MONS_BATTLESKILL
		weaponPower = level / 3 + 1
		armorPower = level / 3
		experience = level * MONS_EXP
		hitPointsMax = level * MONS_HITPOINTS
		hitPoints = hitPointsMax
		healRate = MONS_HEAL_RATE
		ResetTimer()
		If noMove
			' Some monsters will not move at all
			nextMoveTime = currTime - 10000
		Else
			' Let monsters not move for around 6 seconds after creation
			nextMoveTime = currTime + 5000 + Rnd(2000)
		EndIf
	End Method

	Method Update:Void()
		' Locate player  and call TryMove()
		' Additional check for an empty tile
		Local canMove:Bool = False
		If player.y < y And player.x > x
			canMove = TryMove(DIR_NORTHEAST, True)
		ElseIf player.x > x And player.y > y
			canMove = TryMove(DIR_SOUTHEAST, True)
		ElseIf player.x < x And player.y > y
			canMove = TryMove(DIR_SOUTHWEST, True)
		ElseIf player.y < y And player.x < x
			canMove = TryMove(DIR_NORTHWEST, True)
		EndIf
		If canMove = False
			If player.y < y Then canMove = TryMove(DIR_NORTH, True)
			If player.y > y And canMove = False Then canMove = TryMove(DIR_SOUTH, True)
			If player.x > x And canMove = False Then canMove = TryMove(DIR_EAST, True)
			If player.x < x And canMove = False Then canMove = TryMove(DIR_WEST, True)
		EndIf

		' Call Entity Update() which will call Move() if entity is able to move
		Super.Update()
	End Method
	
	' Monsters move much more slowly
	Method MoveTo:Void(x:Int, y:Int, suppressAction:Bool=False)
		If noMove Then Return
		
		nextMoveTime = currTime + MONS_MOVE_RATE
		Super.MoveTo(x,y)
		If x = player.x And y = player.y
			player.BeginCombat(Self, False)
		EndIf
	End Method

	Method Damage:Int(amt:Int)
		amt -= Rnd(armorPower)
		If amt <= 0 Then Return 0
		
		hitPoints -= amt
		If hitPoints < 1
			alive = False
		EndIf
		Return amt
	End Method

End Class

Function MakeMonster:Monster(levelDepth:Int)
	Local mon:Monster
	Local ran:Int
	Local name:String = "Unknown"
	Local image:GameImage = Game12Gfx.Unknown
	Local lev:Int
	Local tier:Int			' Tier of monsters to show up
	Local noMove:Bool		' Can monster move ?
	
	' Four tiers of monsters, to keep it consistent in a group of levels
	' Sometimes a monster from an earlier tier can be "promoted"
	ran = Rnd(100)
	tier = levelDepth / 5 + 1
	If ran > 70
		' Promote the earlier tier !
		tier -= 1
		If tier < 1 Then tier = 1
	EndIf

	ran = Rnd(4) + 1
	' Different tiers of monsters
	Select tier
		Case 1
			Select ran
				Case 1 ; name = "Spider" ; image = Game12Gfx.Spider
				Case 2 ; name = "Wolf" ; image = Game12Gfx.Wolf
				Case 3 ; name = "Ooze" ; image = Game12Gfx.Ooze ; noMove = True
				Default ; name = "Goblin" ; image = Game12Gfx.Goblin
			End Select
		Case 2
			Select ran
				Case 1 ; name = "Skeleton" ; image = Game12Gfx.Skeleton
				Case 2 ; name = "Orc" ; image = Game12Gfx.Orc
				Case 3 ; name = "Fighter" ; image = Game12Gfx.Fighter
				Default ; name = "Bat" ; image = Game12Gfx.Bat
			End Select
		Case 3
			Select ran
				Case 1 ; name = "Bee" ; image = Game12Gfx.Bee
				Case 2 ; name = "Plant" ; image = Game12Gfx.Plant; noMove = True
				Case 3 ; name = "Ghost" ; image = Game12Gfx.Ghost
				Default ; name = "Sword" ; image = Game12Gfx.Sword
			End Select
		Default
			Select ran
				Case 1 ; name = "Giant" ; image = Game12Gfx.Giant
				Case 2 ; name = "Roc" ; image = Game12Gfx.Roc
				Case 3 ; name = "RedDragon" ; image = Game12Gfx.RedDragon
				Default ; name = "Beholder" ; image = Game12Gfx.Beholder
			End Select
	End Select
	
	' Give a little variation to the toughness of monsters	
	lev = levelDepth + Rnd(2) - 1
	lev = Min(levelDepth, 20)
	lev = Max(levelDepth, 1)
	mon = New Monster(lev, name, image, noMove)
	Return mon
End Function


Global AnimList:List<Anim> = new List<Anim>

Function GetNextAnimation:Anim()
	Local anim:Anim
	If AnimList.IsEmpty() = True
		Return Null
	Else
		anim = AnimList.First()
		AnimList.Remove(anim)
		anim.Activate()
	EndIf
	Return anim
End Function

Function QueueAnimation:Void(image:GameImage, x:Int, y:Int, tX:Int, tY:Int, sScale:Float, eScale:Float, noState:Bool = False, fadeOut:Bool = False, snd:GameSound = Null)
	Local anim:Anim = New Anim(image, x, y, tX, tY, sScale, eScale, fadeOut, snd)
	AnimList.AddLast(anim)
	If noState = False Then player.state = STATE_ANIM
End Function

Function MakeAnimation:Anim(image:GameImage, x:Int, y:Int, tX:Int, tY:Int, sScale:Float, eScale:Float, noState:Bool = False, fadeOut:Bool = False, snd:GameSound = Null)
	Local anim:Anim = New Anim(image, x, y, tX, tY, sScale, eScale, fadeOut, snd)
	anim.Activate()
	If noState = False Then player.state = STATE_ANIM
	Return anim
End Function


Class Anim
	Field image:GameImage	' The image of the sprite
	Field x:Int				' Current x
	Field y:Int				' Current y
	Field begX:Int			' Starting X
	Field begY:Int 			' Starting y
	Field targX:Int			' Final X position of animation
	Field targY:Int			' Final Y position of animation
	Field startScale:Float  ' Scale the sprite will start at
	Field endScale:Float 	' Scale needed before done
	Field fade:Bool			' Will sprite fade out or not 
	Field running:Bool		' Has animation started?
	Field mySprite:Sprite	' Diddy Sprite object to handle scale and movement
	
	Field mySound:GameSound ' What sound to play when animation activates!
	
	Method New(image:GameImage, x:Int, y:Int, tX:Int, tY:Int, sScale:Float, eScale:Float, fadeOut:Bool, snd:GameSound)
		Self.image = image
		begX = x
		begY = y
		targX = tX
		targY = tY
		startScale = sScale
		endScale = eScale
		fade = fadeOut
		mySound = snd
	End Method

	Method Activate:Void()
		If running = False
			x = begX
			y = begY
			mySprite = New Sprite(image, x, y)
			mySprite.scaleCounter = 100.0
			If startScale < endScale
				mySprite.scaleXSpeed = 0.04
				mySprite.scaleYSpeed = 0.04
			ElseIf startScale > endScale
				mySprite.scaleXSpeed = -0.04
				mySprite.scaleYSpeed = -0.04
			EndIf
			mySprite.scaleX = startScale
			mySprite.scaleY = startScale
			If targX <> 0 Then mySprite.dx = targX - x
			If targY <> 0 Then mySprite.dy = targY - y
			If fade Then mySprite.alpha = 1.0
			If mySound Then mySound.Play(1)
			running = True
		EndIf
	End Method
	
	Method Render:Void()
		mySprite.Draw()
	End Method

	Method Update:Void()
		x = mySprite.x
		y = mySprite.y
		If targX <> 0 Then mySprite.dx = targX - x
		If targY <> 0 Then mySprite.dy = targY - y
		mySprite.dx *= 0.05 * dt.delta
		mySprite.dy *= 0.05 * dt.delta
		mySprite.ManageScale()
		mySprite.Move()
		If fade = True
			If mySprite.alpha > 0.0
				mySprite.alpha -= 0.02 * dt.delta
			EndIf
		EndIf
	End Method

	Method Done:Bool()
		Local scaleDone:Bool = False
		Local moveDone:Bool = False
		Local fadeDone:Bool = False
		
		' ** Scale portion		
		If mySprite.scaleCounter < 0.01
			scaleDone = True
		Else
			If mySprite.scaleXSpeed < 0 And mySprite.scaleX <= endScale Then scaleDone = True
			If mySprite.scaleXSpeed > 0 And mySprite.scaleX >= endScale Then scaleDone = True
		EndIf
		If scaleDone = True Then mySprite.scaleCounter = 0.0

		' ** Move portion		
		If targX <> 0 And targY <> 0
			If mySprite.dx <> 0
				If Abs(mySprite.x - targX) < 2
					mySprite.dx = 0
					mySprite.x = targX
				EndIf
			EndIf
			If mySprite.dy <> 0
				If Abs(mySprite.y - targY) < 2
					mySprite.dy = 0
					mySprite.y = targY
				EndIf
			EndIf
			If mySprite.dx = 0 And mySprite.dy = 0 Then moveDone = True
		Else
			moveDone = True
		EndIf
		
		If fade = True
			If mySprite.alpha <= 0
				mySprite.alpha = 0
				fade = False
				fadeDone = True
			EndIf
		Else
			fadeDone = True
		EndIf
		
		Return scaleDone And moveDone And fadeDone
	End Method
End Class


#Rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#End