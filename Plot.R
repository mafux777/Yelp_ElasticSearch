library(ggplot2)
p = ggplot(data=plot_data, aes(x=ES_score, fill=attributes.Music.live)) + geom_histogram(aes(binwidth=1))# + facet_grid(. ~ attributes.Music.live)
p
