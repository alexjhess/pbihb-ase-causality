This document contains a summary of the code review performed by Dina von Werder.

The goals of the code review were defined by Alex Hess and Dina von Werder.
The first round of code review was finished on 03.05.2024 by Dina von Werder. 
See results below.

# Code review overview

## Basics

-   The code review was based on the instructions in README.md of the main branch
at commit 371ea802d873127eb95afe58d1b2a2c77c193dd7.

## Code Setup for Code Review

1.   Created a new branch codeReview where all changes related to the code review are stored.
     Use that branch for all code review activities.
2.   For local analysis use locally installed software versions (RStudio 2023.12.1+402 and R 4.3.3, MacOS Ventura 13.3.1)
3.   For analysis on binder use version created at commit  371ea802d873127eb95afe58d1b2a2c77c193dd7

## Running Code

Run the analysis on binder according to description in the README.md.

In this code review the following parts of the Code are reviewed:
1. Complete run of analysis
2. Sanity checks for dataset and analysis.


Additionally the analysis was run locally on MacOS Ventura 13.3.1. 

## Objectives for part 1 (Checkpoints)

1. Does pipeline run through for different user on fresh copy of data?

When running the code on binder: :white_check_mark:  
everything runs through, however, calls of gcm.test() (GeneralisedCovarianceMeasure package) and CondIndTest() (CondIndTests package) both take very long (>10min per test).

When running the code locally: :white_check_mark: :warning:  
problems: Restoring the R project environment (renv) did not work (presumably due to differences in operating systems), error installing package 'MASS' / install of package 'MASS' failed [error code 1].  
R Studio automatically suggested installation of packages (bnlearn, GeneralisedCovarianceMeasure and CondIndTests). When installing the aforementioned packages separately, pipeline runs through without errors.

     
2. Are the final results the same as in the paper draft? (Figure 1, Table 1 to 3, Table A1 and A2) 

When running analysis on binder:   
- Figure 1: :white_check_mark:   
- Table 1: :white_check_mark:        
- Table 2:  
	- linear regression: :white_check_mark:    
	- propensity score: typo fixed for lower bound of confidence interval different (-0.717 when running on binder and locally)  
	- DML: results not reproducible. Solved issue by fixing seed in line 155 of main.R (Results now reproducible) 
- Table 3:  
	- linear regression: rounding error fixed for upper bound of confidence interval (-0.099)
	- propensity score: :white_check_mark:  
	- DML: :white_check_mark:  
- Table A1 & A2: 
	- linear regression: :white_check_mark:  
	- propensity score: :white_check_mark:  
	- DML: :white_check_mark:  

All results were reproducible also when running locally on Mac, however, with slight differences for DML (qualitatively results stayed the same).  

## Objectives for part 2 (Checkpoints)
1. Check plausibility of questionnaire scores. :white_check_mark:  
2. Standardization of data for hypothesis 2 and 3. :white_check_mark:  
3. Check usage of conditional independence functions and linear model. :white_check_mark:  


Other points: None.
