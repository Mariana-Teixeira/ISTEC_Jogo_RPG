extends Node3D

@export var player_scene: PackedScene

func _ready() -> void:
	if not Network.is_server_instance(): return
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnect)

func _on_peer_connected(id: int) -> void:
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)

func _on_peer_disconnect(id: int) -> void:
	var player_name = str(id)
	get_node(player_name).queue_free()
