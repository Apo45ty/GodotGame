extends Spatial

onready var main =  get_node("/root/Main")
var healthPoints = 100

func addHealthPoint(points):
	healthPoints = min(healthPoints+points,main.MaxHealthPoints)

func _physics_process(delta):
	scale=Vector3(main.HPTOSCALE*healthPoints,main.HPTOSCALE*healthPoints,\
	main.HPTOSCALE*healthPoints)

func addCollider():
	var collision = load("res://Characters/Player_Static.tscn").instance()
	collision.name = "Player_Static"
	add_child(collision)

func removeCollider():
	var rigid = get_node("Player_Static")
	if rigid : rigid.queue_free()	
