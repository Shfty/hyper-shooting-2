shader_type canvas_item;

uniform sampler2D input_texture;

void fragment() { 
	vec4 input_color = texture(input_texture, UV);
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = max(input_color, texture_color);
}
