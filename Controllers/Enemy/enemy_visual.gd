extends Node3D

@export var enemy: Enemy
@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animator.play("Enemy/run")
