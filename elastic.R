library(elastic)
library(data.table)

# Read the file provided by YELP
rev.JSON=readLines("~/Downloads/rev.JSON")
# Connect to ElasticSearch server, running locally
connect(es_base="http://localhost", es_port="9220")
# Delete any pre-existing index
index_delete(index = "rev")
# Create a new index with the reviews, using rev.JSON for field mappings
index_create(index = "rev", body = rev.JSON, raw = FALSE, verbose = TRUE)
# Upload all reviews in bulk
docs_bulk(Review, index="rev")
# Perform a search for the search string "live music" or band
a=Search(index="rev", fields=c("business_id", "review_id"), q="text:\"live music\" OR band", explain=F, asdf=T, size="20000")
# Display number of hits
a$hits$total
# Extract the fields business_id, review_id and score
a2=a$hits$hits
b=data.table(a2$fields, a2$`_score`)
b$review_id=unlist(b$review_id)
b$business_id=unlist(b$business_id)
# Calculate the score by business
c=b[,list(ES_score=sum(V2)), keyby=business_id]
# Join the two tables
setkey(business_f, business_id)
biz_with_ES_score= c[business_f]
# Where we don't have a score, set it to zero
biz_with_ES_score[is.na(ES_score), ES_score:=0]
# Normalize score with number of reviews
biz_with_ES_score[, ES_score:=ES_score/review_count]
# Show statistics for the score by attribute (True, False, NA)
B=biz_with_ES_score[,list(N=.N, max=max(ES_score), mean=mean(ES_score), min=min(ES_score), sd=sd(ES_score)), by=attributes.Music.live]
# save the result in a file for use by Rmd document - to speed up knitting
# otherwise each knit would re-index all documents, taking 20 mins or so
write.csv(B, file="~/Dropbox/Coursera/Data Science Yelp Challenge/biz.csv")

# For the histogram, show reviews with a score >0 and attribute T or F
plot_data = biz_with_ES_score[!is.na(attributes.Music.live) & ES_score>0,list(ES_score, attributes.Music.live)]
write.csv(plot_data, file="~/Dropbox/Coursera/Data Science Yelp Challenge/plot_data.csv")


