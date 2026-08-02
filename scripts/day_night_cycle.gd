extends DirectionalLight3D

const DAY_LENGTH = 120.0

var time_elapsed: float = 0.0

@onready var sky_material: ProceduralSkyMaterial = get_node("/root/TestLevel/WorldEnvironment").environment.sky.sky_material
# adjust the path above to match where your WorldEnvironment actually is in the scene tree

func _process(delta):
	time_elapsed += delta
	var cycle_progress = fmod(time_elapsed, DAY_LENGTH) / DAY_LENGTH

	rotation_degrees.x = -cycle_progress * 360.0

	var elevation = sin(cycle_progress * TAU)
	var day_factor = clamp(elevation, 0.0, 1.0)

	light_energy = lerp(0.3, 1.2, day_factor)
	light_color = lerp(Color(0.4, 0.4, 0.7), Color(1.0, 0.95, 0.8), day_factor)

	# Animate sky colors to match
	sky_material.sky_top_color = lerp(Color(0.02, 0.02, 0.1), Color(0.3, 0.6, 1.0), day_factor)
	sky_material.sky_horizon_color = lerp(Color(0.1, 0.1, 0.2), Color(0.8, 0.8, 0.9), day_factor)
