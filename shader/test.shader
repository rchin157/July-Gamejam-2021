shader_type canvas_item;

void vertex() {
	//VERTEX = VERTEX + vec2(100.0, 1.0);
}

void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);
	float avg = (bg.r + bg.g + bg.b) /3f;
	vec3 col = vec3(avg, avg, avg);
	col *= vec3(0.0f, 0.99f, 0.0f);
	COLOR = vec4(col, 0.5f);
}