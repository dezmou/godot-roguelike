extends "res://monsters/monster.gd"

const infos = {
	"card" : {
		"image" : preload("res://art/totem_card.png"),
		"title" : "Totem",
		"text" : "no special effect",
	},
	"name" : "totem",
	"health" : 100,
	"attack" : 0,
	"precision" : 0,
	"speed" : 1,
	"gold" : 10.0,
}

var text = """
[center][font_size={35}]Totem[/font_size]
[img=450x450]res://art/totem_card.png[/img]
[/center]

[font_size={30}][color=#7e6e33]Price : $%s[/color][/font_size]
[font_size={30}][color=green]Health : %s[/color][/font_size]

[font_size={22}]Gain 1 gold per second while on field
[/font_size]

""" % [
	str(infos.gold), 
	str(infos.health),
]

var sprites = {
	Types.BOT : preload("res://art/totem_red.png"),
	Types.YOU : preload("res://art/totem_blue.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	health = infos.health
	start_health = infos.health
	speed = infos.speed
	attack = infos.attack
	precision = infos.precision
	gold = infos.gold
	$Sprite2D.texture = sprites[player.belong]
	type = "totem"
	super._ready()
	var i = 0
	while(true):
		await get_tree().create_timer(1).timeout
		player.gold += 1

func findNearestEnnemy():
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _physics_process(delta):
	#$Sprite2D.look_at(currentTargetPosition)
	#super._physics_process(delta)
