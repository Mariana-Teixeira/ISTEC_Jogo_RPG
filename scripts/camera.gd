extends Camera3D

@export var player: Player
@export var follow_speed: float = 5.0

var previous_position : Vector3

var offset: Vector3

func _ready() -> void:
	offset = position

func _process(delta: float) -> void:
	move_camera(delta)
	rotate_camera()

func move_camera(delta: float) -> void:
	var destination = player.position + offset;
	var t = follow_speed * delta;
	position = lerp(position, destination, t)

func rotate_camera() -> void:
	look_at(player.position)
