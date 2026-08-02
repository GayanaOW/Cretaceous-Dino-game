extends Control

@onready var health_bar: ProgressBar = $HealthBar
@onready var wood_label: Label = $WoodLabel

var player: Node3D = null

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	if player:
		player.health.damaged.connect(_on_player_damaged)
		player.inventory.item_changed.connect(_on_inventory_changed)
		health_bar.value = player.health.current_health

func _on_player_damaged(amount: float, current: float) -> void:
	health_bar.value = current

func _on_inventory_changed(item_name: String, new_count: int) -> void:
	if item_name == "wood":
		wood_label.text = "Wood: " + str(new_count)
