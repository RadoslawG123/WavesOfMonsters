shader_type canvas_item;

uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// NASZA WŁASNA ZMIENNA DO ZMIANY KOLORU ZAMIAST DOMYŚLNEGO MODULATE:
uniform vec4 custom_modulate : source_color = vec4(1.0, 1.0, 1.0, 1.0); 

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	// Mnożymy przez NASZ własny kolor, ignorując wbudowany COLOR Godota
	vec4 tinted_color = original_color * custom_modulate;
	
	// Mieszamy zabarwionego potwora z białym błyskiem z Tweena
	vec4 new_color = mix(tinted_color, flash_color, flash_modifier);
	
	// Przezroczystość
	new_color.a = tinted_color.a; 
	
	COLOR = new_color;
}