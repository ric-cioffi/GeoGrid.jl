using Test
import GeoGrid.geo_grid

ffactor(x) = diff(x)[2:end]./diff(x)[1:end-1]

################################################################################
# Argument tests

function test_bounds(x_min, x_max; length::Int, kwargs...)
    x = geo_grid(x_min, x_max; length = length, kwargs...)
    return minimum(x) ≈ x_min && maximum(x) ≈ x_max
end
@test test_bounds(0, 1; length = 20)                                            # easy test


function test_factor(x_min, x_max; length::Int, factor, kwargs...)
    x = geo_grid(x_min, x_max; length = length, factor = factor, kwargs...)
    x_factor = ffactor(x)
    return isapprox.(x_factor, factor) |> all
end
@test test_factor(0, 1; length = 20, factor = 2)                                # easy test
@test test_factor(0, 1; length = 200, factor = 10)                              # test for integer overflow

function test_length(x_min, x_max; length::Int, kwargs...)
    x = geo_grid(x_min, x_max; length = length, kwargs...)
    return Base.length(x) == length
end
@test test_length(0, 1; length = 20)                                            # easy test

function test_denser(x_min, x_max; length::Int, denser, kwargs...)
    x = geo_grid(x_min, x_max; length = length, denser = denser)
    if denser == :min
        return (ffactor(x) .>= 1) |> all
    elseif denser == :max
        return (ffactor(x) .<= 1) |> all
    elseif denser == :both
        f = ffactor(x)
        return (f[1] >= 1 && f[end] <= 1)
    elseif denser == :mid
        return (f[1] <= 1 && f[end] >= 1)
    end
end


################################################################################
# Other tests

function test_inbounds(x_min, x_max; length::Int, kwargs...)
    x = geo_grid(x_min, x_max; length = length, kwargs...)
    return (@. x_min <= x <= x_max) |> all
end
@test test_inbounds(0, 1; length = 20)                                          # easy test