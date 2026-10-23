extends Node3D

@export var zombie_scene: PackedScene

func _ready() -> void:
	if not Network.is_server_instance(): return
	var zombie = zombie_scene.instantiate()
	add_child(zombie)
	zombie.global_position = get_radius_location(2.0)

func get_radius_location(radius: float) -> Vector3:
	var x = randf_range(-1.0, 1.0);
	var z = randf_range(-1.0, 1.0);
	var random_direction = Vector3(x, 0, z).normalized()
	return random_direction * radius
