extends Node2D

const NB_MONSTER = 5

const waves = preload("res://waves.gd").new().waves

const Knife = preload("res://monsters/knife/knife.tscn")
const Flame = preload("res://monsters/flame/flame.tscn")

const monsters := {
	"knife" : Knife,
	"flame" : Flame,
}

enum {YOU, BOT}

class Player:
	var gold := 100000.0
	var nbrMonster = 0
	var monsters := {}
	var belong := YOU

	var spawnQueue := {
		"knife" : 100000,
		"flame" : 100000,
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
	

func exitShop():
	$BattleScene.get_tree().paused = false
	$Shop.visible = false

func handleShopButton():
	$BattleScene.get_tree().paused = true
	$Shop.visible = true

func spawnMonster(_player : Player, Monster : PackedScene):
	_player.nbrMonster += 1
	var monster = Monster.instantiate()
	monster.init(_player)
	monster.position.x = randi_range(50,450)
	monster.position.y = randi_range(50,950)
	_player.monsters[monster.get_instance_id()] = monster
	$BattleScene.add_child(monster)

func updateGold(player):
	$GoldLabel.text = "gold :" + str(int(player.gold))

func calculateGold():
	var goldAdd := 0.0
	for monster in players[YOU].monsters.values() as Array[RigidBody2D]:
		goldAdd += monster.gold * 0.05
	players[YOU].gold = players[YOU].gold + goldAdd
	updateGold(players[YOU])

func handleWaves():
	for wave in waves:
		await get_tree().create_timer(wave["wait"]).timeout
		for monsterBloc in wave["monsters"]:
			for i in monsterBloc["nbr"]:
				players[BOT].spawnQueue[monsterBloc["type"]] += 1
		

func updateHudNumber():
	#$NbrMonsterLabel.text = str(players[YOU].monsters.keys().size() + players[YOU].spawnQueue.size()) + " / 100"
	$NbrMonsterLabel.text = "69420 / 100"

func processQueue(player):
	var keys = player.spawnQueue.keys()
	
	while true:
		while true:
			var found = false
			if player.nbrMonster < 80:
				keys.shuffle()
				for key in keys:
					if player.nbrMonster >= 80:
						break
					if player.spawnQueue[key] > 0:
						spawnMonster(player, monsters[key])
						found = true
						player.spawnQueue[key] += -1
			if not found:
				break
		await get_tree().create_timer(0.1).timeout


func _ready():
	$Shop.visible = false
	$ShopButton.pressed.connect(handleShopButton)
	$Shop.addMonsterCard(Knife)
	$Shop.addMonsterCard(Flame)
	setInterval(0.5, calculateGold)
	for player in [players[YOU], players[BOT]]:
		processQueue(player)
	#handleWaves()
	
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
		
