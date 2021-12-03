# Bayesian Networks Assignment 1

This repo contains the code developed for the first assignment of the Bayesian Networks & Causal Inference course at the Radboud University (NWI-IMC012).

## Brief Introduction

In recent years, forest fires have been occurring more frequently and more intensely.
Not only does this result in increased environmental damage, but these forest fires also become harder to fight.
Therefore, understanding the factors that influence such forest fires is important, 
and these insights might also be used to predict the severity of forest fires.
One system that aims to describe the influence of weather related factors on forest fires is the Fire Weather Index (FWI).
In this work, we aim to build a Bayesian Network for predicting the total area burned by forest fires, using data that is also used in the FWI.
The goal is to better understand how these weather related factors are related to each other.
On top of that, if it is possible to make reasonable predictions, this method could be used to fight forest fires more proactively.
Although predictions were not great (MAE of approximately 8.8 and 12.48 on train en test data respectively), we found some interesting insights in how FWI components only have a weak influence on the burned area of a forest fire.

## Structure of this Repo

This repo contains the following folders:

- `imgs` contains image of the Bayesian networks developed, and an overview of the Fire Weather Index (FWI).
- `plts` contains some examples of plots that were generated in this project.

This repo also contains the following important files:

 - `assignment1.R` contains the fundamental code regarding the project: Building the Bayesian network, fitting it, performing predictions and computing path coefficients.
 - `data_exploration.R` contains all the code that we used for exploring and preprocessing the dataset. 
 - `forestfires.csv` is the original dataset, as it is publicly available on the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Forest+Fires). This data is used in `data_exploration.R`.
 - `explored_forestfires.csv` contains the preprocessed data, after executing `data_exploration.R`. This file is used in `assignment1.R`.

## Collaboration

This project has been done in a team of three people:
 - [Avuerro](https://github.com/Avuerro)
 - [ElFilosofoX](https://github.com/ElFilosofoX)
 - [JordAI](https://github.com/jordai)

