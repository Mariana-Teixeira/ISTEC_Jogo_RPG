
extends CharacterBody3D
class_name RangedEnemy

@export var MoveSpeed: float = 4.0
@export var EscapeSpeed: float = 3.5
@export var HP: float = 100.0
@export var AttackReach: float = 9.0
@export var MinimumDistance: float = 7.0
@export var EscapeDistance: float = 18.0
@export var ProjectileScene: PackedScene
@export var ProjectileCooldown: float = 1.5

@onready var projectile_spawn: Marker3D = $ProjectileSpawn
@export var player: CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var can_shoot: bool = true

func _physics_process(delta: float) -> void:
	if player == null:
		
		return
	look_at(player.global_position)
	var distance = global_position.distance_to(player.global_position)

	# FUGIR QUANDO O JOGADOR ESTÁ DEMASIADO PERTO
	if distance <= MinimumDistance:
		
		var direction = player.global_position.direction_to(global_position) 
		direction.y = 0

		var escape_position = global_position + direction * EscapeDistance

		navigation_agent.set_target_position(escape_position)

		if not navigation_agent.is_navigation_finished():
			
			var next_position: Vector3 = navigation_agent.get_next_path_position()

			velocity = global_position.direction_to(next_position) * EscapeSpeed

			move_and_slide()


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

	if distance <= AttackReach:
		shoot_projectile()

func take_damage(damage: float) -> void:
	HP = HP - damage
	print(HP)


func on_death() -> void:
	queue_free()
	
func shoot_projectile() -> void:
	if not can_shoot:
		return
	if ProjectileScene == null:
		return
	can_shoot = false
	var projectile = ProjectileScene.instantiate()
	add_child(projectile)
	projectile.launch(projectile_spawn, player)

	await get_tree().create_timer(ProjectileCooldown).timeout
	can_shoot = true
