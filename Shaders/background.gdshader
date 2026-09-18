shader_type canvas_item;

// Cores personalizáveis (padrão: preto e branco)
uniform vec4 color1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color2 : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Controles de animação e forma
uniform float speed : hint_range(0.1, 10.0) = 2.0;
uniform float frequency : hint_range(1.0, 50.0) = 20.0; // Quantidade de listras
uniform float distortion : hint_range(0.0, 5.0) = 1.5;   // Intensidade do efeito líquido

// Função de ruído simples para deformar as listras
float hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p.x + p.y) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
    vec2 uv = UV;
    float t = TIME * speed;
    
    // Distorce a coordenada X e Y criando a deformação fluida
    float wave_x = noise(uv * 3.0 + vec2(t * 0.5, t * 0.3)) * distortion;
    float wave_y = noise(uv * 3.0 - vec2(t * 0.2, t * 0.4)) * distortion;
    
    // Calcula o padrão de onda base nas coordenadas distorcidas
    float pattern = sin((uv.x + wave_x + uv.y + wave_y) * frequency + t);
    
    // Corta a onda suave em duas cores nítidas (listras sólidas)
    float mask = step(0.0, pattern);
    
    // Aplica as cores
    COLOR = mix(color1, color2, mask);
}