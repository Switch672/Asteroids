extends Node2D

var asteroid:PackedScene = load("res://scenes/asteroid.tscn")
var delta_count:float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	delta_count += delta
	
	if delta_count > randf_range(4,8):
		
		var active_asteroid = asteroid.instantiate()
		active_asteroid.set_scale(Vector2.ONE)
		get_node(".").add_child(active_asteroid)
		
		delta_count = 0
