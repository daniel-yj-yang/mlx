rm(list=ls())
cat("\014")

# Daniel Yang, Ph.D. (daniel.yj.yang@gmail.com)

require(imager) # https://dahtah.github.io/imager/imager.html

x <- load.image("/Users/daniel/Data-Science/Data/Photos/Lego_art.png")
img_width <- 256
img_height <- 414
x

plot_array_RGB <- function(this_array_RGB, filename = 'test.png', text = "", width=dim(this_array)[1], height=dim(this_array)[2]) {
  png(file.path('/Users/daniel/tmp', filename), width=width, height=height)
  par(mar = rep(0, 4)) # Set up a plot with no margin
  this_img <- as.cimg(this_array_RGB)
  this_img <- draw_text( im = this_img, x = 50, y = 40, text = text, color = "yellow", fsize = 50 )
  plot(this_img)
  dev.off()
}

#plot_array_RGB( x[,,1,1:3], text = "Original", width = img_width, height = img_height )

# to use PCA to reconstruct 

width = dim(x)[1]
height = dim(x)[2]

X_R = x[,,1,1]
X_G = x[,,1,2]
X_B = x[,,1,3]

mu_R = colMeans(X_R)
mu_G = colMeans(X_G)
mu_B = colMeans(X_B)

X_PCA_R = prcomp(X_R, center = TRUE, scale. = FALSE)
X_PCA_G = prcomp(X_G, center = TRUE, scale. = FALSE)
X_PCA_B = prcomp(X_B, center = TRUE, scale. = FALSE)

Cumulative_proportion_of_variance_explained <- function(pca_results, k = 1) {
  x.var <- pca_results$sdev ^ 2
  x.pvar <- 100*x.var/sum(x.var)
  cumsum(x.pvar)[k]
}

for(n_PCs in 1:30) {
  print(paste0('n_PCs = ', sprintf('%02d', n_PCs), 
               '; variance explained: ',
               'R = ', sprintf('%.2f', Cumulative_proportion_of_variance_explained(X_PCA_R, n_PCs)), '%, ',
               'G = ', sprintf('%.2f', Cumulative_proportion_of_variance_explained(X_PCA_G, n_PCs)), '%, ',
               'B = ', sprintf('%.2f', Cumulative_proportion_of_variance_explained(X_PCA_B, n_PCs)), '%'
  ))
  nComp = n_PCs
  Xhat_R = X_PCA_R$x[,1:nComp] %*% t(X_PCA_R$rotation[,1:nComp]) # X_L = T_L * W_L
  Xhat_G = X_PCA_G$x[,1:nComp] %*% t(X_PCA_G$rotation[,1:nComp]) # X_L = T_L * W_L
  Xhat_B = X_PCA_B$x[,1:nComp] %*% t(X_PCA_B$rotation[,1:nComp]) # X_L = T_L * W_L
  Xhat_R = scale(Xhat_R, center = -mu_R, scale = FALSE) # reconstructed
  Xhat_G = scale(Xhat_G, center = -mu_G, scale = FALSE) # reconstructed
  Xhat_B = scale(Xhat_B, center = -mu_B, scale = FALSE) # reconstructed
  Xhat_RGB = array(NA, dim=c(width, height, 3))
  Xhat_RGB[,,1] <- Xhat_R
  Xhat_RGB[,,2] <- Xhat_G
  Xhat_RGB[,,3] <- Xhat_B
  plot_array_RGB(Xhat_RGB, filename = paste0(sprintf("%03d", nComp),'.png'), text = paste0('PCs: ',nComp), width = img_width, height = img_height)
}

# finally, use imagemagick to create gif
# e.g., convert -delay 20 -loop 0 *.png all.gif  (delaying 20/100 = 0.20 seconds per frame and infinite loop)

# scree plot / cumulative plot
# https://rpubs.com/njvijay/27823
pcaCharts <- function(x) {
  x.var <- x$sdev ^ 2
  x.pvar <- x.var/sum(x.var)
  #print("proportions of variance:")
  #print(x.pvar)
  
  par(mfrow=c(2,2))
  plot(x.pvar,xlab="Principal component", ylab="Proportion of variance explained", ylim=c(0,1), type='b')
  plot(cumsum(x.pvar),xlab="Principal component", ylab="Cumulative Proportion of variance explained", ylim=c(0,1), type='b')
  screeplot(x)
  screeplot(x,type="l")
  par(mfrow=c(1,1))
}

pcaCharts(X_PCA_R)
pcaCharts(X_PCA_G)
pcaCharts(X_PCA_B)
