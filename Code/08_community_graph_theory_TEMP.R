# install.packages("igraph") # run once
library(igraph)

species <- c("Algae", "Zooplankton", "Small Fish", "Large Fish", "Bird")

predator <- c("Zooplankton", "Small Fish", "Large Fish", "Bird", "Bird")
prey <- c("Algae", "Zooplankton", "Small Fish", "Small Fish", "Large Fish")

#in the prey and predator groups the order is not casual, they are paired, so each prey predator correspond to a prey (e.g. the zooplankton is hte predator of the algae etc.)

interactions <- data.frame(predator, prey)
#This builds a table, a dataset with the predator prey interactions 

g <- graph_from_data_frame(interactions, vertices = species, directed = T)
#the vertices arguments specifies which are the points that are going to appear in the graph (in our case they will be the predators and preys)
#directed means that there is a direction from the predators to the preys
plot(g)

#We are going to use a function to produce an igraph from a table 
g <- graph_from_data_frame(interactions, vertices = species, directed = F)
#without directions
plot(g)

# Plot with clear labels
plot(
  g,
  layout = layout_with_fr,
  vertex.size = 30,
  vertex.color = "lightblue",
  vertex.label.color = "black",
  vertex.label.cex = 1,
  edge.arrow.size = 0.5,
  main = "A Simple Ecological Network"
)

# Stats
cat("\nNumber of species (nodes):", vcount(g))
cat("\nNumber of interactions (edges):", ecount(g))

# set.seed() function
#the set.seed function selects one of the possible graphs that we can obtain.  Set.seed (42), the number is chosen at random. 
set.seed(42)
g <- graph_from_data_frame(interactions, vertices = species, directed = T)
plot(g)
