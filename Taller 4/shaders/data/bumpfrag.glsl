/*
	Normal 			- normal texture
	Base_Height		- Base texture with height map in alpha channel
*/

uniform sampler2D Base;
uniform sampler2D NormalHeight;

varying	vec3 g_lightVec;
varying	vec3 g_viewVec;
varying vec4 vertTexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;
uniform vec4 lightPosition;

attribute vec3 normal;
attribute vec2 texCoord;
attribute vec4 position;

void main()
{

    vec2 cBumpSize = 0.02 * vec2 (2.0, -1.0);
   
	float LightAttenuation = clamp(1.0 - dot(g_lightVec, g_lightVec), 0.0, 1.0);
	vec3 lightVec = normalize(g_lightVec);
	vec3 viewVec = normalize(g_viewVec);
	
	float height = texture2D(NormalHeight, vertTexCoord.st).a;
	height = height * cBumpSize.x + cBumpSize.y;

	vec2 newUV = vertTexCoord.st + viewVec.xy * height;
	vec4 color_base = texture2D(Base,newUV);
	vec3 bump = texture2D(NormalHeight, newUV.xy).rgb * 2.0 - 1.0;
	bump = normalize(bump);
	
	//float base = texture2D(NormalHeight, newUV.xy).a;	
	float base=0.3+(0.7*texture2D(NormalHeight, newUV.xy).a);	
	float diffuse = clamp(dot(lightVec, bump), 0.0, 1.0);
	float specular = pow(clamp(dot(reflect(-viewVec, bump), lightVec), 0.0, 1.0), 16.0);
	
	gl_FragColor = vec4(color_base.rgb * lightPosition.xyz //vec3
					* (diffuse * base + 0.7 * specular * color_base.a)  //float
					* 1.0,1.0);  // float
					//gl_FragColor = vec4(texture2D(NormalHeight, gl_TexCoord[0].xy).a);

	
}