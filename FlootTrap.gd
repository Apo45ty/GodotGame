extends Area

export var minHealthPointsToTrigger = 0
var colliders = []
var isTriggered = false



func _physics_process(delta):
	if(colliders.size()>=1):
		for collider in colliders:
			if not (overlaps_body(collider)):
				colliders.erase(collider)
		checkIfNoColliderMeetsRequirements()
	
func checkIfNoColliderMeetsRequirements():
	for collider in colliders:
		if collider.is_in_group("BlobController") and collider.getPlayerHealthPoints()>=minHealthPointsToTrigger:
			triggerPlayerEnter()
			return
		elif collider.is_in_group("Playable") and collider.get_parent().healthPoints>=minHealthPointsToTrigger:
			triggerPlayerEnter()
			return
	triggerPlayerExit()

func _on_Spatial_body_entered(body):
	if body.is_in_group("BlobController") or body.is_in_group("Playable") :
		colliders.append(body)
		triggerPlayerEnter()
		
func triggerPlayerEnter():
	var material = $"MeshInstance2".get_surface_material(0)
	material.albedo_color = Color(0, 1, 0)
	$"MeshInstance2".set_surface_material(0, material)
	isTriggered=true

func _on_Spatial_body_exited(body):
	if body.is_in_group("BlobController") :
		colliders.erase(body)
		checkIfNoColliderMeetsRequirements()
	elif body.is_in_group("Playable") :
		colliders.erase(body)
		checkIfNoColliderMeetsRequirements()
			
func triggerPlayerExit():
	var material = $"MeshInstance2".get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	$"MeshInstance2".set_surface_material(0, material)
	isTriggered=false
