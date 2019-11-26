shader_type canvas_item;

uniform sampler2D palette;

void fragment() {
	float texture_color = clamp(texture(TEXTURE, UV).x, 0.0, 1.0);
	COLOR = texture(palette, vec2(texture_color, 0.0));
}
