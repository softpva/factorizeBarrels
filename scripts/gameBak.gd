extends Node

onready var felpudo = get_node("Felpudo")
onready var barrisAtivos = get_node("BarrisAtivos")
onready var barraDeTempo = get_node("BarraDeTempo")
onready var tabua = get_node("tabua")

const JOGANDO = true
const PERDEU = false
const LADO_ESQUERDO = -1
const CENTRO = 0
const LADO_DIREITO = 1
const LARGURA_TONEL = 180

var barrilAnteriorEraInimigo = false
var estado = JOGANDO
var primos = [2,2,2,3,3,5,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]
var fatore = 2
var fatoracao= []
var result = 1

func _ready():
	randomize()
	set_process_input(true)
	gerarBarrisIniciais()
	barraDeTempo.connect("perdeu", self, "perder")
	tabua.connect("venceu",self,"acertouFatoracao")
	aFatorarDe2a99()

func aFatorarDe2a99():
	fatore = int(rand_range(2,99))
	get_node("Control/Fatore").set_text(str(fatore))
	inserirTabuaFatores(fatore)

func acertouFatoracao():
	print("Acertou")

func _input(event):
	var barrilDeBaixo = barrisAtivos.get_children()[0]
	if verificarToqueNaTela(event):
		var tocou = tocouTela(event)
		if tocou == LADO_ESQUERDO:
			felpudo.moverParaEsquerda()
		elif tocou == LADO_DIREITO:
			felpudo.moverParaDireita()
		else:
			var val = int(barrilDeBaixo.get_node("Primo").get_text())
			fatorar(val)
			print("CENTRO")
		if aindaEstaVivo():
			felpudo.bater()
			barrisAtivos.remove_child(barrilDeBaixo)
			get_node("BarrisADestruir").add_child(barrilDeBaixo)
			if tocou == CENTRO:
				barrilDeBaixo.absorver()
			else:
				barrilDeBaixo.deslocarEDestruir(felpudo.lado)
			gerarNovoBarril(true,Vector2(290, 1090 - 6*172))
			descerPilhaDeBarris()
			barraDeTempo.add(0.03)
			if !aindaEstaVivo():
				perder()
		else:
			perder()

func tocouTela(event):
	if event.pos.x < get_viewport().get_size_override().x/2-LARGURA_TONEL/2:
		return LADO_ESQUERDO
	elif event.pos.x > get_viewport().get_size_override().x/2+LARGURA_TONEL/2:
		return LADO_DIREITO
	else:
		return CENTRO

func verificarToqueNaTela(event):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and JOGANDO:
		return true
	else:
		return false

func aindaEstaVivo():
	var lado = felpudo.lado
	var barrilDeBaixo = barrisAtivos.get_children()[0]
	if lado == felpudo.ESQUERDA and barrilDeBaixo.is_in_group("barrilEsq") or \
			lado == felpudo.DIREITA and barrilDeBaixo.is_in_group("barrilDir"):
		return false
	else:
		return true

func getPrime():
	var val = 0
	while(true):
		val = primos[int(rand_range(0,22))]
		if ( val <= fatore):
			return val

func fatorar(val):
	var strFatoracao = ""
	if val == 0:
		fatoracao.remove(fatoracao.size()-1)
	else:
		fatoracao.append(val)
	if ! fatoracao.empty():
		if fatoracao.size() != 1:
			result = 1
			strFatoracao = ""
			for num in fatoracao:
				result *= num
				strFatoracao +=  str(num) + "x"
			strFatoracao= strFatoracao.substr(0,strFatoracao.length()-1)
		else:
			result = fatoracao[0]
			strFatoracao = str(result)
		strFatoracao += " = " + str(result)
	get_node("Control/Fatoracao").set_text(strFatoracao)
	inserirTabuaFatores(val)

func inserirTabuaFatores(val):
	""" 
	ie: 
	fatoracao=[2,2,5] // coluna 2
	fatore = 30 
	resto= [30%2,resto[i-1]%2,resto[i-2]%5] // se resto[n] !=0 ins(BUM!) em res e break
	res = [30,30/2,resto[i-1]/2,resto[i-2]/5] // coluna 1
	30/2=15 30%2=0
	15/2=7  15%2=1 BUM!	
	"""
	var tabua = get_node("tabua")
	var Fat = preload("res://scenes/fatores.tscn")
	var coluna1 = []
	for i in tabua.get_children():
		tabua.remove_child(i)
	coluna1.clear()
	coluna1.append(fatore)
	var fat = Fat.instance()
	fat.setText(str(coluna1[0]))
	tabua.add_child(fat)
	for i in range(fatoracao.size()):
		var fat1 = Fat.instance()
		fat1.tipo = 1
		var fat2 = Fat.instance()
		fat2.tipo = 2
		if coluna1[i] % fatoracao[i] != 0 :
			coluna1.append("BUM")
			fat1.tipo = 3
		else:
			coluna1.append(coluna1[i] / fatoracao[i])
		fat1.set_pos(Vector2(0,64*(i+1)))
		fat2.set_pos(Vector2(0,64*i))
		fat1.setText(str(coluna1[i+1]))
		fat2.setText(str(fatoracao[i]))
		tabua.add_child(fat1)
		tabua.add_child(fat2)
		if fat1.tipo == 3:
			break
		

	print("coluna1: ", coluna1)

#	for i in range(fatoracao.size()):
#		fat1 = Fat.instance()
#		fat1.set_pos(Vector2(0,64*i))
#		fat2 = Fat.instance()
#		fat2.set_pos(Vector2(0,64*i))
#		if i == 0:
#			coluna1.append(fatore)
#		else:
#			coluna1.append(coluna1[i-1]/val)
#		fat1.tipo = 1
#		fat1.get_node("sprite/label").set_text(str(coluna1[i]))
#		tabua.add_child(fat1)
#		fat2.tipo = 2
#		fat2.get_node("sprite/label").set_text(str(fatoracao[i]))
#		tabua.add_child(fat2)

func gerarNovoBarril(isRand, pos):
	var tonel = load("res://scenes/tonel.tscn")
	var tipoDeBarril
	var novoBarril
	if isRand:
		tipoDeBarril = int(rand_range(-1.99, 1.99))
	else:
		tipoDeBarril = 0
	if barrilAnteriorEraInimigo:
		tipoDeBarril = 0
	if tipoDeBarril == 0:
		novoBarril = tonel.instance()
		barrilAnteriorEraInimigo = false
	elif tipoDeBarril == -1:
		novoBarril = tonel.instance()
		novoBarril.tipo = novoBarril.INIMIGO_ESQUERDO
		novoBarril.add_to_group("barrilEsq")
		barrilAnteriorEraInimigo = true
	elif tipoDeBarril == 1:
		novoBarril = tonel.instance()
		novoBarril.tipo = novoBarril.INIMIGO_DIREITO
		novoBarril.add_to_group("barrilDir")
		barrilAnteriorEraInimigo = true
	if int(rand_range(0,2)) == 0 and isRand:
		novoBarril.get_node("Primo").set_text(str(getPrime()))
	else:
		novoBarril.get_node("Primo").set_text("")
	novoBarril.set_pos(pos)
	barrisAtivos.add_child(novoBarril)
	
func gerarBarrisIniciais():
	for i in range(0, 3):
		gerarNovoBarril(false, Vector2(290, 1090 - i*172))
	for i in range(3, 6):
		gerarNovoBarril(true, Vector2(290, 1090 - i*172))

func descerPilhaDeBarris():
	for b in barrisAtivos.get_children():
		b.set_pos(b.get_pos() + Vector2(0, 172))
		
func perder():
	felpudo.morrer()
	barraDeTempo.set_process(false)
	estado = PERDEU
	get_node("Timer").start()

func _on_Timer_timeout():
	get_tree().reload_current_scene()


func _on_baterEsquerda_pressed():
	pass # replace with function body


func _on_baterCentro_pressed():
	pass # replace with function body


func _on_baterDireita_pressed():
	pass # replace with function body
