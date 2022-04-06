library(KoNLP)
library(NLP)
library(openNLP)
library(tm)
library(stringr)
library(SnowballC)

data('crude')

#전처리 과정
crude1 <- tm_map(crude, content_transformer(tolower)) #로워케이스로 변경
crude1 <- tm_map(crude1, removePunctuation) #펑추에이션 지워준다.
crude1 <- tm_map(crude1, removeNumbers) #숫자를 지워준다.
crude1 <- tm_map(crude1, removeWords, stopwords("english")) #영어의 활용어(for, which, about) 지운다.
crude1 <- tm_map(crude1, stemDocument, language = "english") #다큐먼트의 어근으로 바꿔준다.

dtm <- DocumentTermMatrix(crude1)
word.freq <- apply(dtm[,], 2, sum) #dtm에서 단어 나열, 2는 리스트에서 쓰인 단어의 빈도
sort.word.freq <- sort(word.freq, decreasing = T)
write.table(sort.word.freq, "dtm_001.txt", sep="\t") #

library(wordcloud)
library(RColorBrewer)

pal2 <- brewer.pal(8, "Dark2")
wfreq <- data.frame(word = names(sort.word.freq), freq = sort.)
vec <- rep(wfreq$word, wfreq)
word_count <- table(vec)

wordcloud(names(word_count), freq = word_count, random.order = F, rot.per = 0, color = pal2, min.freq = 5)

#---------------------------------------------------------------------------------
hcn = read.csv("Hyper-Connected_news.csv", header = T, stringsAsFactor = F)
hcn = hcn$content

#hcn <- tolower(hcn)
#hcn <- gsub("[a-zA-Z]", " ", hcn)

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
  myNounCorpus[[i]]$content <- myNounFun(mytext[[i]]$content)
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
  myNounCorpus2[[i]]$content <- my.NC.func1(myNounCorpus[[i]]$content)
}

dtm2 <- DocumentTermMatrix(myNounCorpus2, control = list(wordLengths=c(2,15)))
word.freq2 <- apply(dtm2[,],2,sum)
sort.word.freq2 <- sort (word.freq2, decreasing = T)
t_swf2 <- data.frame(sort.word.freq2)
write.table(t_swf2,"dtm_002.txt", sep = "\t")

dtm64tfidf <- DocumentTermMatrix(myNounCorpus2, control=list(weighting = function(x) weightTfIdf(x, normalize = F)))
word.tfidf.score <- apply(dtm64tfidf[,],2,sum)
sort.word.tfidf.score <- sort(word.tfidf.score, decreasing = T)
t_swts <- data.frame(sort.word.tfidf.score)
write.table(t_swts,"dtm_001_tfidf.txt", sep = "\t")

#----------------------------------------------------
library(topicmodels)
lda.out <- LDA(dtm2, control = list(seed = 11), k = 4)
lda2.out <- LDA(dtm2, control = list(seed = 11), k = 5)
lda3.out <- LDA(dtm2, control = list(seed = 11), k = 6)

library(tidytext)
n_topics <- tidy(lda.out, matrix = "beta")

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

