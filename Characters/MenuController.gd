extends Panel



func open():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	show()
	
func saveSettings():
	pass
func _on_SaveAndExit_pressed():
	hide()
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	saveSettings()

func _on_Quit_pressed():
	get_tree().quit()

func _on_ExitMenu_pressed():
	hide()
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
