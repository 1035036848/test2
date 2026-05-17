extends Node3D

var scroll_speed: float = 3.0
var scroll_offset: float = 0.0

func _process(delta):
	scroll_offset += scroll_speed * delta

func _on_scroll_timer_timeout():
	var camera = get_node_or_null("Player/Camera3D")
	if camera:
		camera.translate_object_local(Vector3(0, scroll_speed * 0.016, 0))
	
	var platform_manager = get_node_or_null("PlatformManager")
	if platform_manager:
		platform_manager.scroll_platforms(scroll_speed * 0.016)
