set seed 4561
qui do "eq_test.ado"
qui bcuse crime4, clear
local T = 1000
mat define colmat = J(`T', 1, .)
forv g = 1/`T' {
	qui {
		gen randvar = uniform()
		eq_test, models(reg prbarr polpc; reg prbarr polpc randv) coef(e(b)[1,1]; e(b)[1,1]) brep(500) 
		mat colmat[`g', 1] = e(res)[1,1]
		cap drop randvar
		noi di "`g'/`T'"
	}
}
svmat colmat

sort resmat1
gen id = _n
scatter resmat1 id || scatter resmat2 id

