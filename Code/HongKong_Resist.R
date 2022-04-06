library(KoNLP)
library(NLP)
library(openNLP)
library(tm)
library(stringr)
library(SnowballC)
library(xlsx)

#---------------------------------------------------------------------------------
raw_hcn = read.xlsx2("HongKong_Resist_20190902-20191202.xlsx",1, header = T, stringsAsFactor = F)

names(raw_hcn) <- c("NEWS_ID", "DATE", "NEWS_NAME", "REPORTER", "ARTICLE_NAME", "SEG1", "SEG2", "SEG3", "CASE1", "CASE2", "CASE3", "PERSON", "PLACE", "GOVERNMENT", "KEYWORD", "FEATURE", "MAIN_ARTICLE", "URL", "NOVALUE", "EXCEPTION")

head(raw_hcn)

hcn = raw_hcn$KEYWORD

hcn <- tolower(hcn)
hcn <- gsub("[a-zA-Z]", " ", hcn)

hcn <- removePunctuation(hcn)
hcn <- removeNumbers(hcn)
hcn <- stripWhitespace(hcn)

mytext <- Corpus(VectorSource(hcn))

myNounFun <- function(mytext){
  myNounList <- paste(extractNoun(mytext), collapse= ' ')
  myNounList
}

myNounCorpus <- mytext

for(i in 1:length(mytext)) {
  myNounCorpus[[i]]$KEYWORD <- myNounFun(mytext[[i]]$KEYWORD)
}


#---------------------------------------------------------------------------------

my.NC.func1 <- function(mytext){
  myobject <- SimplePos22(mytext)
  new.myobject <- mytext
  mytextlength <- length(myobject)
  mylocation <- regexpr(pattern = '/NC+', myobject)
  for(i in 1:mytextlength) {
    mylocation <- regexpr(pattern = '/NC+', myobject[i])
    new.myobject[i] <- substr(myobject[i],1,mylocation[[1]][1]-1)
    new.myobject[i] <- gsub("[[:alnum:]]/[[:upper:]]{1,}\\+","",new.myobject[i])
  }
  new.myobject <- unlist(new.myobject)
  new.myobject <- new.myobject[nchar(new.myobject)>1]
  new.myobject
}

myNounCorpus2 <- myNounCorpus

for(i in 1:length(myNounCorpus)) {
  myNounCorpus2[[i]]$KEYWORD <- my.NC.func1(myNounCorpus[[i]]$KEYWORD)
}

dtm2 <- DocumentTermMatrix(myNounCorpus2, control = list(wordLengths=c(2,15)))
word.freq2 <- apply(dtm2[,],2,sum)
sort.word.freq2 <- sort (word.freq2, decreasing = T)
t_swf2 <- data.frame(sort.word.freq2)
write.table(t_swf2,"dtm_002_hongkong.txt", sep = "\t")


dtm64tfidf <- DocumentTermMatrix(myNounCorpus2, control=list(weighting = function(x) weightTfIdf(x, normalize = F)))
word.tfidf.score <- apply(dtm64tfidf[,],2,sum)
sort.word.tfidf.score <- sort(word.tfidf.score, decreasing = T)
t_swts <- data.frame(sort.word.tfidf.score)
write.table(t_swts,"dtm_001_tfidf_hongkong.txt", sep = "\t")

#----------------------------------------------------
library(topicmodels)
lda.out <- LDA(dtm2, control = list(seed = 11), k = 4)
lda2.out <- LDA(dtm2, control = list(seed = 11), k = 5)
lda3.out <- LDA(dtm2, control = list(seed = 11), k = 6)

library(tidytext)
n_topics <- tidy(lda3.out, matrix = "beta")

library(ggplot2)
library(dplyr)
library(tidyr)

n_topics_terms <- n_topics %>% group_by(topic) %>% top_n(20,beta) %>% ungroup() %>% arrange(topic, -beta)
n_topics_terms %>% mutate(term = reorder(term, beta)) %>%  ggplot(aes(term, beta, fill = factor(topic))) + geom_col(show.legend = F) + facet_wrap(~topic, scales = "free") + coord_flip()

library(LDAvis)
topicmodels2Davis <- function(x, ...){
  post <- topicmodels::posterior(x)
  if(ncol(post[["topics"]]) < 3) stop("The model must contain > 2 topics")
  mat <- x@wordassignments
  LDAvis::createJSON(
    endcoding = 'utf-8',
    phi = post[["terms"]],
    theta = post[["topics"]],
    vocab = colnames(post[["terms"]]),
    doc.length = slam::row_sums(mat, na.rm =TRUE),
    term.frequency = slam::col_sums(mat, na.rm = TRUE),
  )
}

options(encoding = 'UTF-8')
serVis(topicmodels2Davis(lda.out))

