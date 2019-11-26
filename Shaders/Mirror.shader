shader_type canvas_item;

uniform vec2 origin = vec2(0.5);

void fragment() {
	vec2 uv = UV;
	if(uv.x > origin.x) {
		uv.x -= origin.x;
		uv.x *= -1.0;
		uv.x += origin.x;
	}
	if(uv.y > origin.y) {
		uv.y -= origin.y;
		uv.y *= -1.0;
		uv.y += origin.y;
	}
	COLOR = texture(TEXTURE, uv);
}
