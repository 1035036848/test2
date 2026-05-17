extends Node2D

var platforms: Array[Node2D] = []
var screen_width: float = 1080.0
var platform_gap: float = 240.0
var platform_height: float = 600.0
var spawn_y: float = 1200.0
var min_platform_width: float = 150.0
var max_platform_width: float = 400.0
var platform_thickness: float = 30.0

func _ready():
	screen_width = get_viewport_rect().size.x
	
	for i in range(5):
		var y_pos = 300.0 + i * platform_gap
		spawn_platform(y_pos)

func spawn_platform(y_pos: float):
	var platform = ColorRect.new()
	
	var width = randf_range(min_platform_width, max_platform_width)
	platform.size = Vector2(width, platform_thickness)
	platform.color = Color(randf_range(0.2, 0.8), randf_range(0.2, 0.8), randf_range(0.2, 0.8), 1)
	
	var x_pos = randf_range(width/2 + 20, screen_width - width/2 - 20)
	platform.position = Vector2(x_pos - width/2, y_pos)
	
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(width, platform_thickness)
	collision_shape.shape = shape
	
	var static_body = StaticBody2D.new()
	static_body.add_child(collision_shape)
	
	platform.add_child(static_body)
	add_child(platform)
	platforms.append(platform)

func scroll_platforms(delta_y: float):
	for platform in platforms:
		platform.position.y -= delta_y
	
	var lowest_platform_y = INF
	for platform in platforms:
		if platform.position.y < lowest_platform_y:
			lowest_platform_y = platform.position.y
	
	if lowest_platform_y > -100:
		spawn_platform(spawn_y)
	
	var platforms_to_remove: Array[Node2D] = []
	for platform in platforms:
		if platform.position.y < -100:
			platforms_to_remove.append(platform)
	
	for platform in platforms_to_remove:
		platforms.erase(platform)
		platform.queue_free()

func _on_spawn_timer_timeout():
	spawn_platform(spawn_y)
