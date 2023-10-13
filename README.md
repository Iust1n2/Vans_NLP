# Vans_NLP

## Text Mining and Clustering Analysis

## Overview

This repository contains code for conducting text mining and clustering analysis on textual data, used from the source listed in [Acknowledgements](#acknowledgements). The analysis includes preprocessing the text, exploring term frequencies, visualizing word clouds, and performing hierarchical and K-means clustering. It's designed for gaining insights from textual data and identifying patterns among terms.

## Table of Contents

- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Analysis Steps](#analysis-steps)
- [Acknowledgements](#acknowledgements)

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- R and RStudio installed
- Required R packages (listed in [Installation](#installation)).

### Installation

Install the required R packages using the following commands: `install.packages(c("tm", "SnowballC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc"))` and `install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")`

## Analysis Steps

1. **Data Loading**: Load your textual data for analysis.

2. **Preprocessing**: Clean and preprocess the text data. This step includes removing punctuation, numbers, and stopwords to prepare the text for analysis, using the `tm` package.

3. **Term Frequency**: Calculate term frequencies within the text data. This allows you to understand which terms are the most frequently mentioned and the `ggplot2` package provides visuals for this task. 

4. **Word Clouds**: Visualize term frequencies with the `wordcloud` package.

5. **Clustering Analysis:**

  - **Hierarchical Clustering:** Apply hierarchical clustering to identify term similarities. This step involves creating a dendrogram that visually represents the relationships between terms, using the `ggdendro` package.
   
  - **K-Means Clustering:** Perform K-means clustering to group terms based on their similarity. The K-means clustering algorithm allows to explore how terms cluster together, which can be valuable for topic modeling or identifying themes in the text data and this can be done with the help of `fpc` and `cluster` packages.

6. **Customization**: Adjust the code to meet your specific analysis requirements.

## Acknowledgements

This project utilizes code and resources from external sources, and I acknowledge their contributions:

- [Basic Text Mining in R](https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html) 

- ‘brewerpal’ color for text cloud: https://www.datavis.ca/sasmac/brewerpal.html

- ‘dendrogram’: https://rpubs.com/gaston/dendrograms
