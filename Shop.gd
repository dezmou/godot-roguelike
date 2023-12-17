extends Control

const Card = preload("res://card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var card = Card.instantiate()
	card.position.x = 300
	card.position.y = 500
	add_child(card)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
