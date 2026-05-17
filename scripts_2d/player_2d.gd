extends CharacterBody2D

var jump_force: float = 800.0
var move_force: float = 600.0
var is_on_ground: bool = false
var can_jump: bool = true
var move_direction: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_width: float = 1080.0
var max_velocity: float = 600.0
var jump_count: int = 0
var max_jumps: int = 1

func _physics_process(delta):
	if not is_on_ground:
		velocity.y += gravity * delta
	
	if is_on_ground and can_jump and jump_count < max_jumps:
		velocity.y = -jump_force
		jump_count += 1
		can_jump = false
	
	velocity.x = move_direction * move_force
	
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	
	move_and_slide()
	
	if global_position.y < -100:
		game_over()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			can_jump = true
	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		var screen_center = screen_width / 2
		move_direction = (event.position.x - screen_center) / screen_center
		move_direction = clamp(move_direction, -1.0, 1.0)
	elif event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_A or event.scancode == KEY_LEFT:
				move_direction = -1.0
			elif event.scancode == KEY_D or event.scancode == KEY_RIGHT:
				move_direction = 1.0
			elif event.scancode == KEY_SPACE and is_on_ground and jump_count < max_jumps:
				can_jump = true
		else:
			if event.scancode in [KEY_A, KEY_LEFT, KEY_D, KEY_RIGHT]:
				move_direction = 0.0

func _on_ground_check_timer_timeout():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position + Vector2(0, 30)
	query.collide_with_bodies = true
	var result = space_state.intersect_point(query, 1)
	is_on_ground = result.size() > 0
	
	if is_on_ground:
		jump_count = 0
		can_jump = true
		move_direction = 0.0

func game_over():
	get_tree().reload_current_scene()
