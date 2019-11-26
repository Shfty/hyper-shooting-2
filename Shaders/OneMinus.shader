shader_type canvas_item;

uniform bvec4 mask = bvec4(true, true, true, false);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.x = mask.x ? 1.0 - color.x : color.x;
	color.y = mask.y ? 1.0 - color.y : color.y;
	color.z = mask.z ? 1.0 - color.z : color.z;
	color.w = mask.w ? 1.0 - color.w : color.w;
	COLOR = color;
}
