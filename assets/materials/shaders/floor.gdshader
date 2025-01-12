shader_type spatial;
render_mode blend_premul_alpha;
uniform sampler2D texturemap : filter_nearest, hint_normal;

void fragment() {
    vec2 t_uv = UV * vec2(40.0, 40.0);
    vec3 tex_color = texture(texturemap, t_uv).rgb;

    // from gamma to linear color space
    tex_color = pow(tex_color, vec3(2.2));
    ALBEDO = tex_color;
}
