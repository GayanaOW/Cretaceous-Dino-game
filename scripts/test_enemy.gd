extends CharacterBody3D

const SPEED = 3.0
const DETECTION_RADIUS = 10.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: Node3D = null

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance <= DETECTION_RADIUS:
			var direction = (player.global_position - global_position)
			direction.y = 0
			direction = direction.normalized()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0

	move_and_slide()
