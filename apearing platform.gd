extends Spatial

func _physics_process(delta):
	if $"Trigger".isTriggered:
		$"Spatial".get_node("CollisionShape").disabled = false
		$"Spatial".show()
	else :
		$"Spatial".get_node("CollisionShape").disabled = true 
		$"Spatial".hide()
	



