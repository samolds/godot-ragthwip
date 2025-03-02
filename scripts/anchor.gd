extends StaticBody2D

@onready var timer = $Timer

func _on_timer_timeout() -> void:
	print("anchor freed")
	queue_free()

func start():
	timer.start()
	
func stop():
	timer.stop()
