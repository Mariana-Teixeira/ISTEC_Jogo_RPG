extends CharacterBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("bullet"):
		print("Hit ", body.name)
