extends Node

@export_group("Music Settings")
@export var music_player: AudioStreamPlayer2D

@export var pause_duck_music_percent: float = .5

@export_group("SFX Settings")
@export var level_started_sound: AudioStream
@export_range(-12, 12) var level_started_gain: float;

@export var level_finish_sound: AudioStream
@export_range(-12, 12) var level_finished_gain: float;

@export var player_jump_sound: AudioStream
@export_range(-12, 12) var player_jump_gain: float;


@export var player_dash_sound: AudioStream
@export_range(-12, 12) var player_dash_sound_gain: float;

@export var player_enemy_dash_sound: AudioStream
@export_range(-12, 12) var player_enemy_dash_sound_gain: float;

@export var restarting_sound: AudioStream
@export_range(-12, 12) var restarting_sound_gain: float;

@export var long_fall_sound: AudioStream
@export_range(-12, 12) var long_fall_sound_gain: float;


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
	GameEvents.player_dash.connect(play_player_dash)
	GameEvents.player_enemy_dash.connect(play_player_enemy_dash)
	GameEvents.restarting.connect(play_restarting)
	GameEvents.long_fall_started.connect(play_long_fall)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func play_level_started():
	play_2D_sound(level_started_sound, level_started_gain)

func play_level_finished():
	play_2D_sound(level_finish_sound)

func play_player_jumped(world_position: Vector3):
	play_3D_sound(world_position, player_jump_sound, player_jump_gain)

func play_player_dash():
	play_2D_sound(player_dash_sound)

func play_player_enemy_dash():
	play_2D_sound(player_enemy_dash_sound)

func play_restarting():
	play_2D_sound(restarting_sound)

func play_long_fall():
	play_2D_sound(long_fall_sound)




func play_3D_sound(world_position: Vector3, file_to_play: Resource, gain:float=0.0):
	var  player = AudioStreamPlayer3D.new()
	player.stream = file_to_play
	player.position = world_position
	player.volume_db = gain
	add_child(player)
	player.play()
	await player.finished
	player.queue_free()

func play_2D_sound(file_to_play: Resource, gain:float = 0.0):
	var  player = AudioStreamPlayer2D.new()
	player.stream = file_to_play
	player.volume_db = gain
	add_child(player)
	player.play()
	await player.finished
	player.queue_free()
