global boxdata "~/Box Sync/HEH Heart Rate/New Analyses/main files"
global here "~/work/parnassus/olgin/avram/HEH Heart Rate/programs"

set tracedepth 1
set trace off

cd "$here"
cap log close
log using "within person variability", replace

	qui import delimited using ///
		"$boxdata/geomeans_overall.csv", ///
		clear varnames(1) delim(",") 
	
	tabstat sd_bpm range_bpm, s(n mean sd min p25 p50 p75 max) format(%8.3g)

log close
