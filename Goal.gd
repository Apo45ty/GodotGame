extends Area


onready var main =  get_node("/root/Main")
func _on_Spatial_body_entered(body):
	if body.is_in_group("BlobController"):
		main.currentLevel+=1
		print(str(main.currentLevel))
		get_tree().change_scene("res://Levels/Level"+str(int(main.currentLevel))+".tscn")
