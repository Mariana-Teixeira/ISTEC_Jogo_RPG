extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set("tem_chave",true)
		print("Apanhaste o item!")
		queue_free()
