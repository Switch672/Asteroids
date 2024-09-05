extends CharacterBody2D

const ACCELERATION:float = 3000
const FRICTION:float = 3
const SPEED_CAP:float = 170

@export var health:int = 20

@onready var missile:PackedScene = load("res://scenes/missile.tscn")

var player_velocity:Vector2
var mouse_pos:Vector2
var delta_count:float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	delta_count += delta
	
	# Determine lateral movement
	if Input.get_vector("left","right","up","down").x < SPEED_CAP:
		velocity.x -= ( -1 * ( Input.get_vector("left","right","up","down").x ) * ACCELERATION ) * delta
	
	# Determine vertical movement
	if Input.get_vector("left","right","up","down").y < SPEED_CAP:
		velocity.y -= ( -1 * ( Input.get_vector("left","right","up","down").y ) * ACCELERATION ) * delta
	
	# Handle movement
	velocity -= velocity * ( delta * FRICTION )
	
	move_and_slide()
	
	# Point at cursor
	mouse_pos = get_global_mouse_position()
	
	look_at(mouse_pos)
	
	# Handle shoots
	if Input.is_action_pressed("shoot") and delta_count > 0.1:
		
		var active_missile = missile.instantiate()
		active_missile.translate(get_position() + Vector2.from_angle(get_rotation() * 20000))
		active_missile.angle = get_rotation()
		get_node(".").add_sibling(active_missile)
		
		delta_count = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.get_parent().get_name() == "Asteroids":
		
		health -= 1
