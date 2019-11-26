shader_type canvas_item;

uniform vec4 factor = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() { 
	COLOR = texture(TEXTURE, UV) * factor;
}
