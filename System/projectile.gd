extends RigidBody3D
var force: Vector3
@export var Speed: float = 10.0
@export var Damage: float = 10.0

func _ready() -> void:
	apply_central_impulse(force * 50)
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("player touch")
		var attack: Attack = Attack.new(Damage, self)
		body.health_component.damage(attack)

	queue_free()
