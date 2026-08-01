extends CharacterBody3D

enum State { IDLE, ALERT, CHASE, ATTACK }

const CHASE_SPEED = 4.0
const DETECTION_RADIUS = 10.0
const ATTACK_RANGE = 1.5
const ALERT_DURATION = 0.5  # brief pause before chase starts, feels more natural

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_state: State = State.IDLE
var player: Node3D = null
var alert_timer: float = 0.0

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player:
		var distance = global_position.distance_to(player.global_position)
		_update_state(distance, delta)
		_act_on_state(distance, delta)

	move_and_slide()

func _update_state(distance: float, delta: float) -> void:
	match current_state:
		State.IDLE:
			if distance <= DETECTION_RADIUS:
				current_state = State.ALERT
				alert_timer = 0.0

		State.ALERT:
			alert_timer += delta
			if alert_timer >= ALERT_DURATION:
				current_state = State.CHASE
			elif distance > DETECTION_RADIUS:
				current_state = State.IDLE

		State.CHASE:
			if distance <= ATTACK_RANGE:
				current_state = State.ATTACK
			elif distance > DETECTION_RADIUS:
				current_state = State.IDLE

		State.ATTACK:
			if distance > ATTACK_RANGE:
				current_state = State.CHASE

func _act_on_state(distance: float, delta: float) -> void:
	match current_state:
		State.IDLE, State.ALERT:
			# standing still, gravity still applies but no horizontal movement
			velocity.x = move_toward(velocity.x, 0, CHASE_SPEED)
			velocity.z = move_toward(velocity.z, 0, CHASE_SPEED)

		State.CHASE:
			var direction = (player.global_position - global_position)
			direction.y = 0
			direction = direction.normalized()
			velocity.x = direction.x * CHASE_SPEED
			velocity.z = direction.z * CHASE_SPEED

		State.ATTACK:
			# stop moving, attack logic comes in ticket #8/#9 once health system exists
			velocity.x = 0
			velocity.z = 0
