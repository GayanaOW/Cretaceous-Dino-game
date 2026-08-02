extends CharacterBody3D

enum State { IDLE, ALERT, CHASE, ATTACK }

const CHASE_SPEED = 4.0
const DETECTION_RADIUS = 10.0
const ATTACK_RANGE = 1.5
const ALERT_DURATION = 0.5
const PACK_ALERT_RADIUS = 15.0  # NEW: how far the "I see you!" call reaches

const ATTACK_DAMAGE = 10.0
const ATTACK_COOLDOWN = 1.0  # seconds between hits

var attack_timer: float = 0.0

signal spotted_player  # NEW: this raptor declares it CAN announce this event

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_state: State = State.IDLE
var player: Node3D = null
var alert_timer: float = 0.0
var has_alerted_pack: bool = false  # NEW: so we only shout once per detection, not every frame

@onready var health: Health = $Health

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	add_to_group("raptors")  # NEW: joins the "raptors" group so others can find it

	# NEW: connect to every other raptor's signal, so when THEY spot the player, this one reacts too
	call_deferred("_connect_to_pack")
	
	health.depleted.connect(_on_raptor_defeated)

func _on_raptor_defeated():
	queue_free()  # simplest MVP behavior: raptor disappears when defeated

func _connect_to_pack():
	var pack = get_tree().get_nodes_in_group("raptors")
	for raptor in pack:
		if raptor != self and not raptor.spotted_player.is_connected(_on_pack_alert):
			raptor.spotted_player.connect(_on_pack_alert)

func _on_pack_alert(alerter_position: Vector3) -> void:
	if current_state == State.IDLE:
		var distance_to_alerter = global_position.distance_to(alerter_position)
		if distance_to_alerter <= PACK_ALERT_RADIUS:
			current_state = State.ALERT
			alert_timer = 0.0

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
			if not has_alerted_pack:
				spotted_player.emit(global_position)  # NEW: tell the pack
				has_alerted_pack = true
			if alert_timer >= ALERT_DURATION:
				current_state = State.CHASE
			

		State.CHASE:
			if distance <= ATTACK_RANGE:
				current_state = State.ATTACK
			elif distance > DETECTION_RADIUS * 1.5:  # a bit more forgiving once already chasing
				current_state = State.IDLE
				has_alerted_pack = false

		State.ATTACK:
			if distance > ATTACK_RANGE:
				current_state = State.CHASE

func _act_on_state(distance: float, delta: float) -> void:
	match current_state:
		State.IDLE, State.ALERT:
			velocity.x = move_toward(velocity.x, 0, CHASE_SPEED)
			velocity.z = move_toward(velocity.z, 0, CHASE_SPEED)

		State.CHASE:
			var direction = (player.global_position - global_position)
			direction.y = 0
			direction = direction.normalized()
			velocity.x = direction.x * CHASE_SPEED
			velocity.z = direction.z * CHASE_SPEED

		State.ATTACK:
			velocity.x = 0
			velocity.z = 0
			attack_timer -= delta
			if attack_timer <= 0.0:
				_attack_player()
				attack_timer = ATTACK_COOLDOWN

func _attack_player() -> void:
	var player_health = player.get_node_or_null("Health")
	if player_health:
		player_health.take_damage(ATTACK_DAMAGE)
