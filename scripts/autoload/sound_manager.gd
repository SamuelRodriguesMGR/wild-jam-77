extends Node

var _sound_on: bool = true
var _music_on: bool = true
var _sfx_on: bool = true

func is_sound_on() -> bool:
	return _sound_on

func is_music_on() -> bool:
	return _music_on

func is_sfx_on() -> bool:
	return _sfx_on

func turn_on_sound() -> void:
	_sound_on = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func turn_off_soun() -> void:
	_sound_on = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func turn_on_music() -> void:
	_music_on = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)

func turn_off_music() -> void:
	_music_on = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)

func turn_on_sfx() -> void:
	_sfx_on = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)

func turn_off_sfx() -> void:
	_sfx_on = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
