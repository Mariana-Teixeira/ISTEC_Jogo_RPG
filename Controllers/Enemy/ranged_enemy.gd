
extends CharacterBody3D
class_name RangedEnemy

@export var MoveSpeed: float = 2.0
@export var EscapeSpeed: float = 3.5
@export var HP: float = 100.0
@export var AttackReach: float = 8.0
@export var MinimumDistance: float = 3.0
@export var EscapeDistance: float = 6.0

@export var player: CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	if player == null:
		
		return

	var distance = global_position.distance_to(player.global_position)

	# FUGIR QUANDO O JOGADOR ESTÁ DEMASIADO PERTO
	if distance <= MinimumDistance:

		var direction = global_position - player.global_position
		direction.y = 0

		if direction.length_squared() > 0.001:

			direction = direction.normalized()

			var escape_position = global_position + direction * EscapeDistance

			navigation_agent.set_target_position(escape_position)

			if not navigation_agent.is_navigation_finished():

				var next_position: Vector3 = navigation_agent.get_next_path_position()

				velocity = global_position.direction_to(next_position) * EscapeSpeed

				move_and_slide()

			else:
				velocity = Vector3.ZERO
				move_and_slide()

		# ATACAR ENQUANTO FOGE
		if distance <= AttackReach:
			var attack: Attack = Attack.new(1.0, self)
			player.health_component.damage(attack)

		return

	# PERSEGUIR O JOGADOR
	
	if distance > AttackReach:

		navigation_agent.set_target_position(player.global_position)

		if navigation_agent.is_navigation_finished():
			return

		var next_position: Vector3 = navigation_agent.get_next_path_position()

		velocity = global_position.direction_to(next_position) * MoveSpeed
		
		move_and_slide()

		return

	# MANTER DISTÂNCIA E ATACAR
	velocity = Vector3.ZERO
	move_and_slide()

	var attack: Attack = Attack.new(1.0, self)
	player.health_component.damage(attack)


func take_damage(damage: float) -> void:
	HP = HP - damage
	print(HP)


func on_death() -> void:
	queue_free()
