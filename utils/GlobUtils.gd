extends RefCounted
class_name GlobUtils

static func get_screen_center() -> Vector2:
	return Vector2(DisplayServer.window_get_size().x/2, DisplayServer.window_get_size().y/2)

static func get_center(vector : Vector2) -> Vector2:
	return Vector2(vector.x/2, vector.y/2)
