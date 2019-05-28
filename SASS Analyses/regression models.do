global boxdata "~/Box Sync/HeH Heart Rate (Eric Vittinghoff)/New Analyses/main files"
global here "~"

set tracedepth 1
set trace off

cd "$here"
cap log close
log using "regression models", replace

	qui import delimited using ///
		"$boxdata/multivariable_model_1.csv", ///
		clear varnames(1) delim(",") 
	qui gen consent_age_10 = age/10
	regress geomean_bpm consent_age_10 i.sex i.new_race disease_sum ///
		mean_steps24h_1000 bmi [pw=wt_bpm], cformat(%8.2f)
		
	* collinearity check
	estat vif
	
	* checks for heterosckedasticity
	qui predict fitted
	qui predict resid, resid
	foreach x in sex new_race {
		tabstat resid, by(`x') s(n var) format(%8.3g)
		}		
	twoway (scatter resid fitted, sort msymbol(point) msize(vtiny)), ///
		plotregion(style(none)) yline(0) ytitle("") ///
		title("Residuals Versus Fitted") ///
		legend(off) name(rvf1, replace)
	graph export rvf1.pdf, replace
	foreach x in consent_age_10 disease_sum mean_steps24h_1000 bmi {
		twoway (scatter resid `x', sort msymbol(point) msize(vtiny)), ///
			plotregion(style(none)) yline(0) ytitle("") ///
			title("Residuals Versus Predictor") ///
			legend(off) name(rvp_`x'1, replace)
		graph export rvp_`x'1.pdf, replace
		}
		
	qui import delimited using "$boxdata/multivariable_model_2.csv", ///
		clear varnames(1) delim(",")  
	qui gen consent_age_10 = age/10
	regress geomean_bpm consent_age_10 i.sex i.new_race ///
		diabetes arrhythmia sleep_apnea ccb copd asthma hbp high_chol ///
		beta_agonist beta_blocker amiodarone pvd heart_attack blockages ///
		stroke chf [pw=wt_bpm], cformat(%8.2f)
		
	* collinearity checks
	estat vif
	
	* checks for heterosckedasticity
	qui predict fitted
	qui predict resid, resid
	foreach x in sex new_race ///
		diabetes arrhythmia sleep_apnea ccb copd asthma hbp high_chol ///
		beta_agonist beta_blocker amiodarone pvd heart_attack blockages ///
		stroke chf {
		tabstat resid, by(`x') s(n var) format(%8.3g) nototal
		}		
	twoway (scatter resid fitted, sort msymbol(point) msize(vtiny)), ///
		plotregion(style(none)) yline(0) ytitle("") ///
		title("Residuals Versus Fitted") ///
		legend(off) name(rvf2, replace)
	graph export rvf2.pdf, replace
	foreach x in consent_age_10 {
		twoway (scatter resid `x', sort msymbol(point) msize(vtiny)), ///
			plotregion(style(none)) yline(0) ytitle("") ///
			title("Residuals Versus Predictor") ///
			legend(off) name(rvp_`x'2, replace)
		graph export rvp_`x'2.pdf, replace
		}

log close
