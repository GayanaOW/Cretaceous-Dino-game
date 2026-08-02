extends StaticBody3D

const WOOD_AMOUNT = 3  # how much wood one gather gives
const GATHER_COOLDOWN = 2.0  # seconds before this node can be gathered again

var can_gather: bool = true

func gather() -> int:
	if not can_gather:
		return 0
	can_gather = false
	await get_tree().create_timer(GATHER_COOLDOWN).timeout
	can_gather = true
	return WOOD_AMOUNT
