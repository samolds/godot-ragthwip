extends Node2D


var Anchor = load("res://scenes/anchor.tscn")

@onready var timer = $Timer
@onready var main = get_tree().get_root().get_node("game")
@onready var player = get_tree().get_root().get_node("game/ragdoll/pelvis")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var anchor = Anchor.instantiate()
	main.add_child.call_deferred(anchor)
	anchor.global_position = Vector2(0, 80)

func _on_timer_timeout() -> void:
	spawn_anchor()

func spawn_anchor():
	print("spawning anchor: ", player.global_position.x)
	var anchor = Anchor.instantiate()
	main.add_child.call_deferred(anchor)
	anchor.global_position.x = player.global_position.x + 600 + randi_range(0, 600)
	anchor.global_position.y = randi_range(-200, 0)

func start():
	timer.start()
	
func stop():
	timer.stop()
