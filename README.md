# eq_test
Stata package for bootstrap equality tests of N coefficients from generic regression models. 

# Intro
This package allows the user to test the hypothesis that the coefficients estimated by two among N different regression models are not statistically different. The program uses bootstrap resampling to compute standard errors for the difference of the estimated coefficients. 

# Setup
```s
net install eq_test, from("https://raw.githubusercontent.com/DiegoCiccia/eq_test/main") replace
```

# Example
```s
set seed 4561
clear 
local G = 10000
set obs `G'
gen S = uniform()
gen D = (_n > `G'/2) * (S > 0.5)
gen Y = uniform() * (1 + D * uniform() + S * 10 * uniform())
gen X = uniform()
eq_test, models(reg Y D; reg Y D S; reg Y D X) brep(500) 
```
