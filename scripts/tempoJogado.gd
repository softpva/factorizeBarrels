extends Label

var tempo = 0

func _ready():
	get_node("tmTempoJogado").start()

func _on_tmTempoJogado_timeout():
	tempo +=1
	set_text(str(int(tempo)))