extends Node3D

var scroll_speed: float = 3.0
var scroll_offset: float = 0.0

func _process(delta):
	scroll_offset += scroll_speed * delta
	
	var camera = get_node_or_null("Player/Camera3D")
	if camera:
		camera.translate_object_local(Vector3(0, scroll_speed * delta, 0))

func _on_ScrollTimer_timeout():
	pass
