extends Node

@export_group("Music Settings")
@export var music_player: AudioStreamPlayer2D
@export var music_player_gain: float = 0.0
@export var music_player_pause_gain: float = 3.0

@export_group("SFX Settings")
@export var level_started_sound: AudioStream
@export_range(-12, 12) var level_started_gain: float

@export var level_finish_sound: AudioStream
@export_range(-12, 12) var level_finished_gain: float

@export var player_jump_sound: Array[AudioStream] = []
@export_range(-24, 12) var player_jump_gain: float

@export var player_hit_floor_sound: AudioStream
@export_range(-24,12) var player_hit_floor_gain: float

@export var player_dash_sound: AudioStream
@export_range(-12, 12) var player_dash_sound_gain: float

@export var player_enemy_dash_sound: AudioStream
@export_range(-12, 12) var player_enemy_dash_sound_gain: float

@export var restarting_sound: AudioStream
@export_range(-12, 12) var restarting_sound_gain: float

@export var long_fall_sound: AudioStream
@export_range(-12, 12) var long_fall_sound_gain: float

@export var projectile_impact_sound: AudioStream
@export_range(-12, 12) var projectile_impact_sound_gain: float

@export var crystal_impact_sound: AudioStream
@export_range(-36, 12) var crystal_impact_sound_gain: float

@export var player_footstep_sounds: Array[AudioStream] = []
@export_range(-36, 12) var player_footstep_sound_gain: float


@export var low_pass_normal_cutoff:float = 8000
##@export var low_pass_slomo_cutoff:float = 80
@export var pitch_shift_normal_pitch_scale:float = 1.0
##@export var pitch_shift_slomo_pitch_scale:float = 0.5
##@export var slomo_effect_length:float = .8

@export var low_pass_cutoff_lower_bound:float = 400
@export var pitch_shift_cutoff_lower_bound:float = .4

var long_fall_target_volume:float = 0.0
var long_fall_low_volume:float = -128.
var long_fall_audio_stream: AudioStreamPlayer2D

var sfx_index: int
var sfx_lowpass: AudioEffectLowPassFilter
var sfx_pitchshift: AudioEffectPitchShift

var music_index: int
var music_lowpass: AudioEffectLowPassFilter
var music_pitchshift: AudioEffectPitchShift


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Defer the call to the end to init, as this depends on other systems
	Callable(init).call_deferred()

func init() -> void:
	print("AUDIO: Audio Controller Active")
	print("AUDIO: Starting Music")
	music_player.play()

	print("AUDIO: Registering all SFX")
	GameEvents.level_started.connect(play_level_started)
	GameEvents.level_finished.connect(play_level_finished)
	GameEvents.player_jump.connect(play_player_jumped)
	GameEvents.player_hit_floor.connect(play_player_hit_floor)
	GameEvents.player_dash.connect(play_player_dash)
	GameEvents.player_enemy_dash.connect(play_player_enemy_dash)
	GameEvents.restarting.connect(play_restarting)
	GameEvents.long_fall_started.connect(play_long_fall)
	GameEvents.projectile_impact.connect(play_projectile_impact)
	GameEvents.crystal_impact.connect(play_crystal_impact)
	GameEvents.footstep.connect(play_footstep)
	
	sfx_index = AudioServer.get_bus_index("effects")
	#print("sfx index is ", sfx_index)
	sfx_lowpass = AudioServer.get_bus_effect(sfx_index,0)
	sfx_pitchshift = AudioServer.get_bus_effect(sfx_index,1)

	music_index = AudioServer.get_bus_index("music")
	#print("music index is ", music_index)
	music_lowpass = AudioServer.get_bus_effect(music_index,0)
	music_pitchshift = AudioServer.get_bus_effect(music_index,1)

	long_fall_target_volume = long_fall_low_volume
	long_fall_audio_stream = AudioStreamPlayer2D.new()
	long_fall_audio_stream.stream = long_fall_sound
	long_fall_audio_stream.volume_db = long_fall_low_volume
	long_fall_audio_stream.bus = "effects"
	long_fall_audio_stream.ProcessMode.PROCESS_MODE_ALWAYS
	add_child(long_fall_audio_stream)
	long_fall_audio_stream.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# React to being paused
	if (get_tree().paused):
		music_player.volume_db = music_player_pause_gain;
		long_fall_audio_stream.volume_db = long_fall_low_volume
	else:
		music_player.volume_db = music_player_gain;
		long_fall_audio_stream.volume_db = lerp(long_fall_audio_stream.volume_db, long_fall_target_volume, 0.3)


	sfx_lowpass.cutoff_hz = remap(Engine.time_scale, 0. ,1.0,low_pass_cutoff_lower_bound, low_pass_normal_cutoff)
	sfx_pitchshift.pitch_scale = remap(Engine.time_scale, 0. ,1.0,pitch_shift_cutoff_lower_bound,pitch_shift_normal_pitch_scale)
	music_lowpass.cutoff_hz = remap(Engine.time_scale, 0. ,1.0,low_pass_cutoff_lower_bound,low_pass_normal_cutoff)
	music_pitchshift.pitch_scale = remap(Engine.time_scale, 0. ,1.0,pitch_shift_cutoff_lower_bound,pitch_shift_normal_pitch_scale)

	#print(sfx_lowpass.cutoff_hz," ",sfx_pitchshift.pitch_scale)


func play_projectile_impact(world_position: Vector3):
	play_3D_sound(world_position, projectile_impact_sound, projectile_impact_sound_gain, "effects")

func play_level_started():
	play_2D_sound(level_started_sound, level_started_gain, "effects")

func play_level_finished():
	play_2D_sound(level_finish_sound, level_finished_gain, "effects")

func play_player_jumped(world_position: Vector3):	
	play_3D_sound_random_pitch(world_position, player_jump_sound.pick_random(), player_jump_gain, 0.96, 1.04, "effects")

func play_player_hit_floor(world_position: Vector3):
	play_3D_sound(world_position, player_hit_floor_sound, player_hit_floor_gain, "effects")
	long_fall_target_volume = long_fall_low_volume
	long_fall_audio_stream.volume_db = long_fall_low_volume

func play_player_dash():
	play_2D_sound(player_dash_sound,player_dash_sound_gain)
	long_fall_target_volume = long_fall_low_volume
	long_fall_audio_stream.volume_db = long_fall_low_volume

func play_crystal_impact(world_position: Vector3):
	#print("Playing Crystal Impact")
	play_3D_sound_random_pitch(world_position, crystal_impact_sound, crystal_impact_sound_gain, .7, 1.7, "effects")

func play_player_enemy_dash():
	# change lowpass on slow time	
	#print("enemy dash time scale SLOW", Time.get_ticks_msec())
	# sfx_lowpass.cutoff_hz = low_pass_slomo_cutoff;
	# music_lowpass.cutoff_hz = low_pass_slomo_cutoff;
	# sfx_pitchshift.pitch_scale = pitch_shift_slomo_pitch_scale
	# music_pitchshift.pitch_scale = pitch_shift_slomo_pitch_scale

	play_2D_sound(player_enemy_dash_sound,player_enemy_dash_sound_gain,"effects")
	#await get_tree().create_timer(slomo_effect_length).timeout
	#reset_pitch_and_cutoff()

	long_fall_target_volume = long_fall_low_volume
	long_fall_audio_stream.volume_db = long_fall_low_volume
	
# func reset_pitch_and_cutoff():
# 	sfx_lowpass.cutoff_hz = low_pass_normal_cutoff
# 	sfx_pitchshift.pitch_scale = pitch_shift_normal_pitch_scale
# 	music_lowpass.cutoff_hz = low_pass_normal_cutoff
# 	music_pitchshift.pitch_scale = pitch_shift_normal_pitch_scale
# 	print("enemy dash time scale NORMAL", Time.get_ticks_msec())

func play_restarting():
	play_2D_sound(restarting_sound,restarting_sound_gain,"effects")

func play_long_fall():
	# print("playing long fall sound")
	long_fall_target_volume = long_fall_sound_gain
	#play_2D_sound(long_fall_sound, long_fall_sound_gain)

func play_footstep(world_position: Vector3):
	play_3D_sound(world_position, player_footstep_sounds.pick_random(), player_footstep_sound_gain, "effects")


func play_3D_sound(world_position: Vector3, file_to_play: Resource, gain:float=0.0, bus:String="effects"):
	var  player = AudioStreamPlayer3D.new()
	player.stream = file_to_play
	player.bus = bus
	player.position = world_position
	player.volume_db = gain
	add_child(player)
	player.play()
	await player.finished
	player.queue_free()

func play_3D_sound_random_pitch(world_position: Vector3, file_to_play: Resource, gain:float=0.0, pitch_range_low:float=.8, pitch_range_high:float=1.2, bus:String="effects"):
	var  player = AudioStreamPlayer3D.new()
	player.stream = file_to_play
	player.position = world_position
	var rng = RandomNumberGenerator.new()
	player.pitch_scale = rng.randf_range(pitch_range_low, pitch_range_high)
	#print("pitch scale randomized to", player.pitch_scale)
	player.bus = bus
	player.volume_db = gain
	add_child(player)
	player.play()
	await player.finished
	player.queue_free()



func play_2D_sound(file_to_play: Resource, gain:float = 0.0, bus:String="effects"):
	var  player = AudioStreamPlayer2D.new()
	player.stream = file_to_play
	player.volume_db = gain
	player.bus = bus
	add_child(player)
	player.play()
	await player.finished
	player.queue_free()


# Plan
# play the sound at the start
# constantly set the volume in process with a lerp based on a target variable who is set by fall-start and player-landing
# 
