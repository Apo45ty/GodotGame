extends Area


export var minHealthPointsToTrigger = 0

var isTriggered = false
func _on_Spatial_body_entered(body):
	if body.is_in_group("BlobController") and body.getPlayerHealthPoints()>=minHealthPointsToTrigger:
		var material = $"MeshInstance2".get_surface_material(0)
		material.albedo_color = Color(0, 1, 0)
		$"MeshInstance2".set_surface_material(0, material)
		isTriggered=true
