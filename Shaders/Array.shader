shader_type canvas_item;

uniform int count = 2;

void fragment() {
	float fcount = float(count);
	COLOR = texture(TEXTURE, mod(UV * float(count), 1.0));
}
