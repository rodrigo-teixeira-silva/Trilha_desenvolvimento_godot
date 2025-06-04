extends Control
@onready var contador_carne: Label = $MarginContainer/carne/Contador_carne as Label
@onready var contador_vidas: Label = $MarginContainer/vidas/Contador_VIDAS as Label
@onready var contagem_tempo: Label = $MarginContainer/tempo/contagem_tempo as Label


func _ready() -> void:
	contador_carne.text = str(Globals.carne)


func _process(delta: float) -> void:
	contador_carne.text = str(Globals.carne)
