extends Control

const Card := preload("res://card.tscn")

const Types := preload("res://Main.gd")
@onready var Main := get_node("/root/Main")

var cardNumber := 0

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
	var cardSize = Vector2(card.get_node("ClickArea").get_rect().size.x, card.get_node("ClickArea").get_rect().size.y)
	card.position.x = ((cardSize.x * card.scale.x) / 2.0 + 10) + (cardSize.x * cardNumber)
	card.position.y = (cardSize.y * card.scale.y) / 2.0 + 10
	card.get_node("Title").text = "[center]" + infos["card"]["title"] + "[/center]"
	card.get_node("Description").text = "[center]" + infos["card"]["text"] + "[/center]"
	card.get_node("Sprite2D").texture = infos["card"]["image"]
	add_child(card)
	card.get_node("ClickArea").pressed.connect(func(): 
		for i in range(15):
			Main.players[Types.YOU].spawnQueue.append(Monster)
	)
	cardNumber += 1


func go():
	Main.exitShop()

# Called when the node enters the scene tree for the first time.
func _ready():
	$GoButton.pressed.connect(go)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
