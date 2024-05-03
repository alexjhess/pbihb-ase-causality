#### CAUSALITY course project #####
### Causality in the ASE theory ###
## Analysis using PBIHB data set ##


## set working directory to path of 'pbihb-ase-causality' repo
getwd() # print wd (double-check)

## load data set
ase_pbihb_data <- read.csv(file.path("data", "ase_pbihb_data.txt"))
ase_pbihb_data <- subset(ase_pbihb_data, select = -c(9, 10))

## bring data into correct format
dat <- transform(ase_pbihb_data, gender = as.factor(gender), 
                 age = as.numeric(age), FSS = as.numeric(FSS), 
                 MAIA_38 = as.numeric(MAIA_38), GSES = as.numeric(GSES), 
                 CESD = as.numeric(CESD))

## standardize variables (subtract mean, divide by stdev)
ase_pbihb_data <- data.frame(scale(ase_pbihb_data))
ase_pbihb_data <- transform(ase_pbihb_data, gender = as.factor(gender), 
                            age = as.numeric(age), FSS = as.numeric(FSS), 
                            MAIA_38 = as.numeric(MAIA_38), GSES = as.numeric(GSES), 
                            CESD = as.numeric(CESD))

# visualise: matrix of scatterplots
pairs(dat[, c(1:6)], 
      labels = c("gender", "age", "FSS", "MAIA_38", "GSES", "CES-D"),
      font.labels = 1
      )


#######################################
#### H1: test cond. indep. in ASE #####
#######################################

## load packages for cond ind tests
library(bnlearn) #mi-cg
library(GeneralisedCovarianceMeasure) #GCM
library(CondIndTests) #KCI


## i)

# M d-sep S | A,G
ci.test(x="MAIA_38", y="GSES", z=c("age","gender"), data=dat,
        test="mi-cg")
gcm.test(X=dat$MAIA_38, Y=dat$GSES, Z=cbind(dat$age, dat$gender), alpha = 0.01)
CondIndTest(Y=dat$MAIA_38, E=dat$GSES, X=cbind(dat$age, dat$gender),
            method = "KCI", alpha = 0.01, # "KCI", "InvariantConditionalQuantilePredict"InvariantEnvironmentPrediction", "InvariantResidualDistributionTest", "InvariantTargetPrediction", "ResidualPredictionTest"
            parsMethod = list(), verbose = FALSE)


## ii)

# M d-sep D | F, A, G
ci.test(x="MAIA_38", y="CESD", z=c("FSS","age","gender"), data=dat,
              test="mi-cg")
gcm.test(X=dat$MAIA_38, Y=dat$CESD, Z=cbind(dat$FSS, dat$age, dat$gender), alpha = 0.01)
CondIndTest(Y=dat$MAIA_38, E=dat$CESD, X=cbind(dat$FSS, dat$age, dat$gender),
            method = "KCI", alpha = 0.01,
            parsMethod = list(), verbose = FALSE)

# M d-sep D | F, A, G, S
ci.test(x="MAIA_38", y="CESD", z=c("FSS","GSES","age","gender"), data=dat,
              test="mi-cg")
gcm.test(X=dat$MAIA_38, Y=dat$CESD, Z=cbind(dat$FSS, dat$GSES, dat$age, dat$gender), alpha = 0.01)
CondIndTest(Y=dat$MAIA_38, E=dat$CESD, X=cbind(dat$FSS, dat$GSES, dat$age, dat$gender),
            method = "KCI", alpha = 0.01,
            parsMethod = list(), verbose = FALSE)


## iii)

# F d-sep S | A, G
ci.test(x="FSS", y="GSES", z=c("age","gender"), data=dat,
        test="mi-cg")
gcm.test(X=dat$FSS, Y=dat$GSES, Z=cbind(dat$age, dat$gender), alpha = 0.01)
CondIndTest(Y=dat$FSS, E=dat$GSES, X=cbind(dat$age, dat$gender),
            method = "KCI", alpha = 0.01,
            parsMethod = list(), verbose = FALSE)

# F d-sep S | A, G, M
ci.test(x="FSS", y="GSES", z=c("MAIA_38","age","gender"), data=dat,
        test="mi-cg")
gcm.test(X=dat$FSS, Y=dat$GSES, Z=cbind(dat$MAIA_38, dat$age, dat$gender), alpha = 0.01)
CondIndTest(Y=dat$FSS, E=dat$GSES, X=cbind(dat$MAIA_38, dat$age, dat$gender),
            method = "KCI", alpha = 0.01,
            parsMethod = list(), verbose = FALSE)



###################################
#### H2: ECE of MAC on fatigue ####
###################################

## Covariate Adjustment

# linear model (M measure: MAIA_38), VAS: A,G
m1 <- lm(FSS ~ MAIA_38 + age + gender, data=ase_pbihb_data)
s1 <- summary(m1); print(s1)
pt(s1$coefficients[2,3], df = m1$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
confint(m1)

# VAS: A,G,S
m2 <- lm(FSS ~ MAIA_38 + age + gender + GSES, data=ase_pbihb_data)
s2 <- summary(m2); print(s2)
pt(s2$coefficients[2,3], df = m2$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
confint(m2)


#_______________
## use propensity score (IPW) for ECE from M to F
library(ipw)
tmp1 <- ipwpoint(
  exposure = MAIA_38,
  family = "gaussian",
  link = "glm",
  numerator = ~ 1,
  denominator = ~ age + gender,
  data = ase_pbihb_data
)
# weights
summary(tmp1$ipw.weights)
ipwplot(weights = tmp1$ipw.weights, logscale = FALSE,
        main = "Stabilized weights", xlim = c(0,2))
# numerator & denominator models
summary(tmp1$num.mod)
summary(tmp1$den.mod)
# pasting IPW weights to data set
ase_pbihb_data$sw <- tmp1$ipw.weights
# weighting observations by stabilized weights to adjust for confounding (fit MSM)
library(survey)
msm1 <- (svyglm(FSS ~ MAIA_38, design = svydesign(~1, weights = ~sw, data=ase_pbihb_data)))
s1_msm <- summary(msm1); print(s1_msm)
pt(s1_msm$coefficients[2,3], df = msm1$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
confint(msm1)


## use different VAS: A,G,S
tmp1a <- ipwpoint(exposure = MAIA_38, family = "gaussian", link = "glm",
  numerator = ~ 1, denominator = ~ age + gender + GSES, data = ase_pbihb_data)
ipwplot(weights = tmp1a$ipw.weights, logscale = FALSE, main = "Stabilized weights", xlim = c(0,2))
ase_pbihb_data$sw1a <- tmp1a$ipw.weights
msm1a <- (svyglm(FSS ~ MAIA_38, design = svydesign(~1, weights = ~sw1a, data=ase_pbihb_data)))
s1_msm1a <- summary(msm1a); print(s1_msm1a)
pt(s1_msm1a$coefficients[2,3], df = msm1a$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
s1_msm1a$coefficients[2,4]/2 # p-value for one-sided t-test
confint(msm1a)


# _______________________________________
## use doubleML for ECE
library(DoubleML)
set.seed(1234)

# implement causal model (inference on effect of variable d on y, confounds x)
obj_dml_data <- double_ml_data_from_data_frame(df = ase_pbihb_data,
                               x_cols = c("age","gender"),
                               y_col = "FSS",
                               d_col = "MAIA_38")

# chose machine learning method
library(mlr3)
library(mlr3learners)
library(ranger)
n_vars = 2 #number of covariates x
# init random forests learner with specified params
ml_l = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)
ml_m = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5) 
ml_g = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)

doubleml_plr = DoubleMLPLR$new(obj_dml_data, ml_l, ml_m, ml_g, n_folds = 2, score = "IV-type")
doubleml_plr

# est causal effect of d on y
set.seed(123)
doubleml_plr$fit() 
doubleml_plr$summary()
doubleml_plr$t_stat
doubleml_plr$pval/2 # p-value for one-sided t-test
doubleml_plr$confint()


## different VAS: A,G,S
# implement causal model (inference on effect of variable d on y, confounds x)
obj_dml_data1b <- double_ml_data_from_data_frame(df = ase_pbihb_data,
                                               x_cols = c("age","gender","GSES"),
                                               y_col = "FSS",
                                               d_col = "MAIA_38")
# chose machine learning method
n_vars = 3 #number of covariates x
# init random forests learner with specified params
ml_l1b = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)
ml_m1b = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5) 
ml_g1b = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)
doubleml_plr1b = DoubleMLPLR$new(obj_dml_data1b, ml_l1b, ml_m1b, ml_g1b, n_folds = 2, score = "IV-type")
doubleml_plr1b
# est causal effect of d on y
set.seed(123)
doubleml_plr1b$fit() 
doubleml_plr1b$summary()
doubleml_plr1b$t_stat
doubleml_plr1b$pval/2 # p-value for one-sided t-test
doubleml_plr1b$confint()



################################################################################
#### H3: ECE of fatigue*self-efficacy on depression ############################
################################################################################

## linear models
# VAS: A,G
m11 <- lm(CESD ~ FSS + GSES + FSS*GSES + age + gender, data=ase_pbihb_data)
s11 <- summary(m11); print(s11)
pt(s11$coefficients[6,3], df = m11$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
confint(m11)

# VAS: A,G,M
m12 <- lm(CESD ~ FSS + GSES + FSS*GSES + age + gender + MAIA_38, data=ase_pbihb_data)
s12 <- summary(m12); print(s12)
pt(s12$coefficients[7,3], df = m12$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
confint(m12)


#______
## use propensity score (IPW) for ECE from F*S to D
ase_pbihb_data$f_s_int <- ase_pbihb_data$FSS*ase_pbihb_data$GSES

# VAS: A,G
tmp2 <- ipwpoint(
  exposure = f_s_int,
  family = "gaussian",
  link = "glm",
  numerator = ~ 1,
  denominator = ~ age + gender, #VAS: A,G
  data = ase_pbihb_data
)
# weights
summary(tmp2$ipw.weights)
ipwplot(weights = tmp2$ipw.weights, logscale = FALSE,
        main = "Stabilized weights", xlim = c(0,3))
# numerator & denominator models
summary(tmp2$num.mod)
summary(tmp2$den.mod)
# pasting IPW weights to data set
ase_pbihb_data$sw2 <- tmp2$ipw.weights
# weighting observations by stabilized weights to adjust for confounding (fit MSM)
msm2 <- (svyglm(CESD ~ FSS + GSES + FSS*GSES + age + gender, 
                design = svydesign(~1, weights = ~sw2, data=ase_pbihb_data)))
s_msm2 <- summary(msm2); print(s_msm2)
pt(s_msm2$coefficients[6,3], df = msm2$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
confint(msm2)


## VAS: A,G,M
tmp2b <- ipwpoint(exposure = f_s_int, family = "gaussian", link = "glm", numerator = ~ 1,
  denominator = ~ age + gender + MAIA_38, data = ase_pbihb_data)
ase_pbihb_data$sw2b <- tmp2b$ipw.weights
msm2b <- (svyglm(CESD ~ FSS + GSES + FSS*GSES + age + gender + MAIA_38, 
                design = svydesign(~1, weights = ~sw2b, data=ase_pbihb_data)))
s_msm2b <- summary(msm2b); print(s_msm2b)
pt(s_msm2b$coefficients[7,3], df = msm2b$df.residual, lower.tail = TRUE) # p-value of one-sided t-test
confint(msm2b)


# _______________________________________
## use doubleML for ECE

# implement causal model (inference on effect of variable d on y, confounds (A,G,F,S))
obj_dml_data2a <- double_ml_data_from_data_frame(df = ase_pbihb_data,
                                                x_cols = c("FSS","GSES","age","gender"),
                                                y_col = "CESD",
                                                d_col = "f_s_int")

# chose machine learning method
n_vars = 4 #number of covariates x
# init random forests learner with specified params
ml_l2a = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)
ml_m2a = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5) 
ml_g2a = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)

doubleml_plr2a = DoubleMLPLR$new(obj_dml_data2a, ml_l2a, ml_m2a, ml_g2a, n_folds = 2, score = "IV-type")

# est causal effect of d on y
set.seed(123)
doubleml_plr2a$fit() 
doubleml_plr2a$summary()
doubleml_plr2a$t_stat
doubleml_plr2a$pval/2 # p-value for one-sided t-test 
doubleml_plr2a$confint()


## VAS: A,G,M
# implement causal model (inference on effect of variable d on y, confounds (A,G,M,F,S))
obj_dml_data2b <- double_ml_data_from_data_frame(df = ase_pbihb_data,
                                               x_cols = c("FSS","GSES","MAIA_38","age","gender"),
                                               y_col = "CESD",
                                               d_col = "f_s_int")

# chose machine learning method
n_vars = 5 #number of covariates x
# init random forests learner with specified params
ml_l2b = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)
ml_m2b = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5) 
ml_g2b = lrn("regr.ranger", num.trees = 100, mtry = n_vars, min.node.size = 2, max.depth = 5)

doubleml_plr2b = DoubleMLPLR$new(obj_dml_data2b, ml_l2b, ml_m2b, ml_g2b, n_folds = 2, score = "IV-type")

# est causal effect of d on y
set.seed(123)
doubleml_plr2b$fit() 
doubleml_plr2b$summary()
doubleml_plr2b$t_stat
doubleml_plr2b$pval/2 # p-value for one-sided t-test
doubleml_plr2b$confint()

