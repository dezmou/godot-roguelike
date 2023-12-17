extends Node2D

const NB_MONSTER = 5

const Knife = preload("res://monsters/knife/knife.tscn")

enum {YOU, BOT}

class Player:
	var monsters := {}
	var belong := YOU
	var spawnQueue : Array[PackedScene] = [Knife, Knife, Knife, Knife, Knife, Knife, Knife, Knife, Knife]
		
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

func spawnMonster(player : Player, Monster : PackedScene):
	var knife = Monster.instantiate()
	knife.init(player)
	knife.position.x = randi_range(50,450)
	knife.position.y = randi_range(50,950)
	player.monsters[knife.get_instance_id()] = knife
	$BattleScene.add_child(knife)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Shop.visible = false
	$ShopButton.pressed.connect(handleShopButton)
	$Shop.addMonsterCard(Knife)
	setInterval(1, func(): 
		if randi_range(0,10) == 8:
			for i in randi_range(0,15):
				players[BOT].spawnQueue.append(Knife)
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for player in [players[YOU], players[BOT]]:
		for Monster in player.spawnQueue:
			spawnMonster(player, Monster)
		player.spawnQueue.clear()
		
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
	loser.onHit(winner)
		
