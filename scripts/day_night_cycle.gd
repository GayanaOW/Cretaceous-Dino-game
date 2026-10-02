extends DirectionalLight3D

@export var world_environment: WorldEnvironment
@export var sky_material: ProceduralSkyMaterial
@export var star_dome: MeshInstance3D

const DAY_LENGTH = 120.0

var time_elapsed: float = 0.0
var player: Node3D = null

func _process(delta):
	time_elapsed += delta
	player = get_tree().get_root().find_child("Player", true, false)
	var cycle_progress = fmod(time_elapsed, DAY_LENGTH) / DAY_LENGTH

	rotation_degrees.x = -cycle_progress * 360.0

	var elevation = sin(cycle_progress * TAU)
	var day_factor = clamp(elevation, 0.0, 1.0)
	var night_fog_factor = clamp(-elevation, 0.0, 1.0)  # 0 during day, ramps up after sunset, peaks at midnight, ramps down before sunrise

	light_energy = lerp(0.3, 1.2, day_factor)
	light_color = lerp(Color(0.4, 0.4, 0.7), Color(1.0, 0.95, 0.8), day_factor)

	sky_material.sky_top_color = lerp(Color(0.02, 0.02, 0.1), Color(0.3, 0.6, 1.0), day_factor)
	sky_material.sky_horizon_color = lerp(Color(0.1, 0.1, 0.2), Color(0.8, 0.8, 0.9), day_factor)

	var env = world_environment.environment
	env.fog_light_color = lerp(Color(0.8, 0.8, 0.7), Color(0.15, 0.15, 0.3), night_fog_factor)
	env.fog_density = lerp(0.0, 0.001, night_fog_factor)  # wider range, and now actually varies through the whole night
	env.fog_sky_affect = 0.4
	env.fog_aerial_perspective = 0.5
	env.fog_light_energy = lerp(1.0, 2.5, night_fog_factor)  # boosts fog's own brightness so it's visible even when scene light is dim

	var dawn_dusk_factor = 1.0 - abs(day_factor - 0.5) * 2.0
	env.glow_intensity = lerp(0.4, 0.9, dawn_dusk_factor)
	
	var star_material = star_dome.get_surface_override_material(0)
	
	if player and star_dome:
		star_dome.global_position = player.global_position
	
	if star_material == null:
		star_material = star_dome.mesh.surface_get_material(0)
	var star_alpha = smoothstep(0.1, 0.6, night_fog_factor)  # starts fading in later, finishes later — tune these two numbers to taste
	star_material.albedo_color = Color(star_alpha, star_alpha, star_alpha)  # scales brightness instead of alpha
	#star_material.albedo_color.a = night_fog_factor  # fades in as it gets dark, out as day approaches
