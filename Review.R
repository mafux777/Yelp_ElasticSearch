# Review.R
# This script reads the JSON file and extracts a data table with all entries
library(jsonlite)
library(data.table)

connection=file("~/Downloads/yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_review.json")
Review=stream_in(connection)
Review=flatten(Review)
Review=as.data.table(Review)
