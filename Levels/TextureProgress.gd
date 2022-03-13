extends TextureProgress


func _ready():
	max_value = $"..".getPlayerMaxHealthPoints()

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	value = $"..".getPlayerHealthPoints()
