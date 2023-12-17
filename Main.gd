extends Node2D

const NB_MONSTER = 50

const Knife = preload("res://monsters/knife/knife.tscn")
enum {YOU, BOT}

class Player:
	var monsters := {}
	var belong := YOU
		
	func _init(_belong):
		belong = _belong

var players := {
	BOT : Player.new(BOT),
	YOU : Player.new(YOU),
}

func versus(player : Player):
	return players[{BOT : YOU, YOU : BOT}[player.belong]] 

func getAllMonsters() -> Array[RigidBody2D]:
	var res : Array[RigidBody2D] = [];
	res.assign(players[BOT].monsters.values() + players[YOU].monsters.values())
	return res
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(NB_MONSTER):
		var knife = Knife.instantiate()
		var player = players[YOU if i % 2 == 0 else BOT]
		knife.init(player)
		knife.position.x = randi_range(50,450)
		knife.position.y = randi_range(50,950)
		player.monsters[knife.get_instance_id()] = knife
		add_child(knife)


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
	loser.onHit(winner)
	#loser.health += -winner.attack;
	#loser.impulseFrom(winner)
	#for monster in [a,b]:
		#if monster.health <= 0:
			#monster.player.monsters.erase(monster.get_instance_id())
			#monster.queue_free()

	#if (a.player.belong == YOU and b.player.belong == BOT):
		#for monster in [a,b]:
			#monster.health += -1
			#if monster.health <= 0:
				#monster.player.monsters.erase(monster.get_instance_id())
				#monster.queue_free()
		
