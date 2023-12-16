extends Node2D
const Knife = preload("res://monsters/knife/knife.tscn")

enum Player {YOU, BOT}
var versus = {Player.YOU : Player.BOT, Player.BOT : Player.YOU}

var allMonsters : Dictionary = {
	Player.BOT : {},
	Player.YOU : {}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(40):
		var knife = Knife.instantiate()
		var player = Player.YOU if i % 2 == 0 else Player.BOT
		knife.init(player)
		knife.position.x = randi_range(0,500)
		knife.position.y = randi_range(0,1000)
		allMonsters[player][knife.get_instance_id()] = knife
		add_child(knife)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
