extends Node3D
class_name Weapon

@onready var cast: ShapeCast3D = $ShapeCast3D

var damage: float

func _process(delta: float) -> void:
	if Input.is_action_pressed("attack") && cast.is_colliding():
		print("Colliding")
		for i in cast.get_collision_count():
			var collider = cast.get_collider(i)
			var enemy = collider as Enemy
			if enemy != null:
				enemy.take_damage(damage)
			
	
func calculate_rune(rune: RuneData) -> void:
	damage = rune.damage
