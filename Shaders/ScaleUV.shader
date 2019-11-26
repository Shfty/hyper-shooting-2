shader_type canvas_item;

uniform vec2 scale = vec2(1.0);

void fragment() {
	vec2 uv = mod(UV * scale, 1.0);
	
	COLOR = texture(TEXTURE, uv);
}
