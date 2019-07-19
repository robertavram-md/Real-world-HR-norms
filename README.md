# Real-world-HR-norms
Code for NPJDIGITALMED-00341R paper




* HR_StatsAnalysis_Plots.ipynb : Contains code for all descriptive statistics, univariable and multivariable models as well as plots used in the paper.
* HR_Validation.ipynb : Contains code for syncing the electrocardiogram and photoplethysmography signal, then derive the correlation.
* SASS Analyses\makeweights.do : Agregates data by 'user_id' for repeat measurements using the methodology described in the paper.
* SASS Analyses\regression models.do : Multivariable models used in the paper. Heteroscedasticity check.
* SASS Analyses\time and resting effects.do : Code for running analyses according to weekday/weekend, season as well as according to the time of day.
* SASS Analyses\within person variability.do : Contains code for describing HRV within person over time.


Citation and Reference

This work is published in the following paper in Nature Partner Journal Digital Medicine

[Real-world heart rate norms in the Health eHeart study](https://www.nature.com/articles/s41746-019-0134-9)



If you find this code/repo useful for your research please cite:

```
TY  - JOUR
AU  - Avram, Robert
AU  - Tison, Geoffrey H.
AU  - Aschbacher, Kirstin
AU  - Kuhar, Peter
AU  - Vittinghoff, Eric
AU  - Butzner, Michael
AU  - Runge, Ryan
AU  - Wu, Nancy
AU  - Pletcher, Mark J.
AU  - Marcus, Gregory M.
AU  - Olgin, Jeffrey
PY  - 2019
DA  - 2019/06/25
TI  - Real-world heart rate norms in the Health eHeart study
JO  - npj Digital Medicine
SP  - 58
VL  - 2
IS  - 1
AB  - Emerging technology allows patients to measure and record their heart rate (HR) remotely by photoplethysmography (PPG) using smart devices like smartphones. However, the validity and expected distribution of such measurements are unclear, making it difficult for physicians to help patients interpret real-world, remote and on-demand HR measurements. Our goal was to validate HR-PPG, measured using a smartphone app, against HR-electrocardiogram (ECG) measurements and describe out-of-clinic, real-world, HR-PPG values according to age, demographics, body mass index, physical activity level, and disease. To validate the measurements, we obtained simultaneous HR-PPG and HR-ECG in 50 consecutive patients at our cardiology clinic. We then used data from participants enrolled in the Health eHeart cohort between 1 April 2014 and 30 April 2018 to derive real-world norms of HR-PPG according to demographics and medical conditions. HR-PPG and HR-ECG were highly correlated (Intraclass correlation = 0.90). A total of 66,788 Health eHeart Study participants contributed 3,144,332 HR-PPG measurements. The mean real-world HR was 79.1 bpm ± 14.5. The 95th percentile of real-world HR was ≤110 in individuals aged 18–45, ≤100 in those aged 45–60 and ≤95 bpm in individuals older than 60 years old. In multivariable linear regression, the number of medical conditions, female gender, increasing body mass index, and being Hispanic was associated with an increased HR, whereas increasing age was associated with a reduced HR. Our study provides the largest real-world norms for remotely obtained, real-world HR according to various strata and they may help physicians interpret and engage with patients presenting such data.
SN  - 2398-6352
UR  - https://doi.org/10.1038/s41746-019-0134-9
DO  - 10.1038/s41746-019-0134-9
ID  - Avram2019
ER  - 
```
