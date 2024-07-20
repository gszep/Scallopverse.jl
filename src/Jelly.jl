using WaterLily
using StaticArrays
using LinearAlgebra
function hover(L=2^3; Re=25, U=1, amp=π / 4, ϵ=0.5, thk=2ϵ + √2, mem=mem)
    # Line segment SDF
    function sdf(x, t)
        y = x #.- SA[0, clamp(x[2], -L / 2, L / 2)]
        norm(y) - thk / 2 + sin(t)
    end
    # Oscillating motion and rotation
    function map(x, t)
        α = amp * cos(t * U / L)
        R = SA[cos(α) sin(α); -sin(α) cos(α)]
        R * (x - SA[3L-L*sin(t * U / L), 4L])
    end
    Simulation((6L, 6L), (0, 0), L; U, ν=U * L / Re, body=AutoBody(sdf, map), ϵ, mem=mem, perdir=(2,))
end

function geom!(d, sim, t=WaterLily.time(sim))
    a = sim.flow.σ
    WaterLily.measure_sdf!(a, sim.body, t)
    copyto!(d, a[inside(a)]) # copy to CPU
end

function ω!(d, sim)
    a, dt = sim.flow.σ, sim.L / sim.U
    @inside a[I] = WaterLily.curl(3, I, sim.flow.u) * dt
    copyto!(d, a[inside(a)]) # copy to CPU
end

using CUDA, GLMakie
Makie.inline!(false)
CUDA.allowscalar(false)
begin
    # Define geometry and motion on GPU
    sim = hover(mem=CUDA.CuArray)
    sim_step!(sim, sim_time(sim) + π)

    # Create CPU buffer arrays
    a = sim.flow.σ
    d = similar(a, size(inside(a))) |> Array # one quadrant

    # Set up observables
    geom = geom!(d, sim) |> Observable
    ω = ω!(d, sim) |> Observable

    figure = Figure()
    ax = Axis(figure[1, 1])

    contourf_plot = contourf!(ax, lift(x -> asinh.(x), ω), colormap=:RdBu_11, levels=range(-5, 5, length=10))
    Colorbar(figure[1, 2], contourf_plot)
    contour!(ax, geom; levels=[0], color=:black)

    figure
end

for i in 1:30
    sim_step!(sim, sim_time(sim) + 0.5)
    geom[] = geom!(d, sim)
    ω[] = ω!(d, sim)
end