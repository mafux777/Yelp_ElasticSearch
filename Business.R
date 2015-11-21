# Business.R
# This script reads the JSON file and extracts a data table with all entries
library(jsonlite)
library(data.table)

connection=file("~/Downloads/yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_business.json")
business=stream_in(connection)
setnames(business, names(business), gsub("[ ]", "_", names(business)))
business_f=as.data.table(flatten(business))
setnames(business_f, names(business_f), gsub("[ ]", "_", names(business_f)))

#business_i=business_f[, list(name, city, state, business_id)]
#setkey(Review, business_id)
#setkey(business_i, business_id)
#Review_X=business_i[Review]
