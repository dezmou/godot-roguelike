extends Control

const Card = preload("res://card.tscn")

func getMonsterInfos(Monster:PackedScene):
	var monster = Monster.instantiate()
	var infos = monster.infos
	monster.queue_free()
	return infos
	

func addMonsterCard(Monster:PackedScene):
	var infos = getMonsterInfos(Monster)
	var card = Card.instantiate()
	card.scale.x = 0.7
	card.scale.y = 0.7
	card.position.x = 130
	card.position.y = 700
	card.get_node("Title").text = "[center]" + infos["card"]["title"] + "[/center]"
	card.get_node("Description").text = "[center]" + infos["card"]["text"] + "[/center]"
	add_child(card)


func go():
	print("go go go")

# Called when the node enters the scene tree for the first time.
func _ready():
	$GoButton.pressed.connect(go)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
