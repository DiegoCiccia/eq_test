set seed 4561
qui do "eq_test.ado"
qui bcuse crime4, clear
local T = 10
mat define colmat = J(`T', 1, .)
gen randvar = uniform()
eq_test, models(reg prbarr polpc; reg prbarr polpc randv) coef(e(b)[1,1]; e(b)[1,1]) brep(500) 

