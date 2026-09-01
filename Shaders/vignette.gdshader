shader_type canvas_item;

uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float intensity : hint_range(0.0, 3.0) = 0.4;
uniform float softness : hint_range(0.0, 2.0) = 0.8;
uniform float bottom_weight : hint_range(0.0, 3.0) = 1.5; // Aumenta a escuridão na parte inferior

void fragment() {
    // Centraliza e ajusta as coordenadas UV (-0.5 a 0.5)
    vec2 uv = UV - vec2(0.5);
    
    // Calcula a distância radial a partir do centro para a vinheta base
    float dist = length(uv);
    float vignette = smoothstep(softness, softness - intensity, dist);
    
    // Adiciona um gradiente vertical que escurece mais conforme desce na tela (UV.y vai de 0 no topo a 1 na base)
    float bottom_gradient = mix(1.0, 1.0 - bottom_weight, UV.y * UV.y);
    
    // Combina a vinheta circular com o peso inferior
    float final_mask = vignette * clamp(bottom_gradient, 0.0, 1.0);
    
    // Aplica a cor final e inverte o alpha para cobrir as bordas
    COLOR = vec4(vignette_color.rgb, (1.0 - final_mask) * vignette_color.a);
}