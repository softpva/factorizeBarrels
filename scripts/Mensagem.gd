extends Node2D



func _ready():
	var arqTexto = File.new()
	arqTexto.open("res://testes/texto1.txt", arqTexto.READ)
	var conteudo = arqTexto.get_as_text()
	arqTexto.close()
	get_node("Sprite/rtlMsg").set_text(conteudo)
	
