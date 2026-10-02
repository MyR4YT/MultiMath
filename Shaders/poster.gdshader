shader_type canvas_item;

// Captura a textura da tela que está "atrás" deste ColorRect
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	// Pega a cor original da tela
	vec4 color = texture(screen_texture, SCREEN_UV);
	
	// Transforma em tons de cinza (calcula a luminosidade)
	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
	
	// Cria um contraste forte (estilo posterização)
	float threshold = step(0.5, gray);
	
	// Define as cores: Preto para o escuro, Amarelo Envelhecido para o claro
	vec3 color_dark = vec3(0.05, 0.05, 0.05); // Quase preto
	vec3 color_light = vec3(0.9, 0.75, 0.3);  // Amarelo "cartaz"
	
	// Aplica a nova paleta de cores
	color.rgb = mix(color_dark, color_light, threshold);
	
	// Aplica a cor final ao ColorRect (o alpha original é mantido)
	COLOR = color;
}