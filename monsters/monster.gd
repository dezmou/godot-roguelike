extends RigidBody2D

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")

var health = 10
var type = "base"
var player : Types.Player = Types.Player.YOU

var currentTargetPosition = Vector2(500,1000)

func init(newPlayer : Types.Player):
	player = newPlayer
	$playerColor.color = Color(0.7,0.2,0.1,0.5) if player == Types.Player.BOT else  Color(0.2,0.7,0.1,0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = false
	timer.timeout.connect(_checkTarget)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	#var target = findNearestEnnemy()
	#var force = position.direction_to(screen_center) * position.distance_to(screen_center) * 2.
	var force = position.direction_to(currentTargetPosition) * 100
	apply_central_force(force)
