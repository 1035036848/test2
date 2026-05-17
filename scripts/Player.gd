extends RigidBody

var jump_force: float = 400.0
var move_force: float = 15.0
var is_on_ground: bool = false
var can_jump: bool = true
var move_direction: Vector2 = Vector2(0, 0)
var screen_scroll_speed: float = 3.0
var screen_y_offset: float = 0.0
var screen_width: float = 30.0

func _ready():
	contact_monitor = true
	max_contacts_reported = 10
	
func _physics_process(delta):
	if is_on_ground and can_jump:
		apply_central_impulse(Vector3(0, jump_force * delta, 0))
		can_jump = false
	
	var horizontal_velocity = Vector3(move_direction.x * move_force, 0, move_direction.y * move_force)
	apply_force(horizontal_velocity)
	
	screen_y_offset += screen_scroll_speed * delta
	
	if global_position.y < -5:
		game_over()

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			can_jump = true
	elif event is InputEventScreenDrag:
		move_direction = event.position / (screen_width * 20.0) * 2.0 - Vector2(1, 1)
		move_direction = move_direction.normalized()

func _on_Timer_timeout():
	var space_state = get_world3d().direct_space_state
	var query = PhysicsPointQueryParameters3D.new()
	query.position = global_position + Vector3(0, -1.1, 0)
	var result = space_state.intersect_point(query, 1)
	is_on_ground = result.size() > 0

func game_over():
	get_tree().reload_current_scene()
