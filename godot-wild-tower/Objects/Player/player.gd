extends CharacterBody3D

@export var mouse_sensitivity: float = 0.5
@export var tilt_lower_limit: float = deg_to_rad((-89))
@export var tilt_upper_limit: float = deg_to_rad(89)

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5

@export var dash_pop: float = 2.5

@export var air_speed_mult: float = 0.5

@export var dash_distance: float = 5
@export var enemy_dash_distance: float = 10
@export var dash_speed: float = 0.2

@export var vertical_dash_limit: float = 5

@export var slow_time_duration: float = 1.0
@export var slow_time_delay: float = 0.5

var short_dash_count: int = 1
var jump_count: int = 0

var mouse_rotation: Vector3

var move_direction: Vector3 = Vector3.ZERO

var is_jumping: bool = false
var is_dashing: bool = false

var dash_tween: Tween = null
var time_tween: Tween = null

var acceleration: float = 5
var current_acceleration: float = 0.0
var speed_mult: float = 1.0
var last_velocity: Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_mult: float = 1.0

var current_enemy: Object = null
var enemy_outliner: Outliner = null

var started: bool = false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	%RayCastEyes.target_position.z = -1 * enemy_dash_distance


#func _input(event):
	#if event.is_action_pressed("ui_cancel"):
		#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			##TO/DO go to a pause screen and pause it
			#
		#else:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent):
	var mouse_input: bool = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input && !is_dashing:
		var rotation_input: float = -event.relative.x * mouse_sensitivity
		var tilt_input: float = -event.relative.y * mouse_sensitivity
		update_camera(get_process_delta_time(), rotation_input, tilt_input)
	
	if event.is_action("dash") && !is_dashing:
		if event.is_pressed():
			if !started: start()
			try_dash()
	
	if event.is_action("dash_short") && !is_dashing:
		if event.is_pressed():
			if !started: start()
			dash_forward()


func _process(delta):
	check_eye_ray()
	
	%DebugJumpsLabel.text = "Jumps: " + str(jump_count)
	%DebugDashesLabel.text = "Dashes: " + str(short_dash_count)


func _physics_process(delta):
	
	
	var on_floor: bool = is_on_floor()
	
	if is_dashing: 
		if on_floor:%DebugOnFloorLabel.text = "On Floor"
		else: %DebugOnFloorLabel.text = "Not on Floor"
		move_and_slide()
		return
	
	
	#if ladder != null:
		#on_floor = true
	#CHECK IF SHOULD DO HEAD BOB ON LANDING
	#if on_floor:
		#on_steps = false
		#if !was_on_floor && !on_steps:# && last_velocity.y < -5.0: #JUST LANDED
			##print("PLAYING IMPACT AT Y VELOCITY OF " + str(last_velocity.y))
			#if last_velocity.y < -20.0:
				#landing_head_bob = true
			#play_impact(-last_velocity.y)
	
	# Add the gravity.
	if !on_floor:# && !is_clambering:
		speed_mult = air_speed_mult
		velocity.y -= gravity * delta * gravity_mult
		last_velocity = velocity
		if is_jumping && velocity.y < 0:
			is_jumping = false
		#if on_steps && velocity.y < -5:
			#on_steps = false
		%DebugOnFloorLabel.text = "Not on Floor"
	else:
		speed_mult = 1.0
		short_dash_count = 1
		jump_count = 0
		%DebugOnFloorLabel.text = "On Floor"
		#if crouched_up:
			#animation_player.play("crouch_reset")
			#GameEvents.emit_player_crouch(false)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (on_floor || jump_count > 0):
		if !started: start()
		if jump_count > 0 && !on_floor:
			velocity.y = JUMP_VELOCITY * 0.5
			jump_count -= 1
			#print("DOING AIR JUMP")
		else: velocity.y = JUMP_VELOCITY
		is_jumping = true
		on_floor = false
		
	#was_on_floor = on_floor
	
	#if !crouch_toggle:
		#if is_crouching:
			#if !Input.is_action_pressed("crouch") || ladder != null:
				#try_uncrouch()
		#else:
			#if Input.is_action_just_pressed("crouch") && ladder == null:# and is_on_floor():
				#crouch()
	#else:
		#if is_crouching && (crouch_toggled_off || ladder != null):
			#try_uncrouch()
			
	
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir.length_squared() > 0:
		move_direction = %CameraRotationRoot.transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
		if !started:
			start()
	else:
		move_direction = Vector3.ZERO
	#if input_dir.y > 0:
		#is_sprinting = false
	#else:
		#if !sprint_toggle:
			#if Input.is_action_pressed("sprint"): # && (!is_crouching || can_uncrouch()):
				#if can_crouch_sprint:
					#is_sprinting = true
				#else:
					#if !is_crouching || can_uncrouch():
						#try_uncrouch()
						#is_sprinting = true
			#else: 
				#is_sprinting = false
	#
	#if is_crouching && on_floor:
		#speed_mult = crouch_speed_mult
	#else:
		#speed_mult = normal_speed_mult
	#
	#if is_sprinting:
		#speed_mult *= sprint_speed_mult

	# Get the input direction and handle the movement/deceleration.
	
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = (%CameraRotationRoot.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0, direction.z).normalized()
	
	if direction:
		#if ladder != null:
			#move_on_ladder(input_dir, direction, delta)
		#else: move(direction, delta, on_floor)
		move(direction, delta, on_floor)
		
	else:
		if on_floor:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		#if ladder != null:
			#if is_jumping:
				#velocity.y -= gravity * delta
				#if velocity.y < 0:
					#is_jumping = false
			#else: velocity.y = move_toward(velocity.y, 0, SPEED)
		#
		#is_clambering = false
		#
		#if temp_crouch && is_crouching:
			#try_uncrouch()
			#
		#update_head_bob(delta, landing_head_bob)

	move_and_slide()
	
	#last_velocity = velocity


func start():
	started = true
	GameEvents.emit_level_started()


func update_camera(delta: float, rotation_input: float, tilt_input: float):
	
	delta = delta / Engine.time_scale
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, tilt_lower_limit, tilt_upper_limit)
	mouse_rotation.y += rotation_input * delta
	
	%CameraRotationRoot.transform.basis = Basis.from_euler(mouse_rotation)
	%CameraRotationRoot.rotation.z = 0.0#lean_rotation#
	
	#shapecast_look_root.rotation.y = camera_rotation_root.rotation.y + PI
	
	#rotation_input = 0.0
	#tilt_input = 0.0


func move(direction: Vector3, delta, on_floor: bool):
	#rotate shapecast_move_root in direction of movement
	#shapecast_move_root.look_at(shapecast_move_root.global_position + Vector3(direction.x, 0, direction.z))
	#
	#var camera_forward = camera_rotation_root.transform.basis * Vector3.FORWARD
	#var camera_tilt_dot = camera_forward.dot(Vector3.UP)
	var xz_move = accelerate_in_direction(direction, delta, speed_mult)
	velocity.x = xz_move.x
	velocity.z = xz_move.z
	
	#var stepping_up = step_detect()
	#if stepping_up:
		#velocity.y = step_up_speed * delta * speed_mult
		#on_steps = true
		#
	#if !is_crouching: #check if temp crouch needed
		#camera_forward.y = 0
		#var camera_move_dot = camera_forward.normalized().dot(direction)
		#if camera_move_dot > 0.8:
			#if on_floor:
				#if auto_crouch && camera_tilt_dot < -0.45 && !shapecast_look_legs.is_colliding() && shapecast_look_head.is_colliding():
					#temp_crouch = true
					#crouch()
			#else:
				#if !stepping_up && shapecast_look_legs.is_colliding() && !shapecast_look_head.is_colliding():
					#temp_crouch = true
					#crouch()
	#else:
		#if temp_crouch && !shapecast_look_legs.is_colliding() && !shapecast_look_head.is_colliding():
			#try_uncrouch()
	#
	#if camera_tilt_dot > 0 && ledge_detect() && !is_jumping && !on_floor:
		#is_clambering = true
		#velocity.y = clamber_speed * delta
	#else: is_clambering = false
		#
	#update_head_bob(delta, on_floor || stepping_up)


func accelerate_in_direction(direction: Vector3, delta: float, mult: float) -> Vector3:
	var desired_velocity: Vector3 = direction * SPEED * mult
	var adjusted_velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * delta))
	return adjusted_velocity#Vector2(adjusted_velocity.x, adjusted_velocity.z)


func try_dash():
	#TO/DO if %RayCastEyes is hitting an enemy
	#	and enemy can be dashed
	#		dash that enemy
	#else do some piddly little half dash
	if %RayCastEyes.is_colliding():
		dash_enemy(%RayCastEyes.get_collider())
	#else:
		#dash_forward()


func dash_enemy(enemy: Object):
	if enemy == null || !(enemy.get_collision_layer() & 2):
		#dash_forward()
		return
	
	if abs(enemy.global_position.z - global_position.z) > vertical_dash_limit:
		return
		
	is_dashing = true
	if dash_tween != null:
		dash_tween.kill()
	kill_time_tween()
	dash_tween = create_tween()
	dash_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	dash_tween.chain()
	dash_tween.tween_property(self, "global_position", enemy.global_position, dash_speed)
	dash_tween.tween_callback(dash_end.bind(-%RayCastEyes.global_basis.z, true, enemy))
	
	jump_count = 1
	short_dash_count = 1


func dash_forward():
	if short_dash_count <= 0:
		return
	short_dash_count -= 1
	jump_count = 0
	
	is_dashing = true
	
	var move_vec: Vector3 = move_direction
	if move_vec == Vector3.ZERO:
		move_vec = -%RayCastEyes.global_basis.z
	var target_vec: Vector3 = move_vec * dash_distance
	#ShapeCast to intended position, stopping on shapecast collision and using distance as dash distance
	var shapecast: ShapeCast3D = %BodyShapeCast
	shapecast.target_position = target_vec
	shapecast.force_shapecast_update()
	if shapecast.is_colliding():
		var collision_frac: float = shapecast.get_closest_collision_safe_fraction()
		target_vec = target_vec * collision_frac
	if dash_tween != null:
		dash_tween.kill()
	kill_time_tween()
	dash_tween = create_tween()
	dash_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	dash_tween.chain()
	dash_tween.tween_property(self, "global_position", global_position + target_vec, dash_speed)
	dash_tween.tween_callback(dash_end.bind(move_vec * SPEED * 0.5))


func dash_end(final_velocity: Vector3, do_temporal_shift: bool = false, enemy: Object = null):
	is_dashing = false
	%BodyShapeCast.target_position = Vector3.ZERO
	
	
	
	if do_temporal_shift:
		temporal_shift()
		velocity = Vector3.ZERO
		velocity.y = dash_pop
		last_velocity = Vector3.ZERO
	else: #is just dash forward
		velocity = final_velocity
		last_velocity = final_velocity
	
	if enemy != null:
		for child in enemy.get_children():
			if child is DeathComponent:
				child.die(final_velocity)
				break


func temporal_shift():
	if time_tween != null:
		time_tween.kill()
	Engine.time_scale = 0.1
	time_tween = create_tween()
	time_tween.chain()
	time_tween.tween_property(self, "scale", Vector3.ONE, slow_time_duration)
	gravity_mult = 0.1
	time_tween.set_parallel()
	time_tween.tween_method(set_time_scale, 0.1, 1.0, slow_time_duration).set_ease(Tween.EASE_IN)
	#time_tween.tween_property(Engine, "time_scale", 1.0, 1.0).set_ease(Tween.EASE_IN)
	
	
	time_tween.tween_property(self, "gravity_mult", 1.0, slow_time_duration).set_ease(Tween.EASE_IN)


func set_time_scale(time_scale: float):
	Engine.time_scale = time_scale
	readjust_tween_time_scale(time_scale)


func readjust_tween_time_scale(time_scale: float):
	time_tween.set_speed_scale(1.0 / time_scale)


func kill_time_tween():
	if time_tween != null:
		time_tween.kill()
	Engine.time_scale = 1.0
	gravity_mult = 1.0


func check_eye_ray():
	if !%RayCastEyes.is_colliding():
		%Crosshair.modulate = Color.WHITE
		effect_enemy_outline(false)
	else:
		var collider = %RayCastEyes.get_collider()
		if (collider.get_collision_layer() & 2):
			if current_enemy != collider:
				effect_enemy_outline(false)
				current_enemy = collider
				for child in collider.get_children():
					if child is Outliner:
						enemy_outliner = child
						break
			%Crosshair.modulate = Color.RED
			effect_enemy_outline(true)
			#set outline on next_pass shader of enemy material
			
		else: 
			%Crosshair.modulate = Color.WHITE
			effect_enemy_outline(false)


func effect_enemy_outline(setting: bool):
	if enemy_outliner == null: return
	
	enemy_outliner.set_mesh_outlines(setting)
	
	if !setting:
		enemy_outliner = null
		current_enemy = null
