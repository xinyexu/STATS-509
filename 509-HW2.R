# ---
#   title: "STAT509-001-HW2-Xinye Xu"
# output: html_document
# ---
  
  ## 1
#   (a) Exercise 10 on page 17 in Ruppert/Matteson. 
# Assumed each year log-return is independent. We know sum of iid normal dist is normal dist.So 20 days log-ret (R1 + ... + R20) ~ N(0.0002*20, 20*0.03^2). It can be converted to Pr(20-days log-ret >= log(100/97)), Then the prob = 0.4218295 that it can selling exceed $100.
# (b) Exercise 11 on page 17 of Ruppert/Matteson.
# By samliing from 3000 days and 3500 days, we found the prob = 0.9 is between them, so we have prob = 0.9000645 when t = 3099 It indicates that after 3099 days, the prob the price has doubled is at least 90%. 

pnorm(log(100/97), mean=0.0002*20, sd=sqrt(20*0.03^2), lower.tail = FALSE) 
cal <- function(t) { 
  out <- pnorm(log(2), mean=0.0005*t, sd=sqrt(t*0.012^2), lower.tail = FALSE) 
  return(out)
}
cal(3000) # 0.8901991
cal(3500) # 0.9317132
for (t in 3000:3500) {
  if (cal(t) >= 0.9){
    print(list(t, cal(t)))
    break
  }
}
# easest way 
t = 1:5000
p <- pnorm(log(2), mean=0.0005*t, sd=sqrt(t*0.012^2), lower.tail = FALSE)  
min(which(p>0.9))


## 2
# Exercise 3 on page 82 in Ruppert/Matteson.
# (a) Sample density: the density from sample data (solid). Extimated density: estimated by mean and std of normal(dashed). The Sample density is higher than Extimated density in the middle, which means a higher peak Also, the Sample density seems to have a heavier tail than estimated one. 
library(Ecdat)
Garch$fddy <- c(NA, diff(Garch$dy))
hist(Garch$fddy, xlab = 'fd_dy', breaks = 30,freq=FALSE,main= 'Histogram true density estimates')
sa_mean <- mean(Garch$fddy, na.rm=TRUE)
sa_sd <- sd(Garch$fddy, na.rm=TRUE)
# density estimates with adjusted bw
set.seed(123)
xnorm <- rnorm(500,sa_mean,sa_sd)
dens_norm_sd = density(xnorm,kernel=c("gaussian"))
lines(density(Garch$fddy[-1]),lty=1,lwd=2)
lines(dens_norm_sd,lty=2,lwd=2)
legend('topright', c('true', 'dens_norm_sd'),lty = c(1, 2))


# (b) Repeated (a) with median and mad for the normal mean and sd. The Sample density is still higher than Extimated density in the middle, while the difference has reduced. Also, the Sample density seems to have a heavier tail than estimated one in the right side. And the difference has been enlarged by the replacement. 
sa_mean <- median(Garch$fddy, na.rm=TRUE)
sa_sd <- mad(Garch$fddy, na.rm=TRUE)
hist(Garch$fddy, xlab = 'fd_dy', breaks = 30,freq=FALSE,main= 'Histogram true density estimates2')
# density estimates with adjusted bw
xnorm <- rnorm(500,sa_mean,sa_sd)
dens_norm_sd2 = density(xnorm,kernel=c("gaussian"))
lines(density(Garch$fddy[-1]),lty=1,lwd=2)
lines(dens_norm_sd2,lty=2,lwd=2)
legend('topright', c('true', 'dens_norm_sd2'),lty = c(1, 2))


## Q3 
# (b) The bias increases when the bandwidth increases. Plus, the bias is negative in near the middle zero and might be underestimated among the peak area. But the bias turns to become positive when it moves beyond the 1 and -1.
# 
# We see as we expected that the overall level of bias (negative and positive) increases as the bandwidth increases. 
# 
# Also as expected, the bias is negative in the middle near to 0 (i.e., the kernel density tends to undershoot the main central peak), and then they all go positive outside of the main lobe at around the same value of approximately ±1.
x = seq(-10,10,by=.01)
w = 3.464 * 0.1
bias1 = (1 / w) * (pnorm(x + w / 2, 0, 1)-pnorm(x - w / 2, 0, 1)) - dnorm(x, 0, 1)
w = 3.464 * 0.2
bias2 = (1 / w) * (pnorm(x + w / 2, 0, 1)-pnorm(x - w / 2, 0, 1)) - dnorm(x, 0, 1)
w = 3.464 * 0.4
bias4 = (1 / w) * (pnorm(x + w / 2, 0, 1)-pnorm(x - w / 2, 0, 1)) - dnorm(x, 0, 1)
plot(x, bias1, ylim = c(-.04,.02), type='l', lty=1)
lines(x, bias2, lwd=2,lty=3)
lines(x, bias4, lwd=2, lty=6)
legend("bottomleft",c("bw=0.1","bw=0.2","bw=0.4"),lty=c(1,3,5))
