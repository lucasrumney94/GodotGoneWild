extends CharacterBody3D

@export var mouse_sensitivity: float = 0.5
@export var tilt_lower_limit: float = deg_to_rad((-89))
@export var tilt_upper_limit: float = deg_to_rad(89)

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5

@export var dash_distance: float = 5
@export var enemy_dash_distance: float = 10

var mouse_rotation: Vector3

var is_jumping: bool = false
var is_dashing: bool = false

var acceleration: float = 5
var current_acceleration: float = 0.0
var speed_mult: float = 1.0
var last_velocity: Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


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
			try_dash()


func _process(delta):
	check_eye_ray()


func _physics_process(delta):
	if is_dashing: 
		#move_and_slide()
		return
	
	var on_floor: bool = is_on_floor()
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
		velocity.y -= gravity * delta
		last_velocity = velocity
		if is_jumping && velocity.y < 0:
			is_jumping = false
		#if on_steps && velocity.y < -5:
			#on_steps = false
	#else:
		#if crouched_up:
			#animation_player.play("crouch_reset")
			#GameEvents.emit_player_crouch(false)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and on_floor:
		velocity.y = JUMP_VELOCITY
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


func update_camera(delta: float, rotation_input: float, tilt_input: float):
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, tilt_lower_limit, tilt_upper_limit)
	mouse_rotation.y += rotation_input * delta
	
	%CameraRotationRoot.transform.basis = Basis.from_euler(mouse_rotation)
	%CameraRotationRoot.rotation.z = 0.0#lean_rotation#
	
	#shapecast_look_root.rotation.y = camera_rotation_root.rotation.y + PI
	
	rotation_input = 0.0
	tilt_input = 0.0


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
	#TODO if %RayCastEyes is hitting an enemy
	#	and enemy can be dashed
	#		dash that enemy
	#else do some piddly little half dash
	if %RayCastEyes.is_colliding():
		dash_enemy(%RayCastEyes.get_collider())
	else:
		dash_forward()


func dash_enemy(enemy: Object):
	if enemy == null || !(enemy.get_collision_layer() & 2):
		dash_forward()
		return
		
	is_dashing = true
	var tween: Tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.chain()
	tween.tween_property(self, "global_position", enemy.position, 0.3)
	tween.tween_callback(dash_end)


func dash_forward():
	is_dashing = true
	
	var target_vec: Vector3 = -%RayCastEyes.global_basis.z * dash_distance
	#ShapeCast to intended position, stopping on shapecast collision and using distance as dash distance
	var shapecast: ShapeCast3D = %BodyShapeCast
	shapecast.target_position = target_vec
	shapecast.force_shapecast_update()
	if shapecast.is_colliding():
		var collision_frac: float = shapecast.get_closest_collision_safe_fraction()
		target_vec = target_vec * collision_frac
	var tween: Tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.chain()
	tween.tween_property(self, "global_position", global_position + target_vec, 0.3)
	tween.tween_callback(dash_end)


func dash_end():
	is_dashing = false
	%BodyShapeCast.target_position = Vector3.ZERO
	#TODO possibly start a brief temporal slowdown


func check_eye_ray():
	if !%RayCastEyes.is_colliding():
		%Crosshair.modulate = Color.WHITE
	else:
		var collider = %RayCastEyes.get_collider()
		if (collider.get_collision_layer() & 2):
			%Crosshair.modulate = Color.RED
		else: %Crosshair.modulate = Color.WHITE
