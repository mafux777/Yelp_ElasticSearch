Using ElasticSearch and R to analyse text in reviews
========================================================
---
title: "Using ElasticSearch on Yelp Data"
author: "Matthias Funke"
date: "21 Nov 2015"
---

Introduction
========================================================

- Fact: Only 800 business are marked as having live music (attributes.Music.live=TRUE)
- Question 1: Can we statistically determine that the attribute is correctly set?
- Question 2: Can we improve the accuracy of the attribute by parsing / searching the reviews?
- Technique used: ElasticSearch text analysis and TF/IDF scoring

Methods
========================================================
* Install ElasticSearch (https://www.elastic.co/downloads/elasticsearch)
* Install elastic R package (install.packages("elastic"))
* Ingest the reviews into ElasticSearch (elastic.R)
* Do a Search for "live music" or "band" in all reviews. Results are scores based on term frequency / inverse document frequency
* Add all scores by business_id. Normalize using number of reviews per business.
* Calculate *max*, *mean* of the *ES_score*
* Compare and contrast the results with the attribute "Music-live" by showing a histogram of the *ES_score* by attribute 

Results
========================================================

Compare and contrast the attribute settings to the statistical parameters Max, Mean of the *ES_score*. 

```
biz_with_ES_score[,list(N=.N, max=max(ES_score), mean=mean(ES_score)), by=attributes.Music.live]
```

```
       N       max        mean
1: 58464 0.5941232 0.001046862
2:  1907 0.3043548 0.003886252
3:   813 0.5734039 0.044372846
```
Note how the mean of the ES_score for "T" is roughly 10 times higher than for businesses with Live Music=F.  

Histogram for ES_score
========================================================

![plot of chunk unnamed-chunk-3](presentation-yelp-es-figure/unnamed-chunk-3-1.png) 

- Reviews which have the attribute live music set to true have much higher *ES_score*. 
- Businesses marked as "live music" despite low score are mis-classified (Author's claim)

Discussion
========================================================
- ElasticSearch text analysis can be used to score the businesses (high score = high likelihood to have live music)
- Yelp's own mechanism of classifying the attribute seems to be inconsistent
- Recommendation to Yelp: review whether current mechanism of setting "live music" attribute yields best results, or can be improved by using ES text analysis
