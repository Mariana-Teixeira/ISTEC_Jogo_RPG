extends CharacterBody3D
class_name Enemy

@export var MoveSpeed: float = 2.0
@export var HP: float = 100.0
@export var AttackReach: float = 1.5
@export var player: CharacterBody3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

	
func _physics_process(delta: float) -> void:
	navigation_agent.set_target_position(player.global_position)
	
	if global_position.distance_to(player.global_position) < AttackReach:
		var attack: Attack = Attack.new(1.0, self)
		player.health_component.damage(attack)
	
	if navigation_agent.is_navigation_finished():
		return
	
	var next_position: Vector3 = navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(next_position) * MoveSpeed
	
	move_and_slide()
	
func take_damage(damage: float) -> void:
	HP = HP - damage
	print(HP)
	
func on_death() -> void:
	queue_free()
