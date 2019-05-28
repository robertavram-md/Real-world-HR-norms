global boxdata "~/Box Sync/HEH Heart Rate/New Analyses/main files"
global here "~/work/parnassus/olgin/avram/HEH Heart Rate/programs"

set tracedepth 1
set trace off

cd "$here"
cap log close
log using "time and resting effects", replace

	qui import delimited using ///
		"$boxdata/geomeans_timecat_resting.csv", ///
		clear varnames(1) delim(",") 
		
	rename timecat tmp
	encode tmp, gen(timecat)
	
	* select for complete data
	foreach x of varlist geomean_bpm resting timecat ///
		consent_age sex new_race ///
		diabetes arrhythmia sleep_apnea copd asthma hbp ///
		high_chol pvd heart_attack blockages stroke chf ///
		beta_* amiodarone {
		qui drop if missing(`x')
		}
		
	regress geomean_bpm i.resting [pw=wt_bpm], ///
		vce(cluster user_id) cformat(%8.2f)			
	
	regress geomean_bpm i.resting ///
		consent_age sex i.new_race ///
		diabetes arrhythmia sleep_apnea copd asthma hbp ///
		high_chol pvd heart_attack blockages stroke chf ///
		beta_* amiodarone  ///
		[pw=wt_bpm], vce(cluster user_id) cformat(%8.2f) 
		
	regress geomean_bpm i.timecat [pw=wt_bpm], ///
		vce(cluster user_id) cformat(%8.2f)			
	
	regress geomean_bpm i.timecat ///
		consent_age sex i.new_race ///
		diabetes arrhythmia sleep_apnea copd asthma hbp ///
		high_chol pvd heart_attack blockages stroke chf ///
		beta_* amiodarone ///
		[pw=wt_bpm], vce(cluster user_id) cformat(%8.2f) 
		
	regress geomean_bpm i.resting i.timecat [pw=wt_bpm], ///
		vce(cluster user_id) cformat(%8.2f)
	
	regress geomean_bpm i.resting i.timecat ///
		consent_age sex i.new_race ///
		diabetes arrhythmia sleep_apnea copd asthma hbp ///
		high_chol pvd heart_attack blockages stroke chf ///
		beta_* amiodarone  ///
		[pw=wt_bpm], vce(cluster user_id) cformat(%8.2f) 

log close
