#Rem
header:
[quote]

[b]File Name :[/b] Game10Screen
[b]Author    :[/b] firstname "alias" lastname
[b]About     :[/b]
what it is..
[/quote]
#end



Import main

#Rem
summary:Title Screen Class.
Used to manage and deal with all Tital Page stuff.
#End
Class Game10Screen Extends Screen

	
	Method New()
		name = "Game 10 Screen"
		Local gameid:Int = 10
		GameList[gameid - 1] = New miniGame
		GameList[gameid - 1].id = gameid - 1
		GameList[gameid - 1].name = "Neuro"
		GameList[gameid - 1].iconname = "game" + gameid + "_icon"
		GameList[gameid - 1].thumbnail = "game" + gameid + "_thumb"
		GameList[gameid - 1].author = "????"
		GameList[gameid - 1].authorurl = "????"
		GameList[gameid - 1].info = "????"
	End
	#Rem
	summary:Start Screen
	Start the Title Screen.
	#End
	Method Start:Void()
		diddyGame.screenFade.Start(50, False)		
	End
	
	#Rem
	summary:Render Title Screen
	Renders all the Screen Elements.
	#End
	Method Render:Void()
		Cls
		TitleFont.DrawText(self.name,320,240,2)
	End

	#Rem
	sumary:Update Title Screen
	Will update all screen objects, handles mouse, keys
	and all use input.
	#End
	Method Update:Void()
		'
		if KeyHit(KEY_ESCAPE)
			diddyGame.nextScreen = TitleScr
			diddyGame.screenFade.Start(50, true)
		EndIf
		
	End method

	
End


#Rem
footer:
[quote]
[a Http://www.monkeycoder.co.nz]Monkey Coder[/a] 
[/quote]
#end