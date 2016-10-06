# This is the user interface of the Shiny app.

shinyUI(fluidPage(
  
  titlePanel("Text Prediction Shiny App"),
  br(),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      h5("Enter a partial sentence to complete (at least one word):"),
      textInput("textsource", label = ""),
      hr(),
      p("Prediction is implemented using Ngrams and a Stupid Backoff Algorithm. Full details are provided in the Algorithm Details tab. Supporting information is also provided.")
    ), # sidebarLayout(
    
    mainPanel(
      tabsetPanel(
        tabPanel("Results",
                 br(),
                 h4("Best prediction:"),
                 h4(textOutput("text")),
                 hr(),
                 h4("Top 10 results:"),
                 h4(tableOutput("table")),
                 hr()
        ), # tabPanel("Results",
        tabPanel("Algorithm Details",
                 h4("Data Processing"),
                 p("This app uses english text data collected from Twitter, blogs and news feeds by SwiftKey to generate a text corpus
                    as a basis for the text prediction algorithm. The following steps were carried out:"),
                 h5("1) Download SwiftKey data and load english subset of data into R"),
                 h5("2) Subsample to 50% and combine to corpus"),
                 h5("3) Clean data, e.g. remove non ASCII characters, punctuation, etc."),
                 h5("4) Convert to words and create Ngrams (unigrams, bigrams, trigrams and quadgrams)"),
                 h5("5) Convert Ngrams to sorted frequency tables"),
                 h5("6) Prune to remove infrequent Ngrams"),
                 h4("Efficiency considerations"),
                 p("16 GB of memory were available for data processing. Still data had to be subsampled to 50% due to memory limits.
                    My strategy was to use build the best corpus I could get using as much data as possible and then use a relatively
                    straightforward approach like Stupid Backoff for predicting.
                   "),
                 h5("1) It is better to process one Ngram-type at a time from start to finish and then delete all the intermediates before starting the next Ngram, 
                     e.g. do all operations on quadgrams first before starting trigrams"),
                 h5("2) Rare Ngrams can be pruned (removed) as they have little predictive power. This reduces the size of the corpus as well as the runtime of the predictive algorithm."),
                 h5("3) Pruning Ngrams with counts less than 5 were excluded. This yielded a corpus of 17MB which results in acceptable runtime on the server."),
                 h5("4) The pruned tables can be reduced by converting from factor to character variables."),
                 h5("3) When it comes to unigrams only the most frequent unigram needs to be stored. This is because if the algorithm has to resort to unigrams no 
                     match was found and simply the most frequent word overall is printed"),
                 h4("Prediction Algorithm"),
                 p("I used a Stupid Backoff model to predict the most likely next word. I prefer this approach as it is relatively straightforward and I wrote the......"),
                 h5("1) Load a dataset of Ngrams and their frequencies. I am using 4-, 3, 2 and 1-grams for the prediction."),
                 h5("2) Parse and clean input. Then split into words and generate search phrases from right to left (e.g. phrases of 3 words to search against 4-grams)."),
                 h5("3) Search 4-gram data for entries beginning with the 3-word phrase using grep. Then search 3-gram data with 2-word phrases and
                     2-gram data with 1-word phrases. Add 1-gram results which is simply the most frequent word overall (no search involved)."),
                 h5("4) Collate search results in one table and calculate probabilities. The probability is the frequency of a match divided by the sum of frequencies of all matches."),
                 h5("5) Calculate adjusted probabilities. This is important to make results comparable between results for 4-grams, 3-grams, etc. This is done
                     by multiplying probabilities by a factor alpha for each backoff, i.e. when going from N to N-1 grams. This process gives longer matches
                     more weight. Empirically 0.4 has been determined as an optimal value for alpha. I experimented with increasing and lowering alpha but did
                    not observe any improvements"),
                 h5("Return the last word of the Ngram with the highest adjusted probability. This is the predicted next word.  Also return a table of the 10 best matches.")
        ), # tabPanel("Algorithm Details",
        tabPanel("Supplementary Information",
                 br(),
                 p("Supplementary information is stored on GitHub. This includes the code to download and process the text corpus,
                    the prediction algorithm and the UI and server scripts for the Shiny app."),
                 a(href="https://github.com/OliverDeusch/TextPredictionCapstone", "GitHub page"),
                 br(),
                 a(href="http://rpubs.com/OliverDeusch/215725", "Short presentation on App at RPubs")
                 ) # tabPanel("Supplementary Information",        
      ) # tabsetPanel(
    ) # mainPanel(
  ) # mainPanel(
)) # shinyUI(fluidPage(