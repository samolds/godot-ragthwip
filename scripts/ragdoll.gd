class_name Ragdoll2D

extends Node2D

@onready var head = $head
@onready var torso = $torso
@onready var left_hand = $left_arm/lower
@onready var right_hand = $right_arm/lower
@onready var left_foot = $left_leg/calf
@onready var right_foot = $right_leg/calf

@export var power = 200

@onready var main = get_tree().get_root().get_node("game")
@onready var web = load("res://scenes/web.tscn")

var webs_fired: int = 0
var left_web: Web2D = null
var right_web: Web2D = null

func is_body_part(n: Node) -> bool:
	return n == head or n == torso or n == left_hand or n == right_hand or n == left_foot or n == right_foot

func _physics_process(_delta: float) -> void:
	var vert = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	head.apply_impulse(Vector2.UP * vert * power, Vector2.ZERO)
	left_hand.apply_impulse(Vector2.LEFT * Input.get_action_strength("ui_left") * power, Vector2.ZERO)
	left_foot.apply_impulse(Vector2.LEFT * Input.get_action_strength("ui_left") * power, Vector2.ZERO)
	right_hand.apply_impulse(Vector2.RIGHT * Input.get_action_strength("ui_right") * power, Vector2.ZERO)
	right_foot.apply_impulse(Vector2.RIGHT * Input.get_action_strength("ui_right") * power, Vector2.ZERO)

	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	

func shoot() -> void:
	var hand = null
	if webs_fired % 2 == 0:
		hand = left_hand
	else:
		hand = right_hand
	
	var instance = web.instantiate()
	instance.player = self
	instance.hand = hand
	instance.fireDir = get_global_mouse_position() - hand.global_position
	instance.spawnPos = hand.global_position
	instance.zdex = z_index - 1

	if webs_fired % 2 == 0:	
		if left_web:
			left_web.delete()
			left_web = null
		left_web = instance
	else:
		if right_web:
			right_web.delete()
			right_web = null
		right_web = instance
	
	webs_fired += 1
	main.add_child.call_deferred(instance)
