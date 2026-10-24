extends CharacterBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
var tween: Tween

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("bullet"):
		print("Hit")
		take_hit()

func take_hit() -> void:
	tween = create_tween()
	tween.tween_method(flash, 1.0, 0.0, 0.15)

func flash(value: float):
	mesh.set_instance_shader_parameter("flash_amount", value)
