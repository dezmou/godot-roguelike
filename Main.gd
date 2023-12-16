extends Node2D

const Knife = preload("res://monsters/knife/knife.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(2):
		var knife = Knife.instantiate()
		knife.position.x = 150 * i
		knife.position.y = 300 * i
		add_child(knife)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
