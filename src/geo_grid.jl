"""
    geo_grid(start, stop; length::Int, α::Float64 = log(length)/(length + log(length)), denser = :min)

Construct a geometrically-spaced vector from `start` to `stop` of size `length`, with the distance between successive points increasing by a constant `factor`.



The `denser` keyword argument can only take values `:min`, `:mid`, `:max`, `:both` with the following specifications: \n
- `:min`  => the grid is denser around x_min (default option)
- `:mid`  => the grid is symmetric and denser around the midpoint
- `:max`  => the grid is denser around x_max
- `:both` => the grid is symmetric and denser around the two endpoints

# Examples
```julia-repl
julia> gen_grid(0, 10; length = 6, denser = :max)
6-element Array{Float64,1}:
  0.0               
  2.8998369960845483
  5.2575129727858165
  7.174391755496612 
  8.732885926840664 
 10.0  

julia> v = HACT.gen_grid(0, 1/2; length = 5, factor = 2)
5-element Array{Float64,1}:
 0.0                
 0.03333333333333333
 0.1                
 0.23333333333333334
 0.5                

julia> diff(v)
4-element Array{Float64,1}:
 0.03333333333333333
 0.06666666666666668
 0.13333333333333333
 0.26666666666666666
```

"""
function geo_grid(start, stop; length::Int, factor = 1 + log(length)/(length + log(length)), denser::Symbol = :min)
    # Note: having a factor that decreases with length avoids extremely small intervals for long vectors
    if denser ∉ (:min, :max, :both, :mid)
        DomainError(denser, "keywork argument 'denser' can only take values in {:min, :mid, :max, :both}") |> throw
    end
    if factor == 1
        return range(start, stop, length = length) |> collect
    elseif factor > 0
        return _gen_grid(start, stop, Val(denser); n = length, α = float(factor))
        # Note: float conversion only tries to avoid possible overflow errors
    else
        DomainError(factor, "kewyord argument `factor` must be positive") |> throw
    end
end

function gen_half_grid(n::Int, α)
    grid = [0.0]
    baseline = 0.5*(α - 1)/(α^(n - 1) - 1)
    for k = 1:(n - 1)
        x = baseline + α*grid[end]
        push!(grid, x)
    end
return grid
end
function complete_grid!(grid, n)
    if iseven(n)
        grid .*= (1 - grid[end - 1])*2
        pop!(grid)
        append!(grid, 1 .- reverse(grid, dims = 1))
    else
        append!(grid, 1 .- reverse(grid[1:(end - 1)], dims = 1))
    end
end


function _gen_grid(x_min, x_max, denser::Val{:min}; n, α)
    grid = gen_half_grid(n, α)
    grid = x_max*2*grid + x_min*(1 .- 2*grid)
end
function _gen_grid(x_min, x_max, denser::Val{:max}; n, α)
    grid = gen_half_grid(n, α)
    grid = reverse(0.5 .- grid, dims = 1)
    grid = x_max*2*grid + x_min*(1 .- 2*grid)
end
function _gen_grid(x_min, x_max, denser::Val{:both}; n, α)
    grid = gen_half_grid(div(n, 2) + 1, α)
    complete_grid!(grid, n)
    grid = x_max*grid + x_min*(1 .- grid)                                       # rescale grid
end
function _gen_grid(x_min, x_max, denser::Val{:mid}; n, α)
    grid = gen_half_grid(div(n, 2) + 1, α)
    grid = 0.5 .- reverse(grid, dims = 1)
    complete_grid!(grid, n)
    grid = x_max*grid + x_min*(1 .- grid)                                       # rescale grid
end