class_name Player
extends CharacterBody3D

@export var camera: Camera3D
@export var bullet_marker: Marker3D
@export var move_speed: float = 2.0

var move_direction: Vector3
var mouse_position: Vector2

func _process(_delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_direction = Vector3(input.x, 0, input.y)

func _physics_process(_delta: float) -> void:
	move_character()
	rotate_character()

func _input(event: InputEvent) -> void:	
	# Aim
	if event is InputEventMouseMotion:
		mouse_position = event.position
	
	# Shooting
	if event.is_action_pressed("fire"):
		var origin = bullet_marker.global_position
		var destination = get_mouse_world_position()
		Events.player_shot.emit(origin, destination)
	
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
