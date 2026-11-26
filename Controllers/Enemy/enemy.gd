
extends CharacterBody3D
class_name Enemy

@export var MoveSpeed: float = 2.0
@export var HP: float = 100.0
@export var AttackReach: float = 1.5

@export var AttackDamage: float = 10.0
@export var AttackCooldown: float = 1.0

@export var player: CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var health_bar: HealthBar = $SubViewport/HealthBar3D

var can_attack: bool = true

func _ready() -> void:
	health_bar.max_value = HP
	health_bar.value = HP


func _physics_process(delta: float) -> void:
	navigation_agent.set_target_position(player.global_position)

	if global_position.distance_to(player.global_position) < AttackReach:
		if can_attack:
			attack()

	if navigation_agent.is_navigation_finished():
		return

	var next_position: Vector3 = navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(next_position) * MoveSpeed

	move_and_slide()


func attack() -> void:
	can_attack = false

	var attack_instance: Attack = Attack.new(AttackDamage, self)
	player.health_component.damage(attack_instance)

	await get_tree().create_timer(AttackCooldown).timeout

	can_attack = true


func take_damage(damage: float) -> void:
	HP = max(HP - damage, 0)

	health_bar.value = HP

	print(HP)

	if HP <= 0:
		on_death()


func on_death() -> void:
	queue_free()
