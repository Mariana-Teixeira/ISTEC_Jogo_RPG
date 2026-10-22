extends Node3D

@export var bullet_scene: PackedScene
@export var bullet_force: float = 2.0

func _ready() -> void:
	Signals.player_shot.connect(fire_shot)

func fire_shot(origin: Vector3, destination: Vector3) -> void:
	var direction = (destination - origin).normalized()
	direction.y = 0
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = origin
	bullet.apply_central_impulse(direction * bullet_force)
