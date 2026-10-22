extends Control

@export var label: RichTextLabel
@export var edit: TextEdit

func _on_join_button_pressed() -> void:
	Network.join(edit.text)

func _ready() -> void:
	if Network.is_server_instance():
		label.text = "Server"
	else:
		label.text = "Client"
