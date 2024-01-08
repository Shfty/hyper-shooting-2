class_name Weapon
extends Spatial

export(NodePath) var muzzle_flash
var muzzle_flash_instance: Node = null

export(NodePath) var kickback_anchor
var kickback_anchor_instance: Spatial = null

export(bool) var automatic_refire = true
export(float) var kickback_impulse = 10.0

var muzzle_flash_duration = 0.15
var muzzle_flash_visible = true
var muzzle_flash_timer = null

var kickback = 0.0
var kickback_lerp_speed = 8.0

var can_fire = true
var refire_duration = 0.8
var refire_timer = null

export(float) var hitscan_range = 1000.0
export(int) var hitscan_count = 16
export(Vector3) var hitscan_deviation = Vector3(15, 20, 0)
var hitscan_raycast = null

export(PackedScene) var hitscan_particle_resource

# @TODO: Split into component parts

# Setters
func set_muzzle_flash_visible(new_muzzle_flash_visible):
	if(muzzle_flash_visible != new_muzzle_flash_visible):
		muzzle_flash_visible = new_muzzle_flash_visible
		muzzle_flash_instance.visible = muzzle_flash_visible

func set_can_fire(new_can_fire):
	if(can_fire != new_can_fire):
		can_fire = new_can_fire

func _ready():
	assert(!muzzle_flash.is_empty())
	muzzle_flash_instance = get_node(muzzle_flash)

	assert(!kickback_anchor.is_empty())
	kickback_anchor_instance = get_node(kickback_anchor)

	set_muzzle_flash_visible(false)

	muzzle_flash_timer = Timer.new()
	muzzle_flash_timer.name = "MuzzleFlashTimer"
	muzzle_flash_timer.connect("timeout", self, "set_muzzle_flash_visible", [false])
	add_child(muzzle_flash_timer)

	refire_timer = Timer.new()
	refire_timer.name = "RefireTimer"
	refire_timer.connect("timeout", self, "refire")
	add_child(refire_timer)

	hitscan_raycast = RayCast.new()
	hitscan_raycast.name = "HitscanRaycast"
	hitscan_raycast.cast_to = Vector3(0, 0, -hitscan_range)
	add_child(hitscan_raycast)

func _process(delta):
	kickback_anchor_instance.translation = lerp(kickback_anchor_instance.translation, Vector3(0, 0, kickback), delta * kickback_lerp_speed)
	kickback = lerp(kickback, 0.0, delta * kickback_lerp_speed)

func _input(event):
	if(can_fire && event.is_action_pressed("fire")):
		fire()

func fire():
	hitscan_raycast.enabled = true
	for idx in range(0, hitscan_count):
		hitscan_raycast.rotation = Vector3((randf() - 0.5) * 2 * deg2rad(hitscan_deviation.x), (randf() - 0.5) * 2 * deg2rad(hitscan_deviation.y), 0)
		hitscan_raycast.force_raycast_update()
		if(hitscan_raycast.is_colliding()):
			var hitscan_particle = hitscan_particle_resource.instance()
			get_tree().get_root().add_child(hitscan_particle)
			var normal = hitscan_raycast.get_collision_normal()
			hitscan_particle.translation = hitscan_raycast.get_collision_point()
			hitscan_particle.look_at(hitscan_particle.translation - normal, Vector3(normal.y, normal.z, normal.x))
			hitscan_particle.emitting = true
	hitscan_raycast.enabled = false

	kickback = kickback_impulse

	set_muzzle_flash_visible(true)
	muzzle_flash_timer.start(muzzle_flash_duration)

	set_can_fire(false)
	refire_timer.start(refire_duration)

func refire():
	set_can_fire(true)
	if(automatic_refire && Input.is_action_pressed("fire")):
		fire()
