shader_type canvas_item;

uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 original_color = texture(TEXTURE, UV);
	// Mieszamy oryginalny kolor obrazka z białym kolorem
	vec4 new_color = mix(original_color, flash_color, flash_modifier);
	
	// Upewniamy się, że przezroczyste tło dookoła Goblina zostaje przezroczyste!
	new_color.a = original_color.a; 
	
	COLOR = new_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
