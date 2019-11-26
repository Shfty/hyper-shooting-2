class_name ProceduralTexture
extends Control
tool

export(Texture) var input_texture setget set_input_texture
export(ShaderMaterial) var shader_material = ShaderMaterial.new() setget set_shader_material
export(Vector2) var resolution = Vector2(512, 512) setget set_resolution

var viewport: Viewport = null

# Setters
func set_input_texture(new_input_texture):
	if(input_texture != new_input_texture):
		input_texture = new_input_texture
		
		var sprite = $ViewportContainer/Viewport/Sprite
		sprite.set_texture(input_texture)
		
func set_shader_material(new_shader_material):
	if(shader_material != new_shader_material):
		shader_material = new_shader_material
		
		var sprite = $ViewportContainer/Viewport/Sprite
		if(sprite):
			sprite.set_material(shader_material)

func set_resolution(new_resolution):
	if(resolution != new_resolution):
		resolution = new_resolution
		rect_min_size = resolution
		rect_size = resolution
		
		var viewport_container = $ViewportContainer
		viewport_container.rect_size = resolution
		viewport_container.rect_pivot_offset = resolution * 0.5
		
		var viewport = $ViewportContainer/Viewport
		viewport.set_size(resolution)
		
		var sprite = $ViewportContainer/Viewport/Sprite
		sprite.set_region_rect(Rect2(0, 0, resolution.x, resolution.y))

# Overrides
func _get_configuration_warning():
	if(input_texture == null):
		return "Needs a valid input texture"
	
	if(shader_material == null):
		return "Needs a valid shader material"
	
	return ""
