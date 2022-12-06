# Esse script deve ser configurado como <Auto Load>
# Configure-me em Projeto -> Configurações do Projeto -> AutoLoad
extends Node

var ENet = NetworkedMultiplayerENet.new()
#Igual ao do servidor
var port : int = 42069
#IP da máquina que o servidor está ligado (no nosos caso, localhost)
var ip : String = "127.0.0.1"
var connected : bool = false

func connectToServer():
	print("TENTANDO INICIAR CONEXAO")
	#Prepara a estrutura do cliente
	ENet.create_client(ip,port)
	#Setter (get/set) de um ponto de conexão para preparar o servidor RPC
	get_tree().set_network_peer(ENet)
	#Associa uma função a um sinal (bind)
	ENet.connect('connection_failed', self, '_OnConexaoFalhou')
	ENet.connect('connection_succeeded', self, '_OnConexaoSucesso')
	
func _OnConexaoFalhou():
	print("Can't find the server!")
	print("Trying to reconnect to ", ip, port)
	get_tree().set_network_peer(ENet)
	
func _OnConexaoSucesso():
	print("Just connected to server!")
	connected = true
	
#id 1 para enviar direto ao server (focar em enviar sempre para o server)
func _get_player_pos(var motion, var direction, var node_id):
	rpc_id(1, "_get_player_pos", motion, direction, node_id)
	
remote func _set_player_pos(var server_motion, var node_id, var player_num, var sender_id):
	var player1 = get_node('/root/Main/Main/Player').get_instance_id()
	var player2 = get_node('/root/Main/Main/@Player@2').get_instance_id()
	
	# if sender_id == get_tree().get_network_unique_id():
	print('Eu sou o player ', sender_id, ' e estou executando a acao')
	var node_p1_object = instance_from_id(player1)
	node_p1_object.motion = server_motion
	var node_p2_object = instance_from_id(player2)
	node_p2_object.motion = server_motion

remote func _instance_players(var players):
	for player in players:
		print(player)
	Global.loadPlayer(get_node('/root/Main/Main'), "soma", Vector2(300,60), 1)
	Global.loadPlayer(get_node('/root/Main/Main'), "julius", Vector2(800,60), 2)
		
	Global.loadCamera(get_node('/root/Main/Main'), "cameraByPlayer", 1, 1500, 1000, -1)
