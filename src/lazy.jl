using Lazy

# TODO: (1) Try to make recursive

function lazy_half_grid(n::Int, α)
    base = 0.5*(α - 1)/(α^(n - 1) - 1)
    return @>> Lazy.range() map(x -> base*sum(α^(j - 1) for j = 1:x)) prepend(0) take(n)
end

function lazy_half_grid_recursive(n::Int, α)
    base = 0.5*(α - 1)/(α^(n - 1) - 1)
    return @>> iterated(x -> base + α*x, base) prepend(0) take(n)
end

function lazy_half_grid_generator(n::Int, α)
    base = 0.5*(α - 1)/(α^(n - 1) - 1)
    prev = 0.0
    cur = base
    ret = Base.Generator(Iterators.cycle(true)) do _
        out = prev
        prev, cur = (cur, base + α*cur)
        out
    end
    return @> ret Base.Iterators.take(n)
end

function lazy_half_grid_mapped(n::Int, α)
    base = 0.5*(α - 1)/(α^(n - 1) - 1)
    mappedarray(x -> x == 0 ? 0.0 : base*sum(α^(j - 1) for j = 1:x), 0:(n - 1))
end