#Rem
header:
[quote]

[b]File Name :[/b] About_Screen
[b]Author    :[/b] Paul "Taiphoz" Grayston
[b]About     :[/b]
This Screen is here to show the authors, and their details, as well as showing that
the project was made with monkey, demonstrating it's ability to target other platforms
and explaining how easy things are to make.
[/quote]
#end



Import main

#Rem
summary:Title Screen Class.
Used to manage and deal with all Tital Page stuff.
#End
Class AboutScreen Extends Screen
	Field background:GameImage
	Field background_mask:GameImage
	Field buttons_image:GameImage
	
	Field buttonajust:Int
	
	Field y:Float
	Field abouttext:String
	
	
	Method New()
		name = "About Screen"
	End
	#Rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		background = diddyGame.images.Find("about")
		background_mask = diddyGame.images.Find("about_mask")
		buttons_image = diddyGame.images.Find("about_buttons")
		
		Self.y = 440
		 abouttext = "Welcome to the MonkeyCoder.co.nz Community~n"
		abouttext += "Project, built with Monkey, for Monkey and~n"
		abouttext += "for the community.~n~n"
		abouttext += ""
		abouttext += "Each of the Mini Games in this Project were~n"
		abouttext += "written in the Monkey programming language.~n"
		abouttext += "A simple and easy to learn language that will~n"
		abouttext += "let even the most novice of programmers ~n"
		abouttext += "quickly create and build their own games.~n~n"
		abouttext += ""
		abouttext += "Not only will you be able to make your own~n"
		abouttext += "games, but thanks to Monkey's amazing list~n"
		abouttext += "of targets you will be able to easily export~n"
		abouttext += "your game to any platform.~n~n"
		abouttext += ""
		abouttext += "You write your code in Monkey, and then deploy~n"
		abouttext += "on as many or as few platforms as you like.~n~n"
		abouttext += ""
		
		
		abouttext += "Project Founder : Taiphos aka Paul Grayston~n"
		abouttext += "~n"
		abouttext += "Project Authors :~n"

		For Local gameid:Int = 1 to 20
			abouttext += " +-> Slot   : " + ( (GameList[gameid - 1].id) + 1) + "~n"
			abouttext += " +-> Game   : " + GameList[gameid - 1].name + "~n"
			abouttext += " +-> Author : " + GameList[gameid - 1].author + "~n"
			abouttext += " +-> Site   : " + GameList[gameid - 1].authorurl + "~n~n"
		next
		

		#rem		
		SLOT 1:Taiphoz(invaders)
		SLOT 2 : Slenker (?)
		SLOT 3 : GeeCee3(?)
		SLOT 4 : skn3(?)
		SLOT 5 : Karja(?)
		SLOT 6 : Fryman(?)
		SLOT 7 : Tibit(?)
		SLOT 8 : therevills(?)
		SLOT 9 : Samah(?)
		SLOT 10 : Neuro(?)
		#end	
	End
	
	#Rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		DrawImage(background.image, 0, 0)
		
		
		InfoFont.DrawText(abouttext, 190, Self.y, 1)
		
					
		DrawImage(background_mask.image, 159, 0)
		
		'for debug.
		'SmallFont.DrawText("y = " + Self.y, 20, 60)
		
		
		DrawImage(buttons_image.image, 585, 103)
	End

	#Rem
	sumary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	and all use input.
	#End
	Method Update:Void()
	
		Self.y -= (0.2 + Self.buttonajust) * dt.delta
	
		if Self.y < - 3000 Then Self.y = 440
		if Self.y > 440 Then Self.y = - 3000
		
	if MouseOver(585, 103, 53, 53)
		Self.buttonajust = -5 * dt.delta
	elseif MouseOver(585, 426, 53, 53)
		Self.buttonajust = 5 * dt.delta
	Else
		Self.buttonajust = 0
	End if
		
	if MouseOver(42, 399, 100, 57)
		if TouchHit() or MouseHit(MOUSE_LEFT)
			FadeToScreen(TitleScr)
		End if
	EndIf
	
	
	End
	
End


#Rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#end