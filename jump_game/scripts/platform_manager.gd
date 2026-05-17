extends Node3D

var platforms: Array[Node3D] = []
var platform_scene: PackedScene
var screen_width: float = 30.0
var platform_gap: float = 4.0
var platform_height: float = 10.0
var spawn_y: float = 30.0
var platform_count: int = 0

func _ready():
	platform_scene = create_platform_scene()
	
	for i in range(5):
		var y_pos = 5.0 + i * platform_gap
		spawn_platform(y_pos)

func create_platform_scene() -> PackedScene:
	var platform = MeshInstance3D.new()
	var collision = CollisionShape3D.new()
	var static_body = StaticBody3D.new()
	
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(5, 0.5, 1)
	platform.mesh = box_mesh
	
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(5, 0.5, 1)
	collision.shape = box_shape
	
	return PackedScene.new()

func spawn_platform(y_pos: float):
	var platform = MeshInstance3D.new()
	
	var width = randf_range(3, 8)
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(width, 0.5, 1)
	platform.mesh = box_mesh
	
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(width, 0.5, 1)
	collision_shape.shape = box_shape
	
	var static_body = StaticBody3D.new()
	static_body.add_child(collision_shape)
	platform.add_child(static_body)
	
	var x_pos = randf_range(-screen_width/2 + width/2 + 1, screen_width/2 - width/2 - 1)
	platform.position = Vector3(x_pos, y_pos, 0)
	
	add_child(platform)
	platforms.append(platform)
	platform_count += 1

func scroll_platforms(delta_y: float):
	for platform in platforms:
		platform.position.y -= delta_y
	
	var lowest_platform_y = INF
	for platform in platforms:
		if platform.position.y < lowest_platform_y:
			lowest_platform_y = platform.position.y
	
	if lowest_platform_y > -20:
		spawn_platform(spawn_y)
	
	var platforms_to_remove: Array[Node3D] = []
	for platform in platforms:
		if platform.position.y < -20:
			platforms_to_remove.append(platform)
	
	for platform in platforms_to_remove:
		platforms.erase(platform)
		platform.queue_free()

func _on_spawn_timer_timeout():
	spawn_platform(spawn_y)
