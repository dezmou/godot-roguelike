extends "res://monsters/monster.gd"

const Projectile = preload("res://monsters/flame/projectile.tscn")

const infos = {
	"card" : {
		"image" : preload("res://art/flame_card.png"),
		"title" : "Alphonse",
		"text" : "Range attack",
	},
	"name" : "flame",
	"health" : 30,	
	"attack" : 3,
	"precision" : ".",
	"speed" : 0.9,
	"gold" : 6.0,
}

var text = """
[center][font_size={35}]Alphonse Flame[/font_size]
[img=450x450]res://art/flame_card.png[/img]
[/center]

[font_size={30}][color=#7e6e33]Price : $%s[/color][/font_size]
[font_size={30}][color=green]Health : %s[/color][/font_size]

[font_size={22}]Long range unit
5 time pers second, launch flame dealing [color=red]%s[/color][/font_size] 

""" % [
	str(infos.gold), 
	str(infos.health),
	str(infos.attack), 
]

var sprites = {
	Types.BOT : preload("res://art/flame_red.png"),
	Types.YOU : preload("res://art/flame_blue.png"),
}

func setInterval(second: float, callBack : Callable):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = second
	timer.one_shot = false
	timer.timeout.connect(callBack)
	timer.start()


func shotFlame():
	if currentTargetPosition:
		if position.distance_to(currentTargetPosition) < 170:
			var projectile = Projectile.instantiate()
			Main.get_node("BattleScene").add_child(projectile)
			projectile.init(player, position, currentTargetPosition)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	health = infos.health
	start_health = health
	attack = 0
	precision = 0
	speed = infos.speed
	gold = infos.gold
	$Sprite2D.texture = sprites[player.belong]
	type = "flame"
	super._ready()
	await get_tree().create_timer(randf_range(0,0.4)).timeout
	setInterval(0.2,shotFlame)

func getGoForce():
	if (currentTargetPosition):
		var force = position.direction_to(currentTargetPosition) * BASE_SPEED
		if position.distance_to(currentTargetPosition) < 150:
			force *= -1
		var center = Vector2(300,500)
		force += position.direction_to(center) * TO_CENTER_FORCE;
		return force * speed
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _physics_process(delta):
	#$Sprite2D.look_at(currentTargetPosition)
	#super._physics_process(delta)
