cbuffer variables : register(b0)
{
	float2 viewport_size;
	float4 mouse;
	float brush_size;
};

struct gbuffer
{
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD;
};

struct render_targets
{
	float4 brush : SV_TARGET0;
};

render_targets main(gbuffer input)
{
	render_targets output;
	output.brush = distance(input.position.xy, mouse.xy * viewport_size) < brush_size ? 1 : 0;
	return output;
}