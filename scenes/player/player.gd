extends RigidBody2D

# FSM
enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state = INIT

@export var engine_power = 500
@export var spin_power = 8000


var thrust = Vector2.ZERO
var rotation_dir = 0

var screen_size = Vector2.ZERO


func _ready() -> void:
	screen_size = get_viewport_rect().size
	change_state(ALIVE)

func _process(delta: float) -> void:
	get_input()

func _physics_process(delta: float) -> void:
	constant_force = thrust
	constant_torque = rotation_dir * spin_power

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var xform = state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screen_size.x) # screen wrap
	xform.origin.y = wrapf(xform.origin.y, 0, screen_size.y)
	state.transform = xform


# custom functions

func get_input():
	thrust = Vector2.ZERO
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")

func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.set_deferred("disabled", true)
		ALIVE:
			$CollisionShape2D.set_deferred("disabled", false)
		INVULNERABLE:
			$CollisionShape2D.set_deferred("disabled", true)
		DEAD:
			$CollisionShape2D.set_deferred("disabled", true)
	state = new_state
