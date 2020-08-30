using Lazy

# TODO: (1) Try to make recursive

function lazy_half_grid(n::Int, α)
    n -= 1
    baseline = 0.5*(α - 1)/(α^n - 1)
    grid = @>> Lazy.range() map(x -> baseline*sum(α^(j - 1) for j = 1:x)) prepend(0)
end