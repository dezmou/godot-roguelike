extends Control

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")

var infos;
var player;

var add1Price
var add5Price
var add10Price

func _ready():
	pass

func checkGold():
	$Add1.disabled = player.gold < add1Price
	$Add5.disabled = player.gold < add5Price
	$Add10.disabled = player.gold < add10Price

func init(monster : PackedScene, index : int):
	var inst = monster.instantiate()
	position.x = (size.x * (float(index) * 1.3)) 
	player = Main.players[Types.YOU]
	infos = inst.infos
	inst.queue_free()
	add1Price = infos.gold;
	add5Price = int((float(infos.gold) * 5.0) * 0.85)
	add10Price = int((float(infos.gold) * 10.0) * 0.70)
	
	$Image.texture = infos["card"]["image"]
	
	$Add1.text = "Add 1\n$" + str(infos.gold)
	$Add1.disabled = true
	$Add1.pressed.connect(func(): 
		player.spawnQueue[infos.name] += 1
		player.gold += -add1Price
		Main.calculateGold()
	)
	
	$Add5.text = "Add 5\n$" + str(add5Price)
	$Add5.disabled = true
	$Add5.pressed.connect(func(): 
		player.spawnQueue[infos.name] += 5
		player.gold += -add5Price
		Main.calculateGold()
	)
	
	$Add10.text = "Add 10\n$" + str(add10Price)
	$Add10.disabled = true
	$Add10.pressed.connect(func(): 
		player.spawnQueue[infos.name] += 10
		player.gold += -add10Price
		Main.calculateGold()
	)

	
	
