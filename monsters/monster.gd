extends RigidBody2D

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")

var health = 10
var type = "base"
var player : Types.Player = Types.Player.YOU
var currentTargetPosition = Vector2(500,1000)

func init(newPlayer : Types.Player):
	player = newPlayer
	if newPlayer == Types.Player.BOT:
		$Hitbox.set_collision_layer_value(1, true)
		$Hitbox.set_collision_mask_value(2,true)
	else:
		$Hitbox.set_collision_layer_value(2, true)
		$Hitbox.set_collision_mask_value(1,true)

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = false
	timer.timeout.connect(_checkTarget)
	timer.start()
	
	($Hitbox as Area2D).area_entered.connect(_onMeet)


func _onMeet(body):
	var target = body.get_parent()
	apply_central_impulse(position.direction_to(target.position) * 400 * -1)

func _process(delta):
	pass

func _checkTarget():
	currentTargetPosition = findNearestEnnemy()

func findNearestEnnemy():
	var min = 99999999
	var minTarget = Vector2(300,500)
	for ennemy in Main.allMonsters[Main.versus[player]].values() as Array[RigidBody2D]:
		var distance = ennemy.position.distance_to(self.position)
		if distance < min:
			min = distance
			minTarget = ennemy.position
	return minTarget


func _physics_process(delta):
	var force = position.direction_to(currentTargetPosition) * 600
	if position.distance_to(currentTargetPosition) < 30:
		force *= 4
	var center = Vector2(300,500)
	force += position.direction_to(center) * 200;
	apply_central_force(force)
