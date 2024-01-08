class_name ProceduralTextureSequence
extends HBoxContainer
tool

enum InputType {
	COLOR,
	TEXTURE
}

export(InputType) var input_type = InputType.COLOR setget set_input_type
export(Color) var input_fill_color = Color.white setget set_input_fill_color
export(Texture) var input_texture setget set_input_texture

export(Array, ShaderMaterial) var steps setget set_steps
export(Vector2) var resolution = Vector2(512, 512) setget set_resolution

export(bool) var collapse setget set_collapse

export(bool) var save setget set_save
var proc_texture_scene = preload("res://Scenes/ProceduralTexturing/ProceduralTexture.tscn")
export(ImageTexture) var save_texture setget set_save_texture

func set_steps(new_steps):
	if(steps != new_steps):
		steps = new_steps
		for idx in range(0, steps.size()):
			if(steps[idx] == null):
				steps[idx] = ShaderMaterial.new()
		run()

func set_resolution(new_resolution):
	if(resolution != new_resolution):
		resolution = new_resolution
		rect_size = Vector2.ZERO
		run()

func set_input_type(new_input_type):
	if(input_type != new_input_type):
		input_type = new_input_type
		run()

func set_input_fill_color(new_input_fill_color):
	if(input_fill_color != new_input_fill_color):
		input_fill_color = new_input_fill_color
		run()

func set_input_texture(new_input_texture):
	if(input_texture != new_input_texture):
		input_texture = new_input_texture
		run()

func set_collapse(new_collapse):
	if(collapse != new_collapse):
		collapse = new_collapse
		run()

func set_save(new_save):
	var children = get_children()
	if(children.size() > 0):
		var last_child = children.back()
		if(last_child != null):
			var viewport = last_child.find_node("Viewport")
			if(viewport != null):
				save_texture.create_from_image(viewport.get_texture().get_data())

func set_save_texture(new_save_texture):
	if(save_texture != new_save_texture):
		save_texture = new_save_texture

func _ready():
	run()

func run():
	var tree = get_tree()
	if(tree == null):
		return

	var input_tex: Texture = null
	match input_type:
		InputType.COLOR:
			# Create input texture for first index
			var input_image = Image.new()
			input_image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBA8)
			input_image.fill(input_fill_color)

			input_tex = ImageTexture.new()
			input_tex.create_from_image(input_image)
		InputType.TEXTURE:
			input_tex = input_texture
			pass

	# Remove existing children
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var prev_child = null
	for step in steps:
		# Create wrapper control
		var proc_texture = proc_texture_scene.instance()
		proc_texture.set_meta("_edit_lock_", true)
		proc_texture.name = "Step1"
		proc_texture.rect_min_size = resolution
		proc_texture.set_shader_material(step)
		proc_texture.set_resolution(resolution)
		Util.add_child_editor(self, proc_texture)

		if(prev_child == null):
			proc_texture.set_input_texture(input_tex)
		else:
			proc_texture.set_input_texture(prev_child.find_node("Viewport").get_texture())

		if(collapse && proc_texture != get_children().back()):
			proc_texture.rect_size.x = 0
			proc_texture.rect_min_size.x = 0
		else:
			proc_texture.rect_size.x = resolution.x
			proc_texture.rect_min_size.x = resolution.x

		prev_child = proc_texture
