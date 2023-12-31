extends RigidBody2D

const BASE_SPEED = 400
const BASE_IMPULSE_FORCE = 550
const TO_CENTER_FORCE = 30

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")

var gold := 5
var start_health := 100.0
var health := start_health
var attack := 10.0
var precision := 10.0
var speed := 1.0

var active = true
var type = "base"
var player : Types.Player
var currentTargetPosition = null

const isMonster = true

var disableSpriteAnimation = false

func spawnAnimation():
	if not disableSpriteAnimation:
		var initialScale = $Sprite2D.scale;
		$Sprite2D.scale.x = 0.0
		$Sprite2D.scale.y = 0.0
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "scale", initialScale, 0.2)
	
	#tween.tween_property($Sprite2D, "modulate", Color.RED, 1)
	#tween.tween_callback($Sprite2D.queue_free)


func init(_player):
	player = _player
	if player.belong == Types.BOT:
		set_collision_layer_value(1, true)
		set_collision_mask_value(2,true)
	else:
		set_collision_layer_value(2, true)
		set_collision_mask_value(1,true)

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = false
	timer.timeout.connect(_checkTarget)
	timer.start()
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_onMeet)
	spawnAnimation()

func onWillDie():
	pass

func end_die():
	$Close.visible = true
	await get_tree().create_timer(0.5).timeout
	queue_free()


func die():
	active = false
	onWillDie()
	player.nbrMonster += -1
	player.monsters.erase(get_instance_id())
	end_die()


func hit(_attack : float, fromPosition : Vector2, force : float):
	if not active: return
	health += -_attack
	apply_central_impulse(fromPosition.direction_to(position) * BASE_IMPULSE_FORCE * force)
	if health <= 0:
		die()
	else:
		$rectHealth.scale.x = health / start_health


func onHit(bully : RigidBody2D, force : float):
	hit(bully.attack, bully.position, force)
	

func _onMeet(body):
	if ("isMonster" in body and player.belong == Types.YOU):
		Main.fight(self, body)

func _process(delta):
	pass

func _checkTarget():
	currentTargetPosition = findNearestEnnemy()

func findNearestEnnemy():
	var min = 99999999
	var minTarget = null
	for ennemy in Main.versus(player).monsters.values() as Array[RigidBody2D]:
	#for ennemy in Main.players[Main.versus[belong]].monsters.values() as Array[RigidBody2D]:
		var distance = ennemy.position.distance_to(self.position)
		if distance < min:
			min = distance
			minTarget = ennemy.position
	return minTarget

func getGoForce():
	if (currentTargetPosition):
		var force = position.direction_to(currentTargetPosition) * BASE_SPEED
		if position.distance_to(currentTargetPosition) < 10:
			force *= 8
		var center = Vector2(300,500)
		force += position.direction_to(center) * TO_CENTER_FORCE;
		return force * speed
	return null

func _physics_process(delta):
	var force = getGoForce()
	if force:
		apply_central_force(force)
		
