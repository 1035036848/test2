extends Node3D

var platform_scene: PackedScene
var platforms: Array[Node3D] = []
var screen_width: float = 30.0
var platform_gap: float = 4.0
var platform_height: float = 10.0
var spawn_y_offset: float = 0.0

func _ready():
	platform_scene = create_platform_scene()
	spawn_platform()
	spawn_platform()
	spawn_platform()

func create_platform_scene() -> PackedScene:
	var ss = Node3D.new()
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(randf_range(2, 8), 0.5, 1)
	mesh_instance.mesh = box_mesh
	ss.add_child(mesh_instance)
	
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = box_mesh.size
	collision_shape.shape = box_shape
	ss.add_child(collision_shape)
	
	var static_body = StaticBody3D.new()
	static_body.add_child(collision_shape)
	ss.add_child(static_body)
	
	var cs = CollisionShape3D.new()
	cs.shape = box_shape
	static_body.add_child(cs)
	
	return PackedScene.new()

func spawn_platform():
	var platform = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	var width = randf_range(2, 8)
	box_mesh.size = Vector3(width, 0.5, 1)
	platform.mesh = box_mesh
	
	var x_pos = randf_range(-screen_width/2 + width/2, screen_width/2 - width/2)
	var y_pos = spawn_y_offset + platform_height
	platform.position = Vector3(x_pos, y_pos, 0)
	
	add_child(platform)
	platforms.append(platform)
	spawn_y_offset += platform_gap

func _on_SpawnTimer_timeout():
	spawn_platform()
	if platforms.size() > 20:
		var oldest = platforms.pop_front()
		oldest.queue_free()
