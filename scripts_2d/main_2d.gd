extends Node2D

var scroll_speed: float = 180.0
var scroll_offset: float = 0.0
var screen_width: float
var screen_height: float

func _ready():
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	
	var player = get_node_or_null("Player")
	if player:
		player.screen_width = screen_width

func _process(delta):
	scroll_offset += scroll_speed * delta
	
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	
	var player = get_node_or_null("Player")
	if player:
		player.screen_width = screen_width

func _on_scroll_timer_timeout():
	var platform_manager = get_node_or_null("PlatformManager")
	if platform_manager:
		platform_manager.scroll_platforms(scroll_speed * 0.016)
		platform_manager.screen_width = screen_width
