extends Control

@onready var health_bar: ProgressBar = $HealthBar
@onready var wood_label: Label = $WoodLabel

var player: Node3D = null

@onready var knockout_overlay: ColorRect = $KnockoutOverlay
@onready var wood_count_label: Label = $WoodSlot/WoodCountLabel

func _on_inventory_changed(item_name: String, new_count: int) -> void:
	if item_name == "wood":
		wood_count_label.text = str(new_count)

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	if player:
		player.health.damaged.connect(_on_player_damaged)
		player.inventory.item_changed.connect(_on_inventory_changed)
		player.knocked_out.connect(_on_player_knocked_out)
		player.recovered.connect(_on_player_recovered)
		health_bar.value = player.health.current_health

func _on_player_knocked_out():
	var tween = create_tween()
	tween.tween_property(knockout_overlay, "color:a", 0.4, 0.3)

func _on_player_recovered():
	var tween = create_tween()
	tween.tween_property(knockout_overlay, "color:a", 0.0, 0.5)

func _on_player_damaged(amount: float, current: float) -> void:
	health_bar.value = current
