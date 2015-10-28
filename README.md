# smart_autocorrect

This is a toy application which takes your sentence as input and gives back the sentence which finds if a word is present in the dictionary or not.

If yes, it just gives the word back. If not, it will show you top 5 possible words that you may have meant.

To use this application in development:

1. clone it

prerequisite:

- ruby 2.2.1

run following commands in your cloned application directory.

    - bundle
    - rake db:migrate
    - rails s

your application will be running on localhost:3000

rest is easily understandable.

logic:

- I have used levenshtein distance to calculate the near word - upto 2
- generating all possible words which can be obtained with one or two edits from the wrongly typed word you have entered.
  - filter and take only those which are in dictionary
- take top 5 results among it

- To make this application a little smarter. I have used another attribute count for each word.
- it counts the number of times a person has used the words
- it increases everytime a word is entered that is there in the dictionary
- it basically is filtering suggestions on the basis of usage of a particular word because the probability of that word going to be corrected word is highest among all.
