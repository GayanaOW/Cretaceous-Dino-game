extends StaticBody3D

const WOOD_AMOUNT = 3  # how much wood one gather gives
const GATHER_COOLDOWN = 1.5  # seconds before this node can be gathered again

var can_gather: bool = true

func gather() -> int:
	print("gather() called, can_gather = ", can_gather)  # DEBUG
	if not can_gather:
		return 0
	can_gather = false
	_start_cooldown()
	return WOOD_AMOUNT

func _start_cooldown():
	await get_tree().create_timer(GATHER_COOLDOWN).timeout
	can_gather = true
	print("cooldown finished, can_gather = true")  # DEBUG
