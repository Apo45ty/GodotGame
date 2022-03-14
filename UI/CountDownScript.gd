extends Label


func _physics_process(delta):
	text = "Skiping to next scene in "+str(20-$"../..".passedSeconds)+" seconds."  
