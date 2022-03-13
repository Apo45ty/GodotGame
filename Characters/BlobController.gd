extends KinematicBody

const ISINJUMP = 0
const ISNOTINJUMP = 1
const GravityReducer = 2
const JumpMovementReducer = 2
var jumpState = ISNOTINJUMP


onready var player = $Player
const initialHealthPoints = 120
var motion = Vector3()
const Speed = 10
const JumpSpeed = 500
const UP = Vector3(0,1,0)
const gravity = -500
const sensitivity = 0.01
const JoystickSensetivityHorizontal = 0.12
const JoystickSensetivityVertical = 0.05
const RAY_LENGTH = 100000
var JumpPointsGainedPerHealthPointLoss = 25000
const SpeedPointsGainedPerHealthPointLoss = 50
var blobArray = [player]
var currentBlobIndex = 0

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player = $"Player"
	blobArray = [player]
	player.healthPoints = initialHealthPoints


func getPlayerMaxHealthPoints():
	if player == null :
		return 500
	return player.MaxHealthPoints
	
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
	if Input.is_action_just_released("raiseHP"):
		print(JumpPointsGainedPerHealthPointLoss)
		JumpPointsGainedPerHealthPointLoss += 100
	if Input.is_action_just_released("lowerHP"):
		print(JumpPointsGainedPerHealthPointLoss)
		JumpPointsGainedPerHealthPointLoss -= 100
#	if Input.is_key_pressed(KEY_K):
#		print(blobArray)
	if rayCastIsColliding() :#is_on_floor()
		if Input.is_action_just_released("nextBlob"):
			nextBlob()
		if Input.is_action_just_released("previousBlob"):
			previousBlob()
	var hAxis = Input.get_action_strength("look_left")-Input.get_action_strength("look_right")
	var vAxis = Input.get_action_strength("look_up")-Input.get_action_strength("look_down")
	rotation = h_camera_rotation(hAxis*JoystickSensetivityHorizontal)
	$Camera.rotation = v_camera_rotation(vAxis*JoystickSensetivityVertical)	
	
	
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
	var movement_dir = get_2d_movement_dir()
	var dirrection_to_cam = Vector3.ZERO
	var camera_xform = $Camera.global_transform
	dirrection_to_cam -= camera_xform.basis.z.normalized()*movement_dir.x
	dirrection_to_cam -= camera_xform.basis.x.normalized()*movement_dir.y
	motion = dirrection_to_cam*(Speed+(1/player.healthPoints)*SpeedPointsGainedPerHealthPointLoss)
	if(jumpState==ISINJUMP and rayCastIsColliding()):
		jumpState=ISNOTINJUMP
	var y = 0
	if Input.is_action_just_pressed("jump") and rayCastIsColliding() :#and is_on_floor()
		 y = JumpSpeed+(1/float(player.healthPoints))*float(JumpPointsGainedPerHealthPointLoss)
		 print(y)
		 jumpState=ISINJUMP
	motion.y=y
	#add gravity
	if not rayCastIsColliding():
#		print("falling")
		motion.x/=JumpMovementReducer
		motion.z/=JumpMovementReducer
		if jumpState==ISINJUMP and not Input.is_action_pressed("fast_fall"):
#			print("ISINJUMP")
			motion.y+=(gravity/GravityReducer) * delta
		elif jumpState==ISNOTINJUMP || Input.is_action_pressed("fast_fall"):
			motion.y+=gravity * delta
	print(motion)
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
			rotation = h_camera_rotation(-event.relative.x*sensitivity)
			$Camera.rotation = v_camera_rotation(-event.relative.y*sensitivity)
	
	

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
