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
sync func _get_player_pos(var motion, var direction):
	rpc_id(1, "_get_player_pos", motion, direction)
