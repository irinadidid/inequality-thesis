df <- ClusterData
summary(df)
data_cont <- df[,c("GDP per capita, PPP (current international $)","Gini index (World Bank estimate)", "Unemployment, total (% of total labor force) (modeled ILO estimate)", "Life expectancy at birth, total (years)")]
library(tidyr)
data <- data_cont %>% drop_na()
df.no.nas <- df %>% drop_na()
cor <- cor(data, method = "pearson")
cor
#install.packages("ggpubr")
#install.packages("ppcor")
#install.packages("corrplot")
library(ggpubr)
library(corrplot)
library(ppcor)
corrplot(as.matrix(cor),  method = "circle", type = "full", tl.col = "black", tl.srt = 60)
rownames(data) <- df.no.nas$`Country Code`
colnames(data)[1] <- "GDP_per_capita"
colnames(data)[2] <- "Gini_index"
colnames(data)[3] <- "Unemployment"
colnames(data)[4] <- "Life_expectancy"
M <- dist(scale(data))^2
hc <- hclust(M, method = "ward.D")
plot(hc, cex = 0.6)
plot(hc, cex = 0.6, main = ", Ward method")
rect.hclust(hc, k = 5, border="red") # 5 кластеров
groups5 <- cutree(hc, k = 5)

data <- data %>% mutate(groups5 = factor(groups5), country = df.no.nas$`Country Code`)
data_z <- scale(data[,1:4])
cor_2 <- cor(data_z, method = "pearson")
cor_2


data.pca <- prcomp(data[,c(1:4)], center = TRUE,scale. = TRUE)
summary(data.pca)

k5 <- kmeans(data[1:4], centers = 5, nstart = 25)
str(k5)
fviz_cluster(k5, data = data, 
             xlab = "Principle component 1 (49.7%)",
             ylab = "Principle component 2 (30.1%)",
             main = "k-means clusters, Europian countries")