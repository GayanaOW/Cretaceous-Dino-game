extends Node
class_name Health

signal damaged(amount: float, current: float)
signal depleted  # fires when health hits 0

@export var max_health: float = 100.0
var current_health: float = max_health

func _ready():
	current_health = max_health

func take_damage(amount: float) -> void:
	current_health = max(current_health - amount, 0.0)
	damaged.emit(amount, current_health)
	print(current_health)
	if current_health <= 0.0:
		depleted.emit()

func heal(amount: float) -> void:
	current_health = min(current_health + amount, max_health)

func reset() -> void:
	current_health = max_health
