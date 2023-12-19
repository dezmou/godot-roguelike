extends Node2D

const SCREEN_W = 600
const SCREEN_H = 1000

const waves = preload("res://waves.gd").new().waves

const Knife = preload("res://monsters/knife/knife.tscn")
const Flame = preload("res://monsters/flame/flame.tscn")
const Bomb = preload("res://monsters/bomb/bomb.tscn")

const Column = preload("res://column.tscn")

var columns : Array[Control] = [];

const monsters := {
	"knife" : Knife,
	"flame" : Flame,
	"bomb" : Bomb,
}

enum {YOU, BOT}

class Player:
	var maxMonster = 40
	var gold := 1000.0
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
	

func spawnMonster(_player : Player, Monster : PackedScene):
	_player.nbrMonster += 1
	var monster = Monster.instantiate()
	monster.init(_player)
	monster.position.x = randi_range(50,450)
	monster.position.y = randi_range(50,500)
	_player.monsters[monster.get_instance_id()] = monster
	$BattleScene.add_child(monster)

func updateGold(player):
	$GoldLabel.text = "$" + str(int(player.gold))
	for column in columns:
		column.checkGold()

func calculateGold():
	var goldAdd := 0.0
	for monster in players[YOU].monsters.values() as Array[RigidBody2D]:
		goldAdd += monster.gain * 0.2
	players[YOU].gold = players[YOU].gold + goldAdd
	updateGold(players[YOU])

func handleWaves():
	for wave in waves:
		await get_tree().create_timer(wave["wait"]).timeout
		for monsterBloc in wave["monsters"]:
			for i in monsterBloc["nbr"]:
				players[BOT].spawnQueue[monsterBloc["type"]] += 1
		

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

func createShop():
	var index = -1
	for monster in [Knife, Flame, Bomb]:
		index += 1
		var column = Column.instantiate()
		$Control.add_child(column)
		column.init(monster, index)
		columns.append(column)

func _ready():
	setInterval(0.2, calculateGold)
	for player in [players[YOU], players[BOT]]:
		processQueue(player)
	handleWaves()
	createShop()
	$Control.get_node("NewGame").pressed.connect(func(): 
		get_tree().reload_current_scene()
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
		
