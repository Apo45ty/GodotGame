extends TextureProgress


func _ready():
	max_value = 500

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	value = $"../Player".getPlayerHealthPoints()
