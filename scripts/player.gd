class_name Player
extends CharacterBody3D

@export var move_speed: float = 2.0

var camera: Camera3D
var move_direction: Vector3
var mouse_position: Vector2

func _enter_tree() -> void:
	var id = name.to_int()
	set_multiplayer_authority(id)

func _ready() -> void:
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
	else:
		Signals.local_player_ready.emit(self)

func _process(_delta : float) -> void:
	move_direction = read_move_input()

func _physics_process(_delta: float) -> void:
	move_character()
	rotate_character()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = event.position

func read_move_input() -> Vector3:
	var x: float = 0.0
	var z: float = 0.0
	
	if (Input.is_action_pressed("move_forward")):
		z -= 1
	if (Input.is_action_pressed("move_backward")):
		z += 1
	if (Input.is_action_pressed("move_left")):
		x -= 1
	if (Input.is_action_pressed("move_right")):
		x += 1
	
	return Vector3(x, 0, z).normalized()

func get_mouse_world_position() -> Vector3:
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = camera.project_ray_normal(mouse_position)
	var plane = Plane(Vector3.UP, global_position.y)
	
	var intersection = plane.intersects_ray(ray_origin, ray_direction)
	if (not intersection):
		return global_position + Vector3.FORWARD
	else:
		return intersection 

func move_character() -> void:
	velocity = move_direction * move_speed
	move_and_slide()

func rotate_character() -> void:
	var mouse_world_position = get_mouse_world_position()
	look_at(mouse_world_position, Vector3.UP)
