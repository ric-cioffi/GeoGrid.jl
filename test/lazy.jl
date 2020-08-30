using Test
import GeoGrid.lazy_half_grid


function test_bounds(n::Int; factor::Float64 = 2.0)
    return lazy_half_grid(n, factor)[1] == 0 && lazy_half_grid(n, factor)[n] == 1/2
end

@test test_bounds(10)
@test test_bounds(101)
@test_broken test_bounds(10_000)

@test test_bounds(10; factor = 1/2)
@test test_bounds(101; factor = 1/2)
@test test_bounds(10_000; factor = 1/2)
