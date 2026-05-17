extends CharacterBody3D

var jump_force: float = 400.0
var move_force: float = 15.0
var is_on_ground: bool = false
var can_jump: bool = true
var move_direction: Vector2 = Vector2(0, 0)
var gravity: float = 20.0
var screen_width: float = 30.0
var max_velocity: float = 10.0

func _ready():
	pass

func _physics_process(delta):
	velocity.y -= gravity * delta
	
	if is_on_ground and can_jump:
		velocity.y = jump_force * delta
		can_jump = false
	
	var horizontal_velocity = Vector3(move_direction.x * move_force, 0, move_direction.y * move_force)
	velocity.x = lerp(velocity.x, horizontal_velocity.x, 0.1)
	velocity.z = lerp(velocity.z, horizontal_velocity.y, 0.1)
	
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	velocity.z = clamp(velocity.z, -max_velocity, max_velocity)
	
	move_and_slide()
	
	if global_position.y < -10:
		game_over()

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and is_on_ground:
			can_jump = true
	elif event is InputEventScreenDrag:
		move_direction = event.position / (screen_width * 20.0) * 2.0 - Vector2(1, 1)
		move_direction = move_direction.normalized() * 0.5
	elif event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE and is_on_ground:
			can_jump = true
		
		if event.pressed:
			if event.scancode == KEY_W or event.scancode == KEY_UP:
				move_direction.y = -1
			elif event.scancode == KEY_S or event.scancode == KEY_DOWN:
				move_direction.y = 1
			elif event.scancode == KEY_A or event.scancode == KEY_LEFT:
				move_direction.x = -1
			elif event.scancode == KEY_D or event.scancode == KEY_RIGHT:
				move_direction.x = 1
		else:
			if event.scancode in [KEY_W, KEY_UP, KEY_S, KEY_DOWN, KEY_A, KEY_LEFT, KEY_D, KEY_RIGHT]:
				move_direction = Vector2(0, 0)

func _on_ground_check_timer_timeout():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsPointQueryParameters3D.new()
	query.position = global_position + Vector3(0, -0.6, 0)
	query.collide_with_bodies = true
	var result = space_state.intersect_point(query, 1)
	is_on_ground = result.size() > 0
	
	if is_on_ground:
		can_jump = true

func game_over():
	get_tree().reload_current_scene()
