extends Node

# Nexts: 
#   refactor nodes, scenes and scripots; remodelar para  além de fatorar somar, multiplicar


onready var felpudo = get_node("Felpudo")
onready var barrisAtivos = get_node("BarrisAtivos")
onready var barraDeTempo = get_node("BarraDeTempo")
onready var tabua = get_node("tabua")


const JOGANDO = true
const PARADO = false
const COM_SOM = true
const SEM_SOM = false
const LADO_ESQUERDO = -1
const CENTRO = 0
const LADO_DIREITO = 1
const LARGURA_TONEL = 180

var barrilAnteriorEraInimigo = false
var estado = JOGANDO
var primos = [2,2,2,3,3,5,5]
var naoPrimos = [] # preencher ao gerar primos
var som = COM_SOM
var fatore = 2
var fatoracao= []
var result = 1
var ladoDoToque
var ultimofator = fatore
var fase
var fases = {
	fase1 = {
		velocidade = 0.02,
		fatorarFim = 50
		},
	fase2 = {
		velocidade = 0.03,
		fatorarFim = 99
		},
	fase3 = {
		velocidade = 0.04,
		fatorarFim = 200
		},
	fase4 = {
		velocidade = 0.05,
		fatorarFim = 400
		},
	fase5 = {
		velocidade = 0.05,
		fatorarFim = 600
		},
	fase6 = {
		velocidade = 0.05,
		fatorarFim = 999
		}
	}

func _ready():
	fase = fases.fase1
	gerarPrimos()
	randomize()
	gerarBarrisIniciais()
	barraDeTempo.connect("perdeu", self, "perder")
	aFatorar()
	if ! chkLock():
		estado = PARADO


func _on_Timer_2_timeout():
	fatoracao.clear()
	fatoracao.clear()
	estado= JOGANDO
	var node = get_node("BarrisAtivos").get_children()
	for b in node:
		b.queue_free()
	node = get_node("tabua").get_children()
	for b in node:
		b.queue_free()
	if fase == fases.fase1:
		get_node("premios/premio1").set_hidden(false)
		fase = fases.fase2
	elif fase == fases.fase2:
		get_node("premios/premio2").set_hidden(false)
		fase = fases.fase3
	elif fase == fases.fase3:
		get_node("premios/premio3").set_hidden(false)
		fase = fases.fase4
	elif fase == fases.fase4:
		get_node("premios/premio4").set_hidden(false)
		fase = fases.fase5
	elif fase == fases.fase5:
		get_node("premios/premio5").set_hidden(false)
		fase = fases.fase6
		pass
	gerarPrimos()
	gerarBarrisIniciais()
	if som == COM_SOM:
		get_node("sound").play("passouFase")
	get_node("BarraDeTempo").set_process(true)
	get_node("Control/Fatoracao").set_text("")
	aFatorar()


func gerarPrimos():
	var totalDivisores
	for i in range(fase.fatorarFim+1):
		totalDivisores = 0
		for j in range(1,i+1):
			if (i % j == 0):
				totalDivisores+=1
		if(totalDivisores == 2):
			primos.append(i)
	print("Primos gerados: ", primos)
	
	
func chkLock():
	var aux = OS.get_datetime()
	if ( aux['month'] <= 06 and aux['year'] == 2023):
		return(true)
	else:
		var msg = get_node("Control/Fatoracao")
		msg.set_scale(Vector2(.6,.7))
		msg.set_text("EXPIROU...edu4u.games@gmail.com")
		return(false)

func aFatorar():
	randomize()
	fatore = int(rand_range(2,fase.fatorarFim))
	if primos.has(fatore):
		fatore+=1
#	get_node("Control/Fatore").set_text(str(fatore))
	ultimofator=int(fatore)
	inserirTabuaFatores(fatore)

func ganhouJogo():
	if som == COM_SOM:
		get_node("sound").play("ganhou")
	var msg = get_node("Control/Fatoracao")
	estado = PARADO
	msg.set_text(msg.get_text() + " GANHOU!!!")
	get_node("Timer").start()
	
func passouDeFase():
	if som == COM_SOM:
		get_node("sound").play("passouFase2")
	get_node("BarraDeTempo").perc = 1
	get_node("BarraDeTempo").set_process(false)
	var msg = get_node("Control/Fatoracao")
	estado = PARADO
	msg.set_text(msg.get_text() + " ACERTOU!!!")
	get_node("Timer2").start()
	

func _on_baterEsquerda_pressed():
	if estado == JOGANDO:
		ladoDoToque=LADO_ESQUERDO
		if som == COM_SOM:
			get_node("sound").play("bater")
		felpudo.moverParaEsquerda()
		aindaEstaVivo()


func _on_baterCentro_pressed():
	if estado == JOGANDO:
		ladoDoToque=CENTRO
		if som == COM_SOM:
			get_node("sound").play("pegou")
		var barrilDeBaixo = barrisAtivos.get_children()[0]
		var val = int(barrilDeBaixo.get_node("Primo").get_text())
		fatorar(val)
		aindaEstaVivo()


func _on_baterDireita_pressed():
	if estado == JOGANDO:
		ladoDoToque=LADO_DIREITO
		if som == COM_SOM:
			get_node("sound").play("bater")
		felpudo.moverParaDireita()
		aindaEstaVivo()

func aindaEstaVivo():
	var lado = felpudo.lado
	var barrilDeBaixo = barrisAtivos.get_children()[0]
	if lado == felpudo.ESQUERDA and barrilDeBaixo.is_in_group("barrilEsq") or \
			lado == felpudo.DIREITA and barrilDeBaixo.is_in_group("barrilDir"):
		perder()
	else:
		felpudo.bater()
		barrisAtivos.remove_child(barrilDeBaixo)
		get_node("BarrisADestruir").add_child(barrilDeBaixo)
		if ladoDoToque == CENTRO:
			barrilDeBaixo.absorver()
		else:
			barrilDeBaixo.deslocarEDestruir(felpudo.lado)
		gerarNovoBarril(true,Vector2(290, 1090 - 6*172))
		descerPilhaDeBarris()
		barraDeTempo.add(0.03)
		barrilDeBaixo = barrisAtivos.get_children()[0]
		if lado == felpudo.ESQUERDA and barrilDeBaixo.is_in_group("barrilEsq") or \
			lado == felpudo.DIREITA and barrilDeBaixo.is_in_group("barrilDir"):
			perder()

func getPrimo():
	var val = 0
	while(true):
		val = primos[int(rand_range(0,primos.size()))]
		if ( val <= ultimofator):
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
		strFatoracao += "=" + str(result)
	get_node("Control/Fatoracao").set_text(strFatoracao)
	inserirTabuaFatores(val)

func inserirTabuaFatores(val):
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
			if som == COM_SOM:
				get_node("sound").play("whenBum")
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
		if fat1.getText() == '1':
			if fase == fases.fase6:
				ganhouJogo()
			else:
				passouDeFase()
			break 
		if fat1.tipo == 3:
			break
	if int(coluna1.back()) > 1:
		ultimofator = coluna1.back()

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
		novoBarril.get_node("Primo").set_text(str(getPrimo()))
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
	if som == COM_SOM:
		get_node("sound").play("perdeu")
	felpudo.morrer()
	barraDeTempo.set_process(false)
	get_node("Control/Fatoracao").set_text("Ohhh...Você perdeu!")
	estado = PARADO
	get_node("Timer").start()
	

func _on_Timer_timeout():
	pass
	get_tree().reload_current_scene()


	
