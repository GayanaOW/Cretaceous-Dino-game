
extends Node
class_name Inventory

signal item_changed(item_name: String, new_count: int)

var items: Dictionary = {}  # e.g. { "wood": 3, "spear": 1 }

func add_item(item_name: String, amount: int) -> void:
	items[item_name] = items.get(item_name, 0) + amount
	item_changed.emit(item_name, items[item_name])

func remove_item(item_name: String, amount: int) -> bool:
	if items.get(item_name, 0) < amount:
		return false  # not enough — reject the removal
	items[item_name] -= amount
	item_changed.emit(item_name, items[item_name])
	return true

func get_count(item_name: String) -> int:
	return items.get(item_name, 0)
