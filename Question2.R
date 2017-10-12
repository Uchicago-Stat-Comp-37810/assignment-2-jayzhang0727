trueA <- 5  #Give the real value of the parameter A
trueB <- 0  #Give the real value of the parameter B
trueSd <- 10  #Give the real value of the standard deviation Sd
sampleSize <- 31 #Give the real value of the parameter SampleSize which represent the number of samples

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

plot(x,y, main="Test Data") #Give the graph that the relation of x and y with some noise


#The likelihood function that calculate the probability of obtaining the test data above under this model
likelihood <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  
  pred = a*x + b
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))}
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")


# Prior distribution which is also a function needed in the Bayesian statistics
prior <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  aprior = dunif(a, min=0, max=10, log = T)
  bprior = dnorm(b, sd = 5, log = T)
  sdprior = dunif(sd, min=0, max=30, log = T)
  return(aprior+bprior+sdprior)
}

#The posterior function is a function combine the likelihood function and prior function together that construct the needed
#value of the algorithm where the "+" is because of the logarithm. 
posterior <- function(param){
  return (likelihood(param) + prior(param))
}



######## Metropolis algorithm ################
#This is the main part of the Metropolis algorithm where the run_metropolis function gives the result whether we would 
#accept the return of proposal function or not by analyzing the probab which represent the property that help us make the
#judgement. 
proposalfunction <- function(param){
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))
}

run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3))
  chain[1,] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,])
    
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    if (runif(1) < probab){
      chain[i+1,] = proposal
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  return(chain)
}
#The startvalue gives the beginning data of the algorithm
startvalue = c(4,0,10)
#chain returns the value of the sequence of the method that give us the process of the algorithm
chain = run_metropolis_MCMC(startvalue, 10000)

burnIn = 5000#burnIn is the number that represent how many data we would regardless on the sequence chain
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))#This is the value that we use to evaluate the process.



### Summary: #######################

#The following process is the histgram of the process and black line gives the mean of the chain and the red line 
#gives the value of the true data.
#The plot function is another way to show the appearance of the algorithm. 
#The red line in the data also represent the true value of the data of a,b and sd.

par(mfrow = c(2,3))
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
abline(v = mean(chain[-(1:burnIn),1]))
abline(v = trueA, col="red" )
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),2]))
abline(v = trueB, col="red" )
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),3]) )
abline(v = trueSd, col="red" )
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
abline(h = trueA, col="red" )
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b", )
abline(h = trueB, col="red" )
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd", )
abline(h = trueSd, col="red" )

# for comparison:
summary(lm(y~x))
