extends Node

const PORT: int = 9080
const GAME: String = "res://scenes/game.tscn"

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	if is_server_instance():
		start_server()

func is_server_instance():
	return (
		OS.has_feature("dedicated_server") or
		"--server" in OS.get_cmdline_args() or
		"--server" in OS.get_cmdline_user_args()
		)

func start_server():
	var peer = WebSocketMultiplayerPeer.new()
	var err = peer.create_server(PORT)
	
	if err != OK:
		push_error("Could not start server: %s" % err)
		return
		
	multiplayer.multiplayer_peer = peer
	
	print("Listening to ", PORT)

func join(url: String) -> void:
	var peer := WebSocketMultiplayerPeer.new()
	peer.create_client(url)
	multiplayer.multiplayer_peer = peer

func _on_connection_failed() -> void:
	multiplayer.multiplayer_peer = null

func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
