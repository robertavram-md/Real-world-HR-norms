# Real-world-HR-norms
Code for NPJDIGITALMED-00341R paper

* HR_StatsAnalysis_Plots.ipynb : Contains code for all descriptive statistics, univariable and multivariable models as well as plots used in the paper.
* HR_Validation.ipynb : Contains code for syncing the electrocardiogram and photoplethysmography signal, then derive the correlation.
* SASS Analyses\makeweights.do : Agregates data by 'user_id' for repeat measurements using the methodology described in the paper.
* SASS Analyses\regression models.do : Multivariable models used in the paper. Heteroscedasticity check.
* SASS Analyses\time and resting effects.do : Code for running analyses according to weekday/weekend, season as well as according to the time of day.
* SASS Analyses\within person variability.do : Contains code for describing HRV within person over time.
