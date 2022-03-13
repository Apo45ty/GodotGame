extends Spatial

var MaxHealthPoints = 500
const HPTOSCALE = 0.01 # 1 hp equals 0.1 scale
var healthPoints = 100

func addHealthPoint(points):
	healthPoints = min(healthPoints+points,MaxHealthPoints)

func _physics_process(delta):
	scale=Vector3(HPTOSCALE*healthPoints,HPTOSCALE*healthPoints,HPTOSCALE*healthPoints)

func addCollider():
	var collision = load("res://Characters/Player_Static.tscn").instance()
	collision.name = "Player_Static"
	add_child(collision)

func removeCollider():
	var rigid = get_node("Player_Static")
	if rigid : rigid.queue_free()	
