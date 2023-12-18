extends Node2D

const NB_MONSTER = 5

const waves = preload("res://waves.gd").new().waves

const Knife = preload("res://monsters/knife/knife.tscn")
const Flame = preload("res://monsters/flame/flame.tscn")

enum {YOU, BOT}

class Player:
	var gold := 100.0
	var monsters := {}
	var belong := YOU
	var starter = {
		YOU : [Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife] as Array[PackedScene],
		BOT : [Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife,Knife] as Array[PackedScene],
	}
	var spawnQueue : Array[PackedScene] = []
		
	func _init(_belong):
		belong = _belong
		spawnQueue = starter[_belong]

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
	

func exitShop():
	$BattleScene.get_tree().paused = false
	$Shop.visible = false

func handleShopButton():
	$BattleScene.get_tree().paused = true
	$Shop.visible = true

func spawnMonster(player : Player, Monster : PackedScene):
	var monster = Monster.instantiate()
	monster.init(player)
	monster.position.x = randi_range(50,450)
	monster.position.y = randi_range(50,950)
	player.monsters[monster.get_instance_id()] = monster
	$BattleScene.add_child(monster)

func updateGold(player):
	$GoldLabel.text = "gold :" + str(int(player.gold))

func calculateGold():
	var goldAdd := 0.0
	for monster in players[YOU].monsters.values() as Array[RigidBody2D]:
		goldAdd += monster.gold * 0.05
	players[YOU].gold = players[YOU].gold + goldAdd
	updateGold(players[YOU])

func newWave():
	for i in randi_range(0,15):
		players[BOT].spawnQueue.append(Knife)
	for i in randi_range(0,10):
		players[BOT].spawnQueue.append(Flame)

func handleWaves():
	for wave in waves:
		await get_tree().create_timer(wave["wait"]).timeout
		for monsterBloc in wave["monsters"]:
			for i in monsterBloc["nbr"]:
				players[BOT].spawnQueue.append(monsterBloc["type"])
		

func updateHudNumber():
	$NbrMonsterLabel.text = str(players[YOU].monsters.keys().size() + players[YOU].spawnQueue.size()) + " / 100"

func processQueue():
	updateHudNumber()
	for player in [players[YOU], players[BOT]]:
		var space = true
		var overflow : Array[PackedScene] = []
		for Monster in player.spawnQueue:
			if player.monsters.keys().size() >= 100:
				space = false
			if space == false:
				overflow.append(Monster)
			else:
				spawnMonster(player, Monster)
		player.spawnQueue = overflow

func _ready():
	$Shop.visible = false
	$ShopButton.pressed.connect(handleShopButton)
	$Shop.addMonsterCard(Knife)
	$Shop.addMonsterCard(Flame)
	setInterval(0.5, calculateGold)
	setInterval(0.1, processQueue)
	handleWaves()
	
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
		
