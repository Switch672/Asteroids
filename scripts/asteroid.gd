extends RigidBody2D

var vector:Vector2
var missile:PackedScene = preload("res://scenes/missile.tscn")

const SCALE_FACTOR:Vector2 = Vector2(0.3, 0.3)

@export var asteroid_pos:Vector2

@onready var asteroid:PackedScene = preload("res://scenes/asteroid.tscn")
@onready var asteroid_script:Script = preload("res://scripts/asteroid.gd")
@onready var asteroid_size:Vector2 = get_child(1).get_scale()
@onready var health:int = 10 * asteroid_size.x
@onready var camera:Camera2D = $%Camera2D


func _enter_tree():
	
	vector = Vector2i(randi_range(0 - get_viewport().size.x/2, get_viewport().size.x/2), randi_range(0 - get_viewport().size.y/2, get_viewport().size.y/2))
	
	if asteroid_pos:
		
		set_position(asteroid_pos)
	else:
		
		set_position( clamp( vector * -5, Vector2(0 - get_viewport().size.x/2,0 - get_viewport().size.y/2), Vector2(get_viewport().size.x/2,get_viewport().size.y/2) ) )
	
	set_linear_velocity( vector * 0.4 )
	set_angular_velocity( 0.5 )
	set_gravity_scale( 0.0 )


func asteroid_split(old_size:Vector2):
	
	var new_asteroid:RigidBody2D = asteroid.instantiate()
	new_asteroid.set_script(asteroid_script)
	new_asteroid.get_child(1).set_scale(old_size - SCALE_FACTOR)
	new_asteroid.get_child(0).set_scale(old_size - SCALE_FACTOR)
	new_asteroid.asteroid_pos = get_position()
	
	new_asteroid.linear_velocity *= 2
	
	for i in range(3):
		get_parent().call_deferred("add_child", new_asteroid.duplicate())


func asteroid_hit():
	
	health -= 1
	
	if health <= 0:
		
		if not get_child(0).get_scale() - SCALE_FACTOR < Vector2.ZERO:
			asteroid_split(get_child(0).get_scale())
			
		queue_free()
