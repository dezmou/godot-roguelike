extends RigidBody2D

const BASE_SPEED = 500
const BASE_IMPULSE_FORCE = 400
const TO_CENTER_FORCE = 50

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")

var health = 100
var attack = 10
var precision = 10

var type = "base"
var player : Types.Player
var currentTargetPosition = Vector2(500,1000)

func init(_player):
	player = _player
	if player.belong == Types.BOT:
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

func impulseFrom(target : RigidBody2D):
	apply_central_impulse(position.direction_to(target.position) * BASE_IMPULSE_FORCE * -1)

func _onMeet(body):
	if (player.belong == Types.YOU):
		var target = body.get_parent()
		Main.fight(self, target)

func _process(delta):
	pass

func _checkTarget():
	currentTargetPosition = findNearestEnnemy()

func findNearestEnnemy():
	var min = 99999999
	var minTarget = Vector2(300,500)
	for ennemy in Main.versus(player).monsters.values() as Array[RigidBody2D]:
	#for ennemy in Main.players[Main.versus[belong]].monsters.values() as Array[RigidBody2D]:
		var distance = ennemy.position.distance_to(self.position)
		if distance < min:
			min = distance
			minTarget = ennemy.position
	return minTarget


func _physics_process(delta):
	var force = position.direction_to(currentTargetPosition) * BASE_SPEED
	#if position.distance_to(currentTargetPosition) < 50:
		#force *= 8
	var center = Vector2(300,500)
	force += position.direction_to(center) * TO_CENTER_FORCE;
	apply_central_force(force)
