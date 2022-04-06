library(KoNLP)
library(NLP)
library(openNLP)
library(tm)
library(stringr)
library(SnowballC)

hcn = read.csv("Hyper-Connected_news.csv", header = T, stringsAsFactors = F)
hcn = hcn$content

#hcn <- tolower(hcn)
#hcn <- gsub("[a-zA-Z]", " ", hcn)

hcn <- removePunctuation(hcn)
hcn <- removeNumbers(hcn)
hcn <- stripWhitespace(hcn)

mytext <- Corpus(VectorSource(hcn))

myNounFun <- function(mytext) {
  myNounList <- paste(extractNoun(mytext), collapse = ' ')
  myNounList
}

myNounCorpus <- mytext

for (i in 1:length(mytext)){
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

#----------------------------------------------------
library(topicmodels)
lda.out <- LDA(dtm2, control = list(seed = 11), k = 4)
terms(lda.out,20)

lda2.out <- LDA(dtm2, control = list(seed = 11), k = 5)
terms(lda2.out,20)

lda3.out <- LDA(dtm2, control = list(seed = 11), k = 6)
terms(lda3.out,20)

library(tidytext)
n_topics <- tidy(lda.out, matric = "beta")

library(ggplot2)
library(dplyr)
library(tidyr)

n_topics_terms <- n_topics %>% group_by(topic) %>% top_n(20,beta) %>% ungroup() %>% arrange(topic, -beta)
n_topics_terms %>% mutate(term = reorder(term, beta)) %>% ggplot(aes(term, beta, fill = factor(topic))) + geom_col(show, legend = F) + facet_wrap(~topic, scales = "free") + coord_flip()

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

#------------------------------------------------------------------------------------------
library(data.table)
library(text2vec)
library(tm)
text <- fread("Airbnb-boston_only.csv")
airbnb <- data.table(review_id=text$review_id, comments=text$comments,
                     review_scores_rating=text$review_scores_rating)
airbnb$comments <- removeWords(airbnb$comments, c(stopwords('en'), 'Boston'))
airbnb$comments <- iconv(airbnb$comments,"WINDOWS-1252","UTF-8")
airbnb$comments <- removePunctuation(airbnb$comments)
airbnb$comments <- stripWhitespace(airbnb$comments)
airbnb$comments <- removeNumbers(airbnb$comments)
airbnb$comments <- tolower(airbnb$comments)
tokens <- strsplit(airbnb$comments, split = " ", fixed = T)
vocab <- create_vocabulary(itoken(tokens), ngram = c(1,1))

iter <- itoken(tokens)
vectorizer <- vocab_vectorizer(vocab)
tcm <- create_tcm(iter, vectorizer, skip_grams_window = 5)

glove = GlobalVectors$new(word_vectors_size = 50, vocabulary=vocab, x_max = 10)
wv_main = glove$fit_transform(tcm, n_iter=20)

dim(wv_main)
wv_context = glove$components
word_vectors = wv_main + t(wv_context)

good.walks = word_vectors["walk", , drop = FALSE] -
  word_vectors["disappointed", , drop = FALSE] +
  word_vectors["good", , drop = FALSE]
cos_sim = sim2(x = word_vectors, y = good.walks, method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 15)
vocab <- prune_vocabulary(vocab, term_count_min = 5)

good.parents = word_vectors["parents", , drop = FALSE] -
  word_vectors["disappointed", , drop = FALSE] +
  word_vectors["good", , drop = FALSE]
cos_sim = sim2(x = word_vectors, y = good.parents, method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 15)
vocab <- prune_vocabulary(vocab, term_count_min = 5)

good.yes = word_vectors["walk", , drop = FALSE] +
  word_vectors["good", , drop = FALSE]
cos_sim = sim2(x = word_vectors, y = good.yes, method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 15)
vocab <- prune_vocabulary(vocab, term_count_min = 5)

