extends Area3D

@export var rune_data: RuneData

var player_near: Player = null

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = body

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = null

func _process(_delta: float) -> void:
	if player_near != null and Input.is_action_just_pressed("apanhar"):
		player_near.add_rune_to_weapon(rune_data)
		queue_free()
