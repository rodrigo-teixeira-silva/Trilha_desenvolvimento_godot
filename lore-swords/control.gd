extends Control
@onready var contador_carne: Label = $MarginContainer/carne/Contador_carne as Label
@onready var contador_vidas: Label = $MarginContainer/vidas/Contador_VIDAS as Label
@onready var contagem_tempo: Label = $MarginContainer/tempo/contagem_tempo as Label
@onready var clock_timer: Timer = $clock_timer as Timer

var minutes = 0
var seconds = 0

@export_range (0,5) var default_minutes := 1
@export_range (0,59) var default_seconds := 0

signal time_is_up()

func _ready() -> void:
	contador_carne.text = str("%02d" % Globals.carne)
	contagem_tempo.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reset_clock_timer()
	
	
func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
	

func _process(delta: float) -> void:
	contador_carne.text = str("%02d" % Globals.carne)
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")


func _on_clock_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -=1
	contagem_tempo.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	
	
