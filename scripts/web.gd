class_name Web2D

extends Node2D

@export var SPEED = 10

#var dir : float
var spawnPos : Vector2
#var spawnRot : float
var fireDir : Vector2
var zdex : int
var player : Ragdoll2D
var hand : RigidBody2D
var stuck : bool

@onready var sticky = $StickyRigidBody2D
@onready var wrist = $WristRigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wrist.global_position = spawnPos + (fireDir.normalized() * 14)
	sticky.global_position = spawnPos + (fireDir.normalized() * 18)
	wrist.z_index = zdex
	sticky.z_index = zdex
	
	var joint = PinJoint2D.new()
	wrist.add_child.call_deferred(joint)
	joint.node_a = wrist.get_path()
	joint.node_b = hand.get_path()

	sticky.apply_central_impulse(fireDir * SPEED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
#	#velocity = Vector2(0, -SPEED).rotated(dir)
#	#velocity = fireDir * SPEED * delta
#	#var vel = fireDir * SPEED * delta
#	#move_and_collide(vel)
#	pass

func delete() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_sticky_rigid_body_2d_body_entered(body: Node) -> void:
	if stuck:
		return
	
	if player.is_ancestor_of(body):
		print("can't stick to player")
		return

	print("collision with: ", body)
	var joint = PinJoint2D.new()
	sticky.add_child.call_deferred(joint)
	joint.node_a = sticky.get_path()
	joint.node_b = body.get_path()
	stuck = true
