shader_type canvas_item;

uniform vec4 aura_color = vec4(0.5, 0.5, 0.5, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if(c == vec4(1.0, 0.0, 1.0, 1.0))
	{
		c = aura_color;
	}
	COLOR = c;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
