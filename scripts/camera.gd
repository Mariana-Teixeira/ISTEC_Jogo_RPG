extends Camera3D

@export var follow_speed: float = 5.0

var player: Player
var offset: Vector3

func _ready() -> void:
	Signals.local_player_ready.connect(link_to_player)
	offset = position

func link_to_player(p: Player) -> void:
	player = p
	player.camera = self

func _process(_delta: float) -> void:
	if not player: return
	move_camera()
	rotate_camera()

func move_camera() -> void:
	var destination = player.position + offset;
	position = destination

func rotate_camera() -> void:
	look_at(player.position)
