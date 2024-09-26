extends CanvasLayer

signal closing

@onready var master_volume_slider: Slider = %MasterVolumeSlider
@onready var sfx_slider: Slider = %SfxSlider
@onready var music_slider: Slider = %MusicSlider

@onready var mouse_sensitivity_slider: HSlider = %MouseSensitivitySlider
@onready var mouse_sensitivity_value: Label = %MouseSensitivityValue
@onready var slowmo_duration_slider: HSlider = %SlowmoDurationSlider
@onready var slowmo_duration_value: Label = %SlowmoDurationValue

@onready var invert_look_y_check_box: CheckBox = %InvertLookYCheckBox

#TODO add PlayerPrefs save support

var settings_changed: bool = false


func _ready():
	print("should be earning option achievement")
	AchievementControl.earn_achievement("view_options")

	%BackButton.pressed.connect(on_back_pressed)
	
	master_volume_slider.value = get_bus_volume_percent("Master")
	sfx_slider.value = get_bus_volume_percent("effects")
	music_slider.value = get_bus_volume_percent("music")
	
	master_volume_slider.value_changed.connect(on_audio_slider_changed.bind("Master"))
	master_volume_slider.drag_ended.connect(on_effects_volume_dragged)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("effects"))
	sfx_slider.drag_ended.connect(on_effects_volume_dragged)
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	
	mouse_sensitivity_slider.value = Settings.mouse_sensitivity
	mouse_sensitivity_value.text = str(Settings.mouse_sensitivity)
	slowmo_duration_slider.value = Settings.slowdown_duration
	slowmo_duration_value.text = str(Settings.slowdown_duration)
	
	mouse_sensitivity_slider.value_changed.connect(on_mouse_sensitivity_changed)
	slowmo_duration_slider.value_changed.connect(on_slowmo_duration_changed)
	
	invert_look_y_check_box.button_pressed = Settings.invert_look_y
	invert_look_y_check_box.toggled.connect(on_invert_look_y_toggled)
	
	var display_mode = DisplayServer.window_get_mode()
	%FullscreenButton.button_pressed = display_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	%WindowedButton.button_pressed = display_mode == DisplayServer.WINDOW_MODE_WINDOWED
	%WindowedFullscreenButton.button_pressed = display_mode == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	%FullscreenButton.pressed.connect(on_fullscreen_pressed)
	%WindowedButton.pressed.connect(on_windowed_pressed)
	%WindowedFullscreenButton.pressed.connect(on_windowed_fullscreen_pressed)
	
	%BackButton.grab_focus()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		Callable(on_back_pressed).call_deferred()


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume(volume_percent: float, bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_percent))


func on_audio_slider_changed(new_value: float, bus_name: String):
	set_bus_volume(new_value, bus_name)
	PlayerPrefs.update_setting("audio_" + bus_name, new_value)
	settings_changed = true


func on_effects_volume_dragged(_changed: bool):
	$AudioStreamPlayer.play()


func on_mouse_sensitivity_changed(new_value: float):
	Settings.mouse_sensitivity = new_value
	mouse_sensitivity_value.text = str(new_value)
	PlayerPrefs.update_setting("mouse_sensitivity", new_value)
	settings_changed = true


func on_slowmo_duration_changed(new_value: float):
	Settings.slowdown_duration = new_value
	slowmo_duration_value.text = str(new_value)
	PlayerPrefs.update_setting("slowdown_duration", new_value)
	settings_changed = true


func on_invert_look_y_toggled(toggled_on: bool):
	Settings.invert_look_y = toggled_on
	PlayerPrefs.update_setting("invert_look_y", int(toggled_on))
	settings_changed = true


func on_fullscreen_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		%WindowedButton.button_pressed = false
		%WindowedFullscreenButton.button_pressed = false
	
	%FullscreenButton.button_pressed = true
	
	PlayerPrefs.update_setting("display_mode", DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN as int)
	settings_changed = true


func on_windowed_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_WINDOWED:
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if DisplayServer.screen_get_size().x > 1280:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		%FullscreenButton.button_pressed = false
		%WindowedFullscreenButton.button_pressed = false
	
	%WindowedButton.button_pressed = true
	
	PlayerPrefs.update_setting("display_mode", DisplayServer.WINDOW_MODE_WINDOWED as int)
	settings_changed = true


func on_windowed_fullscreen_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		%WindowedButton.button_pressed = false
		%FullscreenButton.button_pressed = false
	
	%WindowedFullscreenBwwwutton.button_pressed = true
	
	PlayerPrefs.update_setting("display_mode", DisplayServer.WINDOW_MODE_FULLSCREEN as int)
	settings_changed = true


func on_back_pressed():
	if (get_bus_volume_percent("music")<0.01):
		AchievementControl.earn_achievement("bad_music")
	
	if settings_changed:
		PlayerPrefs.save()
		
	closing.emit()
	queue_free()
