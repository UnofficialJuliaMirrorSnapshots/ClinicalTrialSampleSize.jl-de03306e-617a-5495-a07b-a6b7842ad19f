"""
$(TYPEDEF)

Two sample equivalence test for proportion

Constructors
------------
* `TwoSamplePropEqual(p1::Real, p2::Real, k::Real, delta::Real)`

Arguments
---------
* `p1`: Proportion of group 1

* `p2`: Proportion of group 2

* `k`: Allocation ratio of the groups, k = n(group1) / n(group 2)

* `delta`: Superiority Margin

Fields
------
$(FIELDS)
"""
type TwoSamplePropEqual <: TrialTest
    p1::Real
    p2::Real
    k::Real
    delta::Real

    # Validator
    function TwoSamplePropEqual(p1, p2, k, delta)

        if !((0 < p1 < 1) & (0 < p2 < 1))

            error("Proportion values must be in (0, 1)")

        end # end if

        if !(0 < k < Inf)

            error("Allocation ratio must be in (0, Inf)")

        end # end if

        if !(0 <= delta < 1)

            error("The superiority margin δ must be in [0, 1)")

        end # end if

        new(p1, p2, k, delta)

    end # end function

end # function


# Two sample equivalence test for proportion
function hypotheses{T <: TwoSamplePropEqual}(test::T, n::Real, std::Union{Real, Tuple{Real, Real}, Void}, alpha::Real, side::String)

    diff = abs(test.p1 - test.p2) - test.delta
    se = sqrt(1 / (test.k * n) * test.p1 * (1 - test.p1) + 1 / n * test.p2 * (1 - test.p2))
    z = diff / se
    p = 2 * (cdf(ZDIST, z - quantile(ZDIST, 1 - alpha)) + cdf(ZDIST, -z - quantile(ZDIST, 1 - alpha))) - 1
    return p

end # end function
