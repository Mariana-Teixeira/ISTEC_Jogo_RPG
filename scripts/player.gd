class_name Player
extends CharacterBody3D

@export var camera: Camera3D
@export var move_speed: float = 2.0

var move_direction: Vector3
var mouse_position: Vector2

func _process(_delta : float) -> void:
	move_direction = read_move_input()

func _physics_process(delta: float) -> void:
	move_character()
	rotate_character()

func read_move_input() -> Vector3:
	var x: float = 0.0
	var z: float = 0.0
	
	if (Input.is_action_pressed("move_forward")):
		z += 1
	if (Input.is_action_pressed("move_backward")):
		z -= 1
	if (Input.is_action_pressed("move_left")):
		x += 1
	if (Input.is_action_pressed("move_right")):
		x -= 1
	
	return Vector3(x, 0, z)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = event.position

func get_mouse_world_position() -> Vector3:
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = camera.project_ray_normal(mouse_position)
	var plane = Plane(Vector3.UP, position.y)
	
	var intersection = plane.intersects_ray(ray_origin, ray_direction)
	if (intersection == null):
		return position + Vector3.FORWARD
	else:
		return intersection 

func move_character() -> void:
	velocity = move_direction * move_speed
	move_and_slide()

func rotate_character() -> void:
	var mouse_world_position = get_mouse_world_position()
	var direction = position - mouse_world_position
	look_at(direction, Vector3.UP)
