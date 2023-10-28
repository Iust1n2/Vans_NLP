

##########################################################################################
# 1. Installing relevant packages
##########################################################################################

Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", 
            "cluster", "igraph", "fpc")

install.packages(Needed, dependencies = TRUE)
install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")

library(tm)
library(SnowballC)
library(RColorBrewer)
library(ggplot2)
library(wordcloud)
library(biclust)
library(cluster)
library(igraph)
library(fpc)
library(readxl)


##########################################################################################
# 2.  Loading Texts                                         
##########################################################################################

cname <- file.path("C:/Users/Iustin/Desktop/proiect Cezara - Copy/texts")
cname   
dir(cname)

########
# Change the working directory with the Excel file
setwd("C:/Users/Iustin/Desktop/proiect Cezara - Copy/texts")


##########################################################################################
# 3.                               Start the Analysis                                    #
##########################################################################################

# Loading required package for text mining

library(tm)

###################################
# 3.0 Generating a Corpus, one document data set
#
excel_file <- "Vans - Marketing Strategy.xlsx"

# Specify the sheet name you want to read
sheet_name <- "1&2&3 stars"  

# Read the specific sheet into a data frame

data <- read_excel(excel_file, sheet = sheet_name)

data <-data[,2]
head(data,3)
tail(data)
docs <- Corpus(VectorSource(data))
summary(docs)

##################################
# 3.1    Preprocessing   ==parsing 

docs <- tm_map(docs, removePunctuation)   
docs <- tm_map(docs, removeNumbers)   
docs <- tm_map(docs, tolower)   
docs <- tm_map(docs, removeWords, stopwords("english"))   
docs <- tm_map(docs, removeWords, c("are", "these", "in", "the", "and", "a", "with", "after", "my", "his", "as", "at", "first", "and", "them", "he", "to", "when"))
# The above line removes unnecessary and redundant words
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, PlainTextDocument)

##
# The above code block is applying NLP preprocessing methods to the review, making it easier for analysis purposes.

### Stage the Data      
dtm <- DocumentTermMatrix(docs) 
# inspect(dtm[1:2, 1:1500])
dtm <- DocumentTermMatrix(docs)   
inspect(dtm)
mdtm <- as.matrix(dtm) 

write.csv(unlist(dtm), "N_DTM2.csv")
class(dtm)
tdm <- TermDocumentMatrix(docs)   
write.csv(as.matrix(dtm),"aa.csv")
write.csv(mdtm,"aa2.csv")
inspect(tdm)
inspect(dtm)

## 
# The above code block is responsible for converting the text data into two different matrix 
# representations (DTM and TDM)  contain the same information—the frequency of terms in each document
# just with different variable names and file names, saving them as CSV files, and providing inspection or visualization 
# of the matrix contents for further analysis.

##################################
## 3.2 Explore your data

freq <- colSums(as.matrix(dtm))   
length(freq)   
ord <- order(freq)   
m <- as.matrix(dtm)   
dim(m)   
write.csv(m, file="DocumentTermMatrix2.csv")  

dtms <- removeSparseTerms(dtm, 0.95) # This makes a matrix that is 10% empty space, maximum.   
dtms

##
# This code block is designed to help you explore and prepare your DTM for further analysis by 
# calculating term frequencies, ordering terms by frequency, and optionally removing sparse terms 
# to focus on more meaningful terms. The resulting "dtms" DTM is more suitable for subsequent text mining tasks.

##################################
### 3.3 Word Frequency 

head(table(freq), 20) 

# The above output is two rows of numbers. The top number is the frequency with which 
# words appear and the bottom number reflects how many words appear that frequently. 
#
tail(table(freq), 20)   

# Considering only the 20 greatest frequencies

# View a table of the terms after removing sparse terms, as above.
freq <- colSums(as.matrix(dtms))   
freq   
# The above matrix was created using a data transformation we made earlier. 

freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
head(freq, 20)   #This will show you the top 20 most frequently mentioned words
tail(freq, 10)   #This will show you the bottom 10 least frequently mentioned words

# An alternate view of term frequency:**   
# This will identify all terms that appear frequently (in this case, 50 or more times).   
findFreqTerms(dtm, lowfreq=30)   # Change "30" to whatever is most appropriate for your data.

# Another format to try
wf <- data.frame(word=names(freq), freq=freq)  
head(wf,20) # !! for presentation

##################################
### 3.4 Plot Word Frequencies

# **Plot words that appear at least 25 times.**  

library(ggplot2)   
wf <- data.frame(word=names(freq), freq=freq)   
p <- ggplot(subset(wf, freq > 13), aes(x = reorder(word, -freq), y = freq)) 
p <- p + geom_bar(stat="identity")+ theme(axis.text.x=element_text(angle=45, hjust=1))   
p # !! for presentation

##################################
### 3.5  Term Correlations (Co-occurence)


findAssocs(dtms, "good", corlimit=0.1) # specifying a correlation limit of 0.1
findAssocs(dtms, "quality", corlimit=0.1) # specifying a correlation limit of 0.1
findAssocs(dtms, "fit", corlimit=0.1) # specifying a correlation limit of 0.1

##################################
#### 4. Word Clouds! 

dtms <- removeSparseTerms(dtm, 0.95)  
freq <- colSums(as.matrix(dtm)) # Find word frequencies   
dark2 <- brewer.pal(6, "Dark2")   

wordcloud(names(freq), freq, min.freq=60, width = 3, height = 10)    
wordcloud(names(freq), freq, max.words=30, width = 10, height = 5)    
wordcloud(names(freq), freq, min.freq=50, rot.per=0.3, colors=dark2, width = 10, height = 5)    
wordcloud(names(freq), freq, max.words=500, rot.per=0.1, colors=dark2, width = 90, height = 45)   


##################################
##### 5. Clustering by Term Similarity

### 5.1 Hierarchical Clustering   

library(slam)
library(ggdendro)

# Extract the most frequent terms from wf
most_frequent_terms <- wf$word[1:20]  # Adjust the number as needed

# Filter the DTM to include only the most frequent terms
dtm_filtered <- dtms[, most_frequent_terms]

# Check if there are terms in the filtered DTM
if (sum(row_sums(dtm_filtered)) > 0) {
  # Create the dendrogram
  dend <- as.dendrogram(hclust(dist(t(dtm_filtered), method = "euclidean")))
  
  # Check if the dendrogram is created
  if (!is.null(dend)) {
    # Plot the dendrogram
    print(
      ggdendrogram(dend, rotate = TRUE) +
        theme_minimal() +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    )
  } else {
    cat("Dendrogram creation failed.\n")
  }
} else {
  cat("No terms in the filtered DTM.\n")
}

# The dendrogram is a hierarchical tree-like structure that visually represents the similarity between 
# terms in your text data. Each leaf node of the dendrogram corresponds to a term, 
# and the structure of the tree illustrates how terms cluster together based on their 
# co-occurrence patterns.

# 5.1.2. Alternative option
# plot dendrogram with some cuts
dtmss <- removeSparseTerms(dtm, 0.95) # This makes a matrix that is only 15% empty space.
dtmss
library(cluster)   
d <- dist(t(dtms), method="euclidian")   # First calculate distance between words
fit <- hclust(d=d, method="complete")    # Also try: method="ward.D"   
fit
plot.new()
hcd = as.dendrogram(fit)
op = par(mfrow = c(1, 1))
plot(cut(hcd, h = 100)$upper, main = "Upper tree of cut at h=100")
plot(cut(hcd, h = 100)$lower[[2]], main = "Second branch of lower tree with cut at h=100")

dev.off() # reset the graphics device


### 5.2 K-means clustering   

library(fpc)   
library(cluster)  

# Prepare the data (max 15% empty space)
dtms <- removeSparseTerms(dtm, 0.92) 
dim(dtms)

# Remove the "meta" column that contains zeros
dtms <- t(as.matrix(dtms))
dtms <- dtms[, !colnames(dtms) %in% "meta"]

# Scale the data
scaled_dtms <- scale(dtms)

# Calculate the distance matrix
d <- dist(scaled_dtms, method = "euclidean")

# Explore different values of k
k <- 2

# Perform k-means clustering
kfit <- kmeans(scaled_dtms, centers = k)

# Get the cluster assignments
cluster_assignments <- kfit$cluster# Fit k-means clustering for different K values

# Create the cluster plot
clusplot(scaled_dtms, cluster_assignments, color = T, shade = T, labels = 2, lines = 0)

# K-means clustering is an unsupervised machine learning technique used for partitioning a dataset
# into a specified number of clusters.

# The dendrogram reflects the results of the k-means clustering, with words clustered based on their
# similarity and co-occurence patterns.

# The concentration of many overlapping words on the left end of the dendrogram suggests that 
# the k-means algorithm has identified one or more clusters with a large number of words that 
# are closely related.

# The presence of only a few words at the right end of the dendrogram indicates that there 
# are clusters with a minimal number of words that are quite distinct from the larger clusters. 
# These clusters may represent more niche or specific terms.

# Below is the corrected implementation of K-means clustering.

### 5.2.1 

library(fpc)   
library(cluster) 
# terms_of_interest <- c("size", "fit","great", "vans" ,"like", "good", "look", "new", "happy", "pleased", "pair", "perfect", "color")
# uncomment for using terms of interest for good reviews
dtm_filtered <- dtm[, terms_of_interest]
dtms <- removeSparseTerms(dtm_filtered, 0.92) # Prepare the data (max 15% empty space)   
inspect(dtms)
d <- dist(t(dtms), method="euclidian")   
kfit <- kmeans(d,2) 
plot.new()
op = par(mfrow = c(1, 1))
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)

# Performing K-means clustering on terms of interest set by ourselves, which resolves the issue of 
# overlapping words that make visualization difficult.

# This will result in a K-means plot with 2 clusters, based on the distance between the words' frequency.

