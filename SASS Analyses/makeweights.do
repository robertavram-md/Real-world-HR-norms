cap program drop makeweights
program define makeweights

	qui import delimited using "$boxdata/multivariable_model_2.csv", ///
		clear varnames(1) delim(",") 
	drop v1
	qui save covars, replace

	qui import delimited using "$boxdata/azumio_full_steps_resting.csv", ///
		clear varnames(1) delim(",") 
	keep user_id resting bpm rmssd sdsd steps24h timestamp_pacific
	
	*subsample user_id, pct(5) // used to debug program
	
	rename resting tmp
	qui gen resting = cond(tmp=="True",1,0) if ~missing(tmp)
	drop tmp
	label define yesno 1 "yes" 0 "no"
	label var resting yesno
	
	qui gen hour = real(substr(timestamp_pacific,12,2))
	qui gen min = real(substr(timestamp_pacific,15,2))
	qui gen sec = real(substr(timestamp_pacific,18,2))
	qui gen time = hour+min/60+sec/3600
	qui recode time (min/6=1 "12am-6am") (6/12=2 "6am-12pm") ///
		(12/18=3 "12pm-6pm") (18/24=4 "6pm-12am"), gen(timecat)
	drop timestamp_pacific hour min sec

	qui destring bpm, force replace
	qui keep if inrange(bpm,20,220)
	
	qui gen logbpm = log(bpm)
	foreach x of varlist rmssd sdsd steps24h {
		qui gen log`x' = log(`x'+1)  // add one to keep zeros
		}
	
	* get ICCs
	foreach y in bpm rmssd sdsd steps24h {
		mixed log`y' || user_id:, nostd
		estat icc
		local icc_`y' = r(icc2)
		}
		
	* get means, counts, and medians by user_id and export as csv
	* overall
	preserve
	collapse ///
		(mean) logmean_bpm=logbpm logmean_rmssd=logrmssd logmean_sdsd=logsdsd ///
			logmean_steps24h=logsteps24h /// 
		(count) n_bpm=bpm n_rmssd=rmssd n_sdsd=sdsd n_steps24h=steps24h ///
		(sd) sd_bpm=bpm (min) min_bpm=bpm (max) max_bpm=bpm ///
		, by(user_id)
		
	* exponentiate log-scale means to geometric means
	foreach y in rmssd sdsd steps24h {
		qui gen geomean_`y' = exp(logmean_`y')-1
		}
	qui gen geomean_bpm = exp(logmean_bpm)
	drop logmean_*
	qui gen range_bpm = max_bpm-min_bpm
	
	* calculate weights
	foreach y in bpm rmssd sdsd steps24h {
		qui gen wt_`y' = n_`y'/(1+`icc_`y''*(n_`y'-1))
		qui sum wt_`y'
		qui replace wt_`y' = wt_`y'*r(N)/r(sum)
		}
	
	* add covariates
	qui merge 1:1 user_id using covars, nogen keep(3)
	
	*export as CSV file
	export delimited user_id ///
		geomean_* n_* wt_* sd_bpm range_bpm sex-chf ///
		using "$boxdata/geomeans_overall.csv", ///
		delim(",") replace 
	restore
			
	* stratified by time category and resting
	preserve
	collapse ///
		(mean) logmean_bpm=logbpm logmean_rmssd=logrmssd logmean_sdsd=logsdsd ///
			logmean_steps24h=logsteps24h /// 
		(count) n_bpm=bpm n_rmssd=rmssd n_sdsd=sdsd n_steps24h=steps24h ///
		(sd) sd_bpm=bpm (min) min_bpm=bpm (max) max_bpm=bpm ///
		, by(user_id timecat resting)
		
	* exponentiate log-scale means to geometric means
	foreach y in rmssd sdsd steps24h {
		qui gen geomean_`y' = exp(logmean_`y')-1
		}
	qui gen geomean_bpm = exp(logmean_bpm)
	drop logmean_*
	qui gen range_bpm = max_bpm-min_bpm
	
	* calculate weights
	foreach y in bpm rmssd sdsd steps24h {
		qui gen wt_`y' = n_`y'/(1+`icc_`y''*(n_`y'-1))
		qui sum wt_`y'
		qui replace wt_`y' = wt_`y'*r(N)/r(sum)
		}
		
	* add covariates
	qui merge m:1 user_id using covars, nogen keep(3)
	
	*export as CSV file
	export delimited user_id timecat resting ///
		geomean_* n_* wt_* sd_bpm range_bpm sex-chf ///
		using "$boxdata/geomeans_timecat_resting.csv", ///
		delim(",") replace 
	restore
	erase covars.dta
	
	end

global boxdata "~/Box Sync/HEH Heart Rate/New Analyses/main files"
global here "~/work/parnassus/olgin/avram/HEH Heart Rate/programs"

set tracedepth 1
set trace off

cd "$here"
cap log close
log using makeweights, replace
makeweights
log close
