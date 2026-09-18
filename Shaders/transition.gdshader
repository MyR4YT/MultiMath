shader_type canvas_item;

// Controla o progresso da animação (0.0 a 1.0)
uniform float progress : hint_range(0, 1);
// Quantidade de losangos na tela
uniform float diamondPixelSize = 40.0;

void fragment() {
    float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
    float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
    
    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);
    
    if (xDistance + yDistance + UV.x + UV.y > progress * 4.0) {
        discard;
    }
}