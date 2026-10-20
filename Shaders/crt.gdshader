shader_type canvas_item;

// Captura a tela atrás do nó
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Configurações do Efeito
uniform float crt_curve : hint_range(0.0, 1.0) = 0.03;      // Curvatura da tela (0.0 = reta)
uniform float scanline_count : hint_range(0.0, 2000.0) = 400.0; // Quantidade de linhas
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.35; // Escuridão das linhas
uniform float chromatic_aberration : hint_range(0.0, 0.02) = 0.003; // Separação de cores (RGB Shift)
uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.4; // Bordas escuras
uniform float noise_amount : hint_range(0.0, 0.2) = 0.02;     // Granulado / Estática

// Função para simular a curvatura da TV CRT
vec2 curve_uv(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) * vec2(crt_curve);
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

// Gerador de ruído pseudo-aleatório
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Aplica a curvatura das coordenadas UV
    vec2 uv = curve_uv(SCREEN_UV);

    // Se estiver fora da tela curva, pinta de preto
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // 1. Aberração Cromática (Separação de canais R, G e B)
        float r = texture(SCREEN_TEXTURE, uv + vec2(chromatic_aberration, 0.0)).r;
        float g = texture(SCREEN_TEXTURE, uv).g;
        float b = texture(SCREEN_TEXTURE, uv - vec2(chromatic_aberration, 0.0)).b;
        vec3 color = vec3(r, g, b);

        // 2. Scanlines (Linhas horizontais)
        float scanline = sin(uv.y * scanline_count * 3.14159 * 2.0);
        scanline = (scanline + 1.0) * 0.5; // Normaliza para 0.0 a 1.0
        scanline = pow(scanline, 1.5);
        color -= scanline * scanline_intensity * color;

        // 3. Ruído estático sutil
        float noise = rand(uv + vec2(TIME * 0.1, TIME * 0.05));
        color += (noise - 0.5) * noise_amount;

        // 4. Efeito Vinheta (Bordas mais escuras)
        vec2 uv_vignette = uv * (1.0 - uv.yx);
        float vignette = uv_vignette.x * uv_vignette.y * 15.0;
        vignette = pow(vignette, vignette_intensity);
        color *= clamp(vignette, 0.0, 1.0);

        COLOR = vec4(color, 1.0);
    }
}