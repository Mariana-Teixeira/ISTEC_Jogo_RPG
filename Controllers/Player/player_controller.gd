extends CharacterBody3D
class_name Player

var tem_chave = false
@onready var animador:AnimationPlayer=$"Camera3D/braco-2/AnimationPlayer"
@export var look_sensitivity: float = 0.002

@export var attack_cooldown: float = 1.0

var can_attack: bool = true

@onready var camera = $Camera3D
@onready var health_label: Label = $HealthLabel
@onready var health_component: Node = $HealthComponent
@onready var player_health_bar: HealthBar = $CanvasLayer/HealthBar3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@onready var weapon: Weapon = $Weapon

var target_velocity = Vector3.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	player_health_bar.update_health(
		health_component.health,
		health_component.MaxHealth
	)
	
func _process(delta: float) -> void:
	health_label.text = str(health_component.health)

	player_health_bar.update_health(
		health_component.health,
		health_component.MaxHealth
	)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if can_attack:
				attack()
				animador.play("ArmatureAction_001")

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = basis * direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		# basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
func on_death() -> void:
	var game_over_scene = preload("res://game_over.tscn")
	var game_over = game_over_scene.instantiate()

	get_tree().root.add_child(game_over)

func add_rune_to_weapon(rune: RuneData) -> void:
	weapon.calculate_rune(rune)
	speed = rune.Speed
	health_component.DarVida(rune.Health)

func attack() -> void:
	can_attack = false

	var attack_instance: Attack = Attack.new(weapon.damage, self)

	weapon.attack(attack_instance)

	await get_tree().create_timer(attack_cooldown).timeout

	can_attack = true
