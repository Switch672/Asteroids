extends Node2D

@export var angle:float

@onready var camera:Camera2D = %Camera2D

var delta_count:float


func _enter_tree():
	
	angle += randf_range(-0.05, 0.05)
	rotate(angle)


# Called when the node enters the scene tree for the first time.
func _process(delta):
	
	translate( Vector2.from_angle(angle) * 500 * delta )
	
	delta_count += delta
	
	if delta_count > 5:
		
		self.queue_free()


func _on_body_entered(body):
	
	if body.get_parent().get_name() == "Asteroids":
		
		body.asteroid_hit()
		self.queue_free()
