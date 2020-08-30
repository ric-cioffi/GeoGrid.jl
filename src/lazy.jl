using Lazy

# TODO: (1) Try to make recursive

function lazy_half_grid(n::Int, α)
    baseline = 0.5*(α - 1)/(α^(n - 1) - 1)
    return @>> Lazy.range() map(x -> baseline*sum(α^(j - 1) for j = 1:x)) prepend(0) take(n)
end

function lazy_half_grid_recursive(n::Int, α)
    baseline = 0.5*(α - 1)/(α^(n - 1) - 1)
    return @>> iterated(x -> baseline + α*x, baseline) prepend(0) take(n)
end