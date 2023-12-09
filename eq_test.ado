cap program drop eq_test
program define eq_test, eclass
qui {
syntax , models(string) brep(string) [coef(string) cluster(string)] 
local n_mod = length("`models'") - length(subinstr("`models'", ";", "", .)) + 1
if substr("`models'", length("`models'"), 1) != ";" {
    local models = "`models';"
} 
if "coef'" != "" & substr("`coef'", length("`coef'"), 1) != ";" {
    local coef = "`coef';"
} 
forv j = 1/`n_mod' {
    local eq_`j' = strtrim(substr("`models'", 1, strpos("`models'", ";") - 1))
    local models = substr("`models'", strpos("`models'", ";") + 1, .)
    if "`coef'" != "" {
        local coef_`j' = strtrim(substr("`coef'", 1, strpos("`coef'", ";") - 1))
        local coef = substr("`coef'", strpos("`coef'", ";") + 1, .)
    }
}
forv i = 1/`n_mod' {
    if "`coef'" != "" {
        `eq_`i''
        local k`i' = `coef_`i''
    }
    else {
        `eq_`i''
        local k`i' = e(b)[1,1]
    }
}
noi di ""
forv i = 1/`n_mod' {
    local model = abbrev("`eq_`i''", 30) + (30 - length("`eq_`i''")) * " "
    local coefs : di %9.4fc `k`i''
    noi di "{text: Model `i'}: `model' {text: Coeff. `i'}: `coefs'"
}
noi di ""
noi di "Bootstrap reps: `brep'. Each dot below is 50 reps."

matrix define resmat = J(`brep', `n_mod', .) 
if "`strata'" != "" {
    local byopt = "cluster(`strata')"
}
forv j = 1/`brep' {
    preserve
    bsample, `byopt'
    forv i = 1/`n_mod' {
        if "`coef'" != "" {
            `eq_`i''
            matrix resmat[`j', `i'] = `coef_`i''
        }
        else {
            `eq_`i''
            matrix resmat[`j', `i'] = e(b)[1,1]
        }
    }
    restore
    if mod(`j', 50) == 0 {
        noi di as text "." _continue
    }
}
cap drop resmat*
svmat resmat 
mat define results = J(`=`n_mod'-1', `=`n_mod'-1', .)
local irow = 1
forv i = 1/`=`n_mod' -1' {
    local icol = `irow'
    local rows `rows' `i'
    forv j = `=`i' + 1'/`n_mod' {
        gen diff_`i'`j' = resmat`i' - resmat`j'
        sum diff_`i'`j'

        mat results[`irow', `icol'] = 1 - t(`brep', `= abs((`k`i'' - `k`j'')/`r(sd)')') + t(`brep', `= - abs((`k`i'' - `k`j'')/`r(sd)')')
        local icol = `icol' + 1
        drop diff_`i'`j'
    }
    local irow = `irow' + 1
}
forv j = 2/`n_mod' {
    local cols `cols' `j'
}
}
di _newline
di "`type' equality tests (p values):"
mat coln results = `cols'
mat rown results = `rows'
matlist results, format(%9.4fc)
ereturn matrix res = results
cap drop resmat*
end
