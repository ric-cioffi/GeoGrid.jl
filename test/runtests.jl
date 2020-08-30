using SafeTestsets

@info "Tests started"

@safetestset "geo_grid tests" begin include("geo_grid.jl") end
@safetestset "lazy tests" begin include("lazy.jl") end