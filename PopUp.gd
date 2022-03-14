extends Control

const TimeInBetweenWindows = 1.0
const TimePerScreen = 20.0
const InitialWaitForDisplay = 5.0
var passedSeconds = 0
var done = false
func _ready():
	$Welcome.hide()
	$movementControls.hide()
	$spaceForJump.hide()
	$lookAround.hide()
	$split.hide()
	$join.hide()
	$boostsWhenSmaller.hide()
	$weightWhenBigger.hide()
	$switchControl.hide()
	movementControls()
	done = false

func movementControls():
	$Welcome.show()
	yield(get_tree().create_timer(TimeInBetweenWindows+InitialWaitForDisplay), "timeout")
	$Welcome.hide()
	$movementControls.show()
	passedSeconds = 0
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$movementControls.hide()
	spaceForJump()
	
func spaceForJump():
	yield(get_tree().create_timer(TimeInBetweenWindows), "timeout")
	$spaceForJump.show()
	passedSeconds = 0.0;
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$spaceForJump.hide()
	lookAround()
func lookAround():
	yield(get_tree().create_timer(TimeInBetweenWindows), "timeout")
	$lookAround.show()
	passedSeconds = 0;
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$lookAround.hide()
	split()
func split():
	yield(get_tree().create_timer(TimeInBetweenWindows), "timeout")
	$split.show()
	passedSeconds = 0;
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$split.hide()
	join()
func join():
	yield(get_tree().create_timer(TimeInBetweenWindows), "timeout")
	$join.show()
	passedSeconds = 0;
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$join.hide()
	boostsWhenSmaller()
func boostsWhenSmaller():
	yield(get_tree().create_timer(TimeInBetweenWindows), "timeout")
	$boostsWhenSmaller.show()
	passedSeconds = 0;
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$boostsWhenSmaller.hide()
	weightWhenBigger()
func weightWhenBigger():
	yield(get_tree().create_timer(TimeInBetweenWindows), "timeout")
	$weightWhenBigger.show()
	passedSeconds = 0;
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$weightWhenBigger.hide()
	switchControl()
func switchControl():
	yield(get_tree().create_timer(TimeInBetweenWindows), "timeout")
	$switchControl.show()
	passedSeconds = 0;
	while passedSeconds < TimePerScreen:
		yield(get_tree().create_timer(0.3), "timeout")
		passedSeconds+=0.3
		if Input.is_action_pressed("jump"):
			break	
	$switchControl.hide()
	done = true

