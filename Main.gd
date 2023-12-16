extends Node2D

const NB_MONSTER = 50

const Knife = preload("res://monsters/knife/knife.tscn")

enum Player {YOU, BOT}
const versus := {Player.YOU : Player.BOT, Player.BOT : Player.YOU}

var allMonsters  := {
	Player.BOT : {},
	Player.YOU : {}
}

func getAllMonsters() -> Array[RigidBody2D]:
	var res : Array[RigidBody2D] = [];
	res.assign(allMonsters[Player.BOT].values() + allMonsters[Player.YOU].values())
	return res
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(NB_MONSTER):
		var knife = Knife.instantiate()
		var player = Player.YOU if i % 2 == 0 else Player.BOT
		knife.init(player)
		knife.position.x = randi_range(50,450)
		knife.position.y = randi_range(50,950)
		allMonsters[player][knife.get_instance_id()] = knife
		add_child(knife)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fight(a:RigidBody2D, b:RigidBody2D):
	if (a.player == Player.YOU and b.player == Player.BOT):
		for monster in [a,b]:
			monster.health += -1
			if monster.health <= 0:
				allMonsters[monster.player].erase(monster.get_instance_id())
				monster.queue_free()
		
