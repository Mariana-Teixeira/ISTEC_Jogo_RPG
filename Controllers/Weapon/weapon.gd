
extends Node3D
class_name Weapon

@onready var cast: ShapeCast3D = $ShapeCast3D

var damage: float = 25.0

func attack(attack_instance: Attack) -> void:
	if not cast.is_colliding():
		return

	print("Attacking")

	for i in cast.get_collision_count():
		var collider = cast.get_collider(i)
		var enemy = collider as Enemy

		if enemy != null:
			enemy.take_damage(attack_instance.damage)


func calculate_rune(rune: RuneData) -> void:
	damage = rune.damage
