extends RigidBody3D


@export var Speed: float = 10.0
@export var Damage: float = 10.0

var force: Vector3

func launch(spawn: Marker3D, player: Player) -> void:
	global_position = spawn.global_position
	force = global_position.direction_to(player.global_position)
	force.y = 0.25
	apply_central_impulse(force * Speed)

func _on_damage_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var attack: Attack = Attack.new(Damage, self)
		body.health_component.damage(attack)
	queue_free()
