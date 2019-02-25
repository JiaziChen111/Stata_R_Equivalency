matrix mean_vec=(1.0, 2.0, 3.0)
matrix cov_mat=(1.0, .75, 1.0  \ /// 
                .75, 1.5, 0.0  \ ///  
                1.0, 0.0, 2.0)            
corr2data x y z, n(300) mean(mean_vec) ///
   cov(cov_mat) cstorage(full) seed(341305)

glm y x z, ///
   family(gaussian) link(identity)
estimates store example_model

test x=0
test x=z
test x=z=0

predict residual_y_xz, deviance // GLM uses deviance 
predict residual_y_xz, residual // OLS uses residual

generate x_z = x * z
generate x_disc = 0
replace x_disc = 1 if x < .5
replace x_disc = 2 if x > .5 & x < 1.5
replace x_disc = 3 if x > 1.5

glm y i.x_disc 

generate x_d1 = 0
replace x_d1 = 1 if x_disc==1
generate x_d2 = 0
replace x_d2 = 2 if x_disc==2
generate x_d3 = 0
replace x_d3 = 3 if x_disc==3

tabulate x_disc, generate(x_d)

graph twoway ((scatter y x) || (lfit y x))

graph twoway ((scatter y x) || (qfit y x))
