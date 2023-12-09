// Example
// D depends on S, so the coefficient on D is economically insignificant when we control for S
// D and X are independent, hence the coefficient on D will not change once we control for S

set seed 4561
clear 
local G = 10000
set obs `G'
gen S = uniform()
gen D = (_n > `G'/2) * (S > 0.5)
gen Y = uniform() * (1 + D * uniform() + S * 10 * uniform())
gen X = uniform()
eq_test, models(reg Y D; reg Y D S; reg Y D X) coef(e(b)[1,1]; e(b)[1,1]; e(b)[1,1]) brep(500) 