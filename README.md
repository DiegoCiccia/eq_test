# eq_test
Stata package for pairwise equality tests of N coefficients from generic regression models. 

# Intro
This package allows the user to test the hypothesis that the coefficients estimated by two different regression models are not statistically different. The program uses bootstrap resampling and runs the regression models on the resulting samples. The procedure ends with a pairwise two-sample t-test across the specified coefficients.

# Setup
```s
net install eq_test, from("https://raw.githubusercontent.com/DiegoCiccia/eq_test/main") replace
```

# Example
```s
set seed 45612
bcuse crime4, clear
gen randvar = uniform()
eq_test, models(reg prbarr polpc; reg prbarr polpc randv; reg prbarr polpc crmrte) coef(e(b)[1,1]; e(b)[1,1]; e(b)[1,1]) brep(500)
```
