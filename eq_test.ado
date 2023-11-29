cap program drop eq_test
program define eq_test, rclass
qui {
syntax , models(string) coef(string) brep(string) [strata(string)]
local n_mod = length("`models'") - length(subinstr("`models'", ";", "", .)) + 1
if substr("`models'", length("`models'"), 1) != ";" {
    local models = "`models';"
} 
if substr("`coef'", length("`coef'"), 1) != ";" {
    local coef = "`coef';"
} 
forv j = 1/`n_mod' {
    local eq_`j' = strtrim(substr("`models'", 1, strpos("`models'", ";") - 1))
    local models = substr("`models'", strpos("`models'", ";") + 1, .)
    local coef_`j' = strtrim(substr("`coef'", 1, strpos("`coef'", ";") - 1))
    local coef = substr("`coef'", strpos("`coef'", ";") + 1, .)
}

noi di ""
forv i = 1/`n_mod' {
    noi di "{text: Model `i'}: `eq_`i''"
}
noi di ""
noi di "Bootstrap reps: `breps'. Each dot below is 50 reps."

matrix define resmat = J(`brep', `n_mod', .) 
if "`strata'" != "" {
    local byopt = "by(`strata')"
}
forv j = 1/`brep' {
    preserve
    bsample `=_N', `byopt'
    forv i = 1/`n_mod' {
        `eq_`i''
        matrix resmat[`j', `i'] = `coef_`i''
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
        di `i', `j'
        ttest resmat`i' == resmat`j'
        mat results[`irow', `icol'] = r(p)
        local icol = `icol' + 1
    }
    local irow = `irow' + 1
}
forv j = 2/`n_mod' {
    local cols `cols' `j'
}
}
di _newline
di "Pairwise equality tests (p values):"
mat coln results = `cols'
mat rown results = `rows'
matlist results, format(%9.4fc)
end
