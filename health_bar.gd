extends ProgressBar
class_name HealthBar

func update_health(current_hp: float, max_hp: float) -> void:
	max_value = max_hp
	value = current_hp
