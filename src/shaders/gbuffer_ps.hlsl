cbuffer variables : register(b0)
{
	float2 viewport_size;
	float4 mouse;
	float brush_size;
};

struct gbuffer
{
	float4 position : SV_POSITION;
	float4 normal : NORMAL;
	float4 brush : COLOR;
};

struct render_targets
{
	float4 normal : SV_TARGET0;
	float4 brush : SV_TARGET1;
};

render_targets main(gbuffer input)
{
	render_targets output;
	output.normal.xy = mouse.xy;
	output.normal.w = 1;

	output.brush = distance(input.position.xy, mouse.xy * viewport_size) < brush_size ? 1 : 0;
	return output;
}