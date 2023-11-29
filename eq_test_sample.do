set seed 45612
bcuse crime4, clear
gen randvar = uniform()
eq_test, models(reg prbarr polpc; reg prbarr polpc randv; reg prbarr polpc crmrte) coef(e(b)[1,1]; e(b)[1,1]; e(b)[1,1]) brep(1000)