extends StaticBody3D

const FIBER_AMOUNT = 2
const GATHER_COOLDOWN = 3.0  # slightly longer than wood, fiber is a bit more precious

var can_gather: bool = true

func gather() -> int:
	if not can_gather:
		return 0
	can_gather = false
	_start_cooldown()
	return FIBER_AMOUNT

func _start_cooldown():
	await get_tree().create_timer(GATHER_COOLDOWN).timeout
	can_gather = true
