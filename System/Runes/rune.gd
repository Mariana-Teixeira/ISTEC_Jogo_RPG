extends Area3D

@export var rune_data: RuneData

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") && body is Player:
		queue_free()
