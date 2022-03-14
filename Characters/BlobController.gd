extends KinematicBody
#jumping
const ISINJUMP = 0
const ISNOTINJUMP = 1
var jumpState = ISNOTINJUMP
#player initialization
onready var player = $Player
#movement
var motion = Vector3()
var UP = Vector3(0,1,0)
#joining
const RAY_LENGTH = 100000

#Blobarray
var blobArray = [player]
var currentBlobIndex = 0
#settings cache
onready var settings = get_node("/root/ControlSettings")
onready var main =  get_node("/root/Main")
func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player = $"Player"
	blobArray = [player]

func getPlayerMaxHealthPoints():
	if player == null :
		return 500
	return main.MaxHealthPoints
	
func getPlayerHealthPoints():
	return player.healthPoints

func _physics_process(delta):
	move(delta)
	animate()
	checkBoundaries()
	if Input.is_action_just_released("menu"):
		get_tree().quit()
	if Input.is_action_just_released("join"):
		join()
	if Input.is_action_just_released("split"):
		split()
	if rayCastIsColliding() :#is_on_floor()
		if Input.is_action_just_released("nextBlob"):
			nextBlob()
		if Input.is_action_just_released("previousBlob"):
			previousBlob()
	var hAxis = Input.get_action_strength("look_left")-Input.get_action_strength("look_right")
	var vAxis = Input.get_action_strength("look_up")-Input.get_action_strength("look_down")
	rotation = h_camera_rotation(hAxis*settings.JoystickSensetivityHorizontal)
	$Camera.rotation = v_camera_rotation(vAxis*settings.JoystickSensetivityVertical)	
	
	
func checkBoundaries():
	if translation.y <-10:
		translation = Vector3.ZERO

func previousBlob():
	currentBlobIndex=(currentBlobIndex-1)%blobArray.size()
	getBlob()

func nextBlob():
	currentBlobIndex=(1+currentBlobIndex)%blobArray.size()
	getBlob()
	
func getBlob():
	print(currentBlobIndex)
	var newBlob = blobArray[currentBlobIndex]
	newBlob.removeCollider()
	var Time = 5.0
	var Destination = newBlob.translation
	#	if abs((translation-Destination).length()) > 0.1:
#		var tween = get_node("Tween")
#		tween.interpolate_property($".","translation",
#			translation,
#			Destination,
#			Time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
#		tween.start()
	player.set_as_toplevel(true)
	if blobArray.size()>1:
		player.addCollider()
	player=newBlob
	translation = player.translation
	newBlob.rotation=rotation
	player.set_as_toplevel(false)
	add_child(newBlob)
	

func split():
	if player.healthPoints <= 1 or not rayCastIsColliding():#or not is_on_floor()
		return
	player.healthPoints=player.healthPoints/2
	var clone = load("res://Characters/Player.tscn").instance()
	add_child(clone)
	blobArray.append(clone)
	clone.healthPoints=player.healthPoints
	clone.set_as_toplevel(true)
	clone.global_transform = $SplitLocation.global_transform
	var character_forward = global_transform.basis[2].normalized()
	clone.addCollider()
	
func move(delta):
	if $"../CanvasLayer/Tutorial" and not $"../CanvasLayer/Tutorial".done:
		return
	var movement_dir = get_2d_movement_dir()
	var dirrection_to_cam = Vector3.ZERO
	var camera_xform = $Camera.global_transform
	dirrection_to_cam -= camera_xform.basis.z.normalized()*movement_dir.x
	dirrection_to_cam -= camera_xform.basis.x.normalized()*movement_dir.y
	motion = dirrection_to_cam*(main.Speed+(1/player.healthPoints)*main.SpeedPointsGainedPerHealthPointLoss)
	if(jumpState==ISINJUMP and rayCastIsColliding()):
		jumpState=ISNOTINJUMP
	var y = 0
	if Input.is_action_just_pressed("jump") and rayCastIsColliding() :#and is_on_floor()
		 y = main.JumpSpeed+(1/float(player.healthPoints))*float(main.JumpPointsGainedPerHealthPointLoss)
		 print(y)
		 jumpState=ISINJUMP
	motion.y=y
	#add gravity
	if not rayCastIsColliding():
#		print("falling")
		motion.x/=main.JumpMovementReducer
		motion.z/=main.JumpMovementReducer
		if jumpState==ISINJUMP and not Input.is_action_pressed("fast_fall"):
#			print("ISINJUMP")
			motion.y+=(main.gravity/main.GravityReducer) * delta
		elif jumpState==ISNOTINJUMP || Input.is_action_pressed("fast_fall"):
			motion.y+=main.gravity * delta
#	print(motion)
	move_and_slide(motion,UP)
	
	
func get_2d_movement_dir():
	var y = Input.get_action_strength("left")-Input.get_action_strength("right")
	var x = Input.get_action_strength("up")-Input.get_action_strength("down")
	var movement_dir = Vector2(x,y)
	return movement_dir.normalized()
	
	
func animate():
	if motion.length() > 0.1:
		pass
		#$AnimationPlayer().play("")
	else:
		#$AnimationPlayeru().stop()
		pass

func _input(event):
	if event is InputEventMouseMotion :
		if event.relative :
			rotation = h_camera_rotation(-event.relative.x*settings.sensitivity)
			$Camera.rotation = v_camera_rotation(-event.relative.y*settings.sensitivity)
	
	

func join():
	var rayCast = get_object_under_mouse()
#	print(rayCast)
	for obj in rayCast.values(): 
		if not obj is Node:
			continue
		if obj.is_in_group("Playable"):
			var player_2 = obj.get_parent()
#			print(player_2.name)
			player.addHealthPoint(player_2.healthPoints)
			blobArray.erase(player_2)
			player_2.queue_free()
			break

func h_camera_rotation(camera_rotation):
	return rotation + Vector3(0,camera_rotation,0)

func v_camera_rotation(camera_rotation):
	var rot = $Camera.rotation + Vector3(camera_rotation,0,0)
	rot.x = clamp(rot.x,-PI/6,PI/6)
	return rot
	
# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_object_under_mouse():
#	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_pos = Vector2(512,300)
	var ray_from = $Camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + $Camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to,[self])
	return selection
	
	
func rayCastIsColliding():
	return $"RayCast".is_colliding()
