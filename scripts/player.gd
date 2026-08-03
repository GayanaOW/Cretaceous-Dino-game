extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003

const ATTACK_DAMAGE = 25.0
const ATTACK_RANGE = 2.5

const KNOCKOUT_DURATION = 3.0
const RECOVERY_HEALTH = 50.0

var is_knocked_out: bool = false
signal knocked_out
signal recovered

const INTERACT_RANGE = 3.0
@onready var inventory = $Inventory

const SPEAR_WOOD_COST = 5
const SPEAR_ATTACK_DAMAGE = 40.0

var has_spear: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D
@onready var health: Health = $Health

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health.depleted.connect(_on_knocked_out)
	await get_tree().physics_frame  # let physics fully initialize before allowing raycasts

func _on_knocked_out():
	if is_knocked_out:
		return
	is_knocked_out = true
	knocked_out.emit()

	await get_tree().create_timer(KNOCKOUT_DURATION).timeout

	health.current_health = RECOVERY_HEALTH
	is_knocked_out = false
	recovered.emit()
	
func _unhandled_input(event):
	if is_knocked_out:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	elif event.is_action_pressed("attack"):
		_try_attack()
	elif event.is_action_pressed("interact"):
		_try_interact()
	elif event.is_action_pressed("craft_spear"):
		_try_craft_spear()

func _try_interact():
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z * INTERACT_RANGE)

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	print("interact raycast result: ", result)  # DEBUG

	if result:
		var hit_object = result.collider
		if hit_object.has_method("gather"):
			var amount = await hit_object.gather()
			if amount > 0:
				inventory.add_item("wood", amount)
				print("Gathered wood! Total: ", inventory.get_count("wood"))
		
func _try_attack():
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z * ATTACK_RANGE)

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)

	if result:
		var hit_object = result.collider
		var health_node = hit_object.get_node_or_null("Health")
		if health_node:
			var damage = SPEAR_ATTACK_DAMAGE if has_spear else ATTACK_DAMAGE
			health_node.take_damage(damage)
			print("Hit ", hit_object.name, " for ", damage, " damage")
			
func _try_craft_spear():
	if has_spear:
		print("Already have a spear")
		return
	if inventory.remove_item("wood", SPEAR_WOOD_COST):
		has_spear = true
		print("Crafted a spear!")
	else:
		print("Not enough wood — need ", SPEAR_WOOD_COST)

func _physics_process(delta):
	if is_knocked_out:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if not is_on_floor():
			velocity.y -= gravity * delta
		move_and_slide()
		return  # skip all normal input handling below

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
