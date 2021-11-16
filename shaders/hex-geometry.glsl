#version 450 core

layout (points) in;
layout (triangle_strip, max_vertices = 24) out;

in VS_OUT {
     flat float hex_radius;
     flat int hex_state;
} gs_in[];

uniform mat4 obj_transform = mat4(1);
uniform mat4 view_transform = mat4(1);;

uniform vec4 color0 = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color1 = vec4(0.0, 1.0, 0.0, 1.0);

flat out vec4 diffuse_color;

vec4 poly_vert(vec2 center, float radius, float angle0, int sides, int num) {
     float this_theta = angle0 + num * 2 * 3.141592654 / sides;
     return vec4(center.xy + vec2( 0.9 * radius * cos(this_theta),
                                  0.9 * radius * sin(this_theta)),
                 0,
                 1);
}

void main() {
     mat4 final_transform = view_transform * obj_transform;
     vec2 center = gl_in[0].gl_Position.xy;

     float radius = gs_in[0].hex_radius;
     int state = gs_in[0].hex_state;
     int sides = 6;
     float this_theta;

     float angle0 = 0.737;
     vec4 hex_color = vec4(1,1,1,1);
     if (state == 0) {
          hex_color = color0;
     } else {
          hex_color = color1;
     }
     for (int i = 0; i < 6; ++i) {
          diffuse_color = hex_color;
          gl_Position = final_transform * vec4(center, 0, 1);
          EmitVertex();

          diffuse_color = hex_color;
          gl_Position =  final_transform * poly_vert(center, radius, angle0, sides, i);
          EmitVertex();

          diffuse_color = hex_color;
          gl_Position = final_transform * poly_vert(center, radius, angle0, sides, i+1);
          EmitVertex();

          EndPrimitive();
     }

     diffuse_color = hex_color;
     gl_Position = final_transform * vec4(0, 0, 0, 1);
     EmitVertex();

     diffuse_color = hex_color;
     gl_Position =  final_transform * poly_vert(center, radius, angle0, sides, sides-1);
     EmitVertex();

     diffuse_color = hex_color;
     gl_Position = final_transform * poly_vert(center, radius, angle0, sides, 0);
     EmitVertex();

     EndPrimitive();
}