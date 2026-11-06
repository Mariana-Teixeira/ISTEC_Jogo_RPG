extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body.get("tem_chave") == true:
		var tween = create_tween()
		tween.tween_property(
	self,
	"rotation_degrees:y",
	90,
	1.0
)
