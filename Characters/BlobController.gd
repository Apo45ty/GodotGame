extends KinematicBody

onready var player = $Player
var motion = Vector3()
const Speed = 10
const JumpSpeed = 200
const UP = Vector3(0,1,0)
const gravity = -100
const sensitivity = 0.01
var blobArray = [player]
var currentBlobIndex = 0

func _ready():
	player = $"Player"
	blobArray = [player]
	
func getPlayerHealthPoints():
	return player.healthPoints

func _physics_process(delta):
	move(delta)
	animate()

func previousBlob():
	currentBlobIndex=(currentBlobIndex-1)%blobArray.size()
	getBlob()

func nextBlob():
	currentBlobIndex=(1+currentBlobIndex)%blobArray.size()
	getBlob()
	
func getBlob():
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
	player.set_as_toplevel(false)
	add_child(newBlob)
	

func split():
	if player.healthPoints <= 1 ||not is_on_floor():
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
	motion = dirrection_to_cam*Speed
	var y = 0
	if Input.is_action_pressed("jump") and is_on_floor():
		 y = JumpSpeed
	motion.y=y
	#add gravity
	motion.y+=gravity * delta
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
	if event is InputEventMouseMotion:
		if event.relative :
			rotation = h_camera_rotation(-event.relative.x*sensitivity)
			$Camera.rotation = v_camera_rotation(-event.relative.y*sensitivity)
	if Input.is_action_just_pressed("split"):
		split()
	if Input.is_action_just_pressed("raiseHP"):
		player.healthPoints += 10
	if Input.is_action_just_pressed("lowerHP"):
		player.healthPoints -= 10
#	if Input.is_key_pressed(KEY_K):
#		print(blobArray)
	if is_on_floor():
		if Input.is_action_just_pressed("nextBlob"):
			nextBlob()
		if Input.is_action_just_pressed("previousBlob"):
			previousBlob()
		
func h_camera_rotation(camera_rotation):
	return rotation + Vector3(0,camera_rotation,0)

func v_camera_rotation(camera_rotation):
	var rot = $Camera.rotation + Vector3(camera_rotation,0,0)
	rot.x = clamp(rot.x,-PI/8,PI/8)
	return rot
