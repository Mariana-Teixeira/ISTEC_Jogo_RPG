extends Area3D

@export var rune_data: RuneData

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player = body as Player
		player.add_rune_to_weapon(rune_data)
		queue_free()
