extends Node2D

const SCREEN_W = 600
const SCREEN_H = 1000

const Knife = preload("res://monsters/knife/knife.tscn")
const Flame = preload("res://monsters/flame/flame.tscn")
const Bomb = preload("res://monsters/bomb/bomb.tscn")

#const Column = preload("res://column.tscn")
const ItemControl = preload("res://Item.tscn")

class Item:
	var index := 0;
	var control: Control;
	var monster : RigidBody2D
	var price1 := 0
	var price5 := 0
	var price10 := 0

var selectedItemIndex := 0
var items : Array[Item] = [];

const monsters := {
	"knife" : Knife,
	"flame" : Flame,
	"bomb" : Bomb,
}

enum {YOU, BOT}

class Player:
	var maxMonster = 40
	var gold := 15.0
	var nbrMonster = 0
	var monsters := {}
	var belong := YOU

	var spawnQueue := {
		"knife" : 0,
		"flame" : 0,
		"bomb" : 0,
	}
		
	func _init(_belong):
		belong = _belong

var players := {
	BOT : Player.new(BOT),
	YOU : Player.new(YOU),
}
func setInterval(second: float, callBack : Callable):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = second
	timer.one_shot = false
	timer.timeout.connect(callBack)
	timer.start()


func versus(player : Player):
	return players[{BOT : YOU, YOU : BOT}[player.belong]] 

func getAllMonsters() -> Array[RigidBody2D]:
	var res : Array[RigidBody2D] = [];
	res.assign(players[BOT].monsters.values() + players[YOU].monsters.values())
	return res
	
func emptyBoard():
	for player in players.values():
		for monster in player.monsters.values():
			monster.queue_free()
		player.nbrMonster = 0;
		player.monsters = {}
		for key in player.spawnQueue.keys():
			player.spawnQueue[key] = 0


func applySpawnMonster(_player : Player, monster : RigidBody2D):
	_player.nbrMonster += 1
	monster.init(_player)
	monster.position.x = randi_range(50,450)
	monster.position.y = randi_range(50,500)
	_player.monsters[monster.get_instance_id()] = monster
	$BattleScene.add_child(monster)

func spawnMonster(_player : Player, Monster : PackedScene):
	var monster = Monster.instantiate()
	applySpawnMonster(_player, monster)

func updateGold(player):
	$GoldLabel.text = "$" + str(int(player.gold))
	var item = items[selectedItemIndex]
	$Control/Add1.disabled = players[YOU].gold < item.monster.infos["gold"]
	$Control/Add5.disabled = players[YOU].gold < item.monster.infos["gold"] * 5
	$Control/Add10.disabled = players[YOU].gold < item.monster.infos["gold"] * 10

	$Control/Add1.text = "Buy 1\n$" + str(item.monster.infos["gold"])
	$Control/Add5.text = "Buy 5\n$" + str(item.monster.infos["gold"] * 5)
	$Control/Add10.text = "Buy 10\n$" + str(item.monster.infos["gold"] * 10)


func calculateGold():
	updateGold(players[YOU])

func handleWaves():
	$InfoModal.get_node("goButton").pressed.connect(func():
		$Levels.onModalClosed()
	)

func updateHudNumber():
	var nbr = players[YOU].nbrMonster
	for q in players[YOU].spawnQueue.values():
		nbr += q
	$NbrMonsterLabel.text = str(nbr) + " / " + str(players[YOU].maxMonster)

func processQueue(player):
	var keys = player.spawnQueue.keys()
	
	while true:
		while true:
			var found = false
			if player.nbrMonster < player.maxMonster:
				keys.shuffle()
				for key in keys:
					if player.nbrMonster >= player.maxMonster:
						break
					if player.spawnQueue[key] > 0:
						spawnMonster(player, monsters[key])
						await get_tree().create_timer(0.02).timeout
						found = true
						player.spawnQueue[key] += -1
			if not found:
				break
		updateHudNumber()
		await get_tree().create_timer(0.1).timeout

func clickItem(item : Item):
	selectedItemIndex = item.index
	for it in items:
		it.control.get_node("Color").color = Color(1,1,1)
	item.control.get_node("Color").color = Color(0.8,0.2,0.2)
	calculateGold()


func createShop():
	var index = -1
	for Monster in [Knife, Flame, Bomb]:
		index += 1
		var item = Item.new()
		item.index = index
		item.monster = Monster.instantiate()
		item.control = ItemControl.instantiate()
		item.price1 = item.monster.infos["gold"]
		item.price5 = item.monster.infos["gold"] * 5
		item.price10 = item.monster.infos["gold"] * 10
		$Control.add_child(item.control)
		item.control.get_node("Texture").texture = item.monster.infos["card"]["image"]
		item.control.get_node("Selected").visible = true
		item.control.position.x = float(index) * item.control.size.x
		item.control.get_node("Button").pressed.connect(func():
			clickItem(item)
		)
		items.append(item)
	clickItem(items[0])

func _ready():
	setInterval(0.2, calculateGold)
	for player in [players[YOU], players[BOT]]:
		processQueue(player)
	handleWaves()
	createShop()
	$Control.get_node("NewGame").pressed.connect(func(): 
		get_tree().reload_current_scene()
	)
	$Control.get_node("Cheat").pressed.connect(func(): 
		players[YOU].gold = 694200
	)
	$Control/Add1.pressed.connect(func():
		var monster = items[selectedItemIndex].monster;
		players[YOU].spawnQueue[monster.infos["name"]] += 1
		players[YOU].gold += -items[selectedItemIndex].price1
		calculateGold()
	)
	$Control/Add5.pressed.connect(func():
		var monster = items[selectedItemIndex].monster;
		players[YOU].spawnQueue[monster.infos["name"]] += 5
		players[YOU].gold += -items[selectedItemIndex].price5
		calculateGold()
	)
	$Control/Add10.pressed.connect(func():
		var monster = items[selectedItemIndex].monster;
		players[YOU].spawnQueue[monster.infos["name"]] += 10
		players[YOU].gold += -items[selectedItemIndex].price10
		calculateGold()
	)
	$Control/InfoButton.pressed.connect(func():
		$MonsterInfos.visible = true;
		pass	
	)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

		
func onKilled(killer:RigidBody2D):
	pass

func onKill(target:RigidBody2D):
	pass

func fight(a:RigidBody2D, b:RigidBody2D):
	var winner = a
	var loser = b
	if randi_range(0,a.precision + b.precision) > a.precision:
		winner = b
		loser = a
	loser.onHit(winner, 1.0)
		
