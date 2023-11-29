bcuse crime4, clear
eq_test, models(reg prbarr polpc; reg prbarr polpc central; reg prbarr polpc crmrte prbconv) ///
coef(e(b)[1,1]; e(b)[1,1]; e(b)[1,1]) brep(500)