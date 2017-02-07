# https://www.r-bloggers.com/kung-fu-r/?utm_source=feedburner&utm_medium=email&utm_campaign=Feed%3A+RBloggers+%28R+bloggers%29

# KUNG FU R 
library(scales)
library(ggthemes)
library(tidyjson)
library(tidyverse)
library(forcats)

filename = './data/shaw.json'
shaw_json <- paste(readLines(filename), collapse="")

# Then use tidyjson to convert the nested form into a flat data frame (tibble) we can work with.
films <- shaw_json %>% as.tbl_json %>% gather_array %>%
  spread_values(
    title = jstring("title"),
    director = jstring('director'),
    year = jstring('year'),
    avg_rating = jnumber('avg_rating'),
    watches = jnumber("watches"),
    likes = jnumber("likes"),
    time = jnumber("time")
  )

films %>% head(n = 5) %>% select(title, director, year)

cast <- shaw_json  %>% as.tbl_json  %>% gather_array %>%
  spread_values(
    title = jstring("title"),
    director = jstring('director'),
    year = jstring('year'),
    avg_rating = jnumber('avg_rating'),
    watches = jnumber("watches"),
    likes = jnumber("likes"),
    time = jnumber("time")
  ) %>% enter_object("cast") %>% gather_array() %>%
  spread_values(
    name = jstring("name")
  )

cast %>% head(n = 8) %>% select(title, year, name)

characters <- shaw_json  %>% as.tbl_json  %>% gather_array %>%
  spread_values(
    title = jstring("title"),
    director = jstring('director'),
    year = jstring('year'),
    avg_rating = jnumber('avg_rating'),
    watches = jnumber("watches"),
    likes = jnumber("likes")
  ) %>% enter_object("characters") %>% gather_array() %>%
  spread_values(
    name = jstring("name")
  )

  nrow(films)
  
# So, I said retro, when exactly were these movies made?
  films %>% ggplot(aes(x = year)) +
  geom_bar() +
  labs(title = 'Shaw Bros Films by Year') + 
  theme_fivethirtyeight()
ggsave("imgs/films_by_year.png", width = 8, height = 5)


by_director <- films %>% group_by(director) %>% summarise(n = n()) %>% arrange(-n)

  by_director %>% filter(n > 1) %>%
  ggplot(aes(x = fct_reorder(director, n), y = n)) + 
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = 'Counts of Shaw Bros Films by Director') +
  theme_fivethirtyeight()
ggsave("imgs/director_count.png", width = 8, height = 6)

# pull out just the top 5 directors
top_directors <- by_director %>% head(n = 5)
# filter films to those directed by these titans of Kung fu
films_top_director <- films %>% filter(director %in% top_directors$director)

#plot bar chart
films_top_director %>%
  ggplot(aes(x = year)) +
  geom_bar(aes(fill = director)) +
  labs(title = 'Shaw Bros Top Director Count by Year') + 
  theme_fivethirtyeight()
# Try Fill Position
films_top_director %>%
  ggplot(aes(x = year)) +
  geom_bar(aes(fill = director), position = "fill") +
  labs(title = 'Shaw Bros Top Director Count by Year') + 
  theme_fivethirtyeight()


films_top_director_all <- films %>% mutate(director_label = ifelse(director %in% top_directors$director, director, 'Other'))

films_top_director_all %>%
  ggplot(aes(x = year)) +
  geom_bar(aes(fill = director_label)) +
  labs(title = 'Shaw Bros Director Count by Year', fill = '') + 
  theme_fivethirtyeight()

ggsave("imgs/top_directors_by_year.png", width = 8, height = 5)
films_top_director_all %>%
  ggplot(aes(x = year)) +
  geom_bar(aes(fill = director_label), position = 'fill') +
  labs(title = 'Shaw Bros Director Count by Year', fill = '') + 
  theme_fivethirtyeight() +
  scale_y_continuous(labels = percent)
ggsave("imgs/top_directors_by_year_fill.png", width = 8, height = 5)


summary(films)
film_summary <- films %>% group_by(year) %>% summarise(n = n(), mean_time = mean(time, na.rm = TRUE))
film_summary %>%
  ggplot(aes(x = year, y = mean_time)) +
  geom_bar(stat = "identity") +
  labs(title = 'Shaw Bros Length by Year (in mins)') + 
  theme_fivethirtyeight()
#ggsave("imgs/films_by_year.png", width = 8, height = 5)
films %>%
  ggplot(aes(x = year, y = time )) +
  geom_boxplot() +
  labs(title = 'Shaw Bros Length by Year (in mins)') + 
  theme_fivethirtyeight()
films %>%
  ggplot(aes(x = year, y = avg_rating )) +
  geom_boxplot() +
  labs(title = 'Shaw Bros Rating by Year') + 
  theme_fivethirtyeight()

films %>%
  ggplot(aes(x = year, y = watches )) +
  geom_boxplot() +
  labs(title = 'Shaw Bros Watches by Year') + 
  theme_fivethirtyeight()
films %>% filter(watches > 200) %>% select(title, year, watches) %>% arrange(-watches)
films  %>%
  ggplot(aes(x = watches, y = avg_rating)) +
  geom_point()
films  %>%
  ggplot(aes(x = watches, y = likes)) +
  geom_point() + 
  labs(title = "Watches vs Likes of Kung Fu Movies") +
  theme_fivethirtyeight()


ggsave("imgs/watches_vs_likes.png", width = 8, height = 5)
films  %>%
  ggplot(aes(x = avg_rating, y = likes)) +
  geom_point()
films %>%
  ggplot(aes(x = year, y = likes )) +
  geom_boxplot() +
  labs(title = 'Shaw Bros Rating by Year') + 
  theme_fivethirtyeight()

Title Showdown

library(tidytext)

# load stop_words into R environment
data("stop_words")
# saves entire title in `title_all` column, 
# then splits up title column creating the `word` column - 
# with a row for every token (word).
titles <- films %>% mutate(title_all = title) %>% unnest_tokens(word, title)

# filter stopwords
titles_filter <- titles %>% anti_join(stop_words, by = "word")
by_word <- titles_filter %>% count(word, sort = TRUE)
by_word %>%
  filter(n > 3) %>% 
  ggplot(aes(x = fct_reorder(word, n), y = n)) +
  geom_bar(stat = 'identity') +
  coord_flip() + 
  labs(title = 'Top Words Used in Kung Fu Titles') +
  theme_fivethirtyeight()
ggsave("imgs/top_words_in_titles.png",  width = 8, height = 6)
top_word <- by_word %>% head(n = 12)
films_top_word <- titles %>% filter(word %in% top_word$word)

films_top_word %>% 
  ggplot(aes(x = year)) +
  geom_bar() +
  labs(title = 'Titles with Most Common Words by Year') + 
  facet_wrap( ~ fct_relevel(word, top_word$word)) +
  scale_x_discrete(labels = function(x) { return(ifelse(as.numeric(x) %% 2, x, '')) }) +
  theme_fivethirtyeight() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position="none")
ggsave("imgs/top_words_by_time.png", width = 8, height = 6)

# Swordsman or Shaolin?

top2_word <- by_word %>% head(n = 2)
films_top2_word <- titles %>% filter(word %in% top2_word$word)

films_top2_word %>% 
  ggplot(aes(x = year, fill = fct_inorder(word))) +
  geom_bar() +
  labs(title = 'Swordsman vs Shaolin by Year', fill = '') + 
  #scale_x_discrete(labels = function(x) { return(ifelse(as.numeric(x) %% 2, x, '')) }) +
  theme_fivethirtyeight() 
  #theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("imgs/shaolin_swordsman.png", width = 8, height = 5)

#Swordsman Titles

titles %>% filter(word == 'swordsman') %>% arrange(year) %>% select(title_all, year)

# shaolin titles 
titles %>% filter(word == 'shaolin') %>% arrange(year) %>% select(title_all, year)

# First, just like directors, we can look at counts by actor.

by_actor <- cast %>% group_by(name) %>% summarise(n = n()) %>% arrange(-n)

by_actor %>% filter(n > 20) %>%
  ggplot(aes(x = fct_reorder(name, n), y = n)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = 'Counts of Shaw Bros Films by Actor') +
  theme_fivethirtyeight()
ggsave("imgs/actor_counts.png", width = 8, height = 6)

# Did most of the top actors' carreers span multiple decades, or did actors come and go quickly? Let's graph the top actor's movie count by year.
top_actor <- by_actor %>% head(n = 16)
films_top_actor <- cast %>% filter(name %in% top_actor$name)

films_top_actor %>% 
  ggplot(aes(x = year)) +
  geom_bar() +
  labs(title = 'Top Actors Film Count by Year') + 
  facet_wrap( ~ fct_relevel(name, top_actor$name)) +
  # only label half of the years to make things a bit look cleaner
  scale_x_discrete(labels = function(x) { return(ifelse(as.numeric(x) %% 2, x, '')) }) +
  theme_fivethirtyeight() + 
  # angle label text
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position="none")
ggsave("imgs/top_actors_by_year.png", width = 8, height = 10)
year_count <- films %>% select(year) %>% unique() %>% nrow()
actor_active_years <- films_top_actor %>% group_by(name) %>% 
  summarise(active_years = length(unique(year)), 
            percent_active = active_years / year_count, 
            start = min(as.numeric(year)), 
            end = max(as.numeric(year))) %>% 
  arrange(percent_active)


actor_active_years %>% 
  ggplot(aes(x = fct_inorder(name), y = percent_active)) + 
  geom_bar(stat = "identity") +
  coord_flip() + 
  scale_y_continuous(labels = percent) + 
  labs(title = "Percent of Years Active by Actor") +
  theme_fivethirtyeight()
ggsave("imgs/actor_percent_active.png", width = 8, height = 5)
actor_active_years %>% gather(caps, cap_year, start, end) %>%
  ggplot(aes(x = cap_year, y = fct_inorder(name))) +
  geom_point(size = 3) + 
  geom_path(aes(group = name)) +
  labs(title = "Shaw Brother Career Span by Actor") +
  theme_fivethirtyeight()
ggsave("imgs/actor_career_span.png", width = 8, height = 5)

Create a matrix of actor co-occurance.

summary(by_actor$n)
library(reshape2)

# filter actors not in many movies
min_movie_actors <- by_actor %>% filter(n > 5)
popular_cast <- cast %>% filter(name %in% min_movie_actors$name) 

cast_movie_matrix <- popular_cast %>%
  acast(name ~ title,  fun.aggregate = length)
dim(cast_movie_matrix)
Rows are actors. Columns are movies.

Filter out movies with few co-occuring actors

cast_movie_df_filtered <- cast_movie_matrix %>% colSums(.)
norm <- cast_movie_matrix / rowSums(cast_movie_matrix)

hc_norm_cast <- hclust(dist(norm, method = "manhattan"))
Plot:

library(ggdendro)

ggdendrogram(hc_norm_cast, rotate = TRUE)
See ordering:

ordering <-hc_norm_cast$labels[hc_norm_cast$order]
ordering
# http://stackoverflow.com/questions/13281303/creating-co-occurrence-matrix
cooccur <- cast_movie_matrix %*% t(cast_movie_matrix)

diag(cooccur) <- 0

heatmap(cooccur, symm = TRUE )
cooccur is matrix with rows and columns as actors. The cells for each actor combo indicate the number of movies they have appeared together in.

summary(rowSums(cooccur))

summary(colSums(cooccur))

summary(colSums(cooccur != 0))

collab_counts <- as.data.frame(colSums(cooccur != 0))
library(igraph)

cooccur <- cast_movie_matrix %*% t(cast_movie_matrix)
#cooccur <- ifelse(cooccur < 4, 0, cooccur)

g <- graph.adjacency(cooccur, weighted = TRUE, mode = "undirected", diag = FALSE)

summary(E(g)$weight)

summary(degree(g))

summary(strength(g))
library(igraph)

cooccur <- cast_movie_matrix %*% t(cast_movie_matrix)
#cooccur <- ifelse(cooccur < 4, 0, cooccur)

g <- graph.adjacency(cooccur, weighted = TRUE, mode = "undirected", diag = FALSE)

low_degree_v <- V(g)[degree(g) < 10] #identify those vertices part of less than three edges
g <- delete_vertices(g, low_degree_v) #exclude them from the graph

low_weight_e <- E(g)[E(g)$weight < 3]
g <- delete_edges(g, low_weight_e)

low_strength_v <- V(g)[strength(g) < 90]
g <- delete_vertices(g, low_strength_v) #exclude them from the graph

V(g)$betweenness <- strength(g)

plot(g, edge.width = E(g)$weight, 
     #layout=layout.fruchterman.reingold,
     layout=layout_with_fr,
     vertex.label.dist=0.5,
     #vertex.size = V(g)$betweenness,
     vertex.size = 3,
     vertex.color='steelblue',
     vertex.frame.color='white',        #the color of the border of the dots 
     vertex.label.color='black',        #the color of the name labels
     vertex.label.font=2,           #the font of the name labels
     vertex.label.cex=1,            #specifies the size of the font of the labels. can also be made to vary
     edge.color = hsv(0,0.2,0.5,alpha=0.2)

)
chiang_sheng <- V(g)[V(g)$name == "Chiang Sheng"]

chiang_sheng_neighbors <- neighbors(g, chiang_sheng)
neighbor_edges <- incident_edges(g, chiang_sheng_neighbors)

sub_g <- make_empty_graph(n = length(chiang_sheng_neighbors), directed = FALSE)
add_vertices(sub_g, chiang_sheng_neighbors)

#add_edges(sub_g, neighbor_edges)
#E(g)[neighbor_edges]$color = hsv(0,0.2,0.5,alpha=0.5)
V(g)$color = "grey"
V(g)[chiang_sheng]$color = "tomato"
V(g)[chiang_sheng_neighbors]$color = 'tomato'
plot(g, edge.width = E(g)$weight, 
     #layout=layout.fruchterman.reingold,
     layout=layout_with_fr,
     vertex.label.dist=0.5,
     #vertex.size = V(g)$betweenness,
     vertex.size = 5,
     vertex.color=V(g)$color,
     vertex.frame.color='white',        #the color of the border of the dots 
     vertex.label.color='black',        #the color of the name labels
     vertex.label.font=2,           #the font of the name labels
     vertex.label.cex=1,            #specifies the size of the font of the labels. can also be made to vary
     edge.color = hsv(0,0.2,0.5,alpha=0.2)
)
cooccur_df <- data.frame(cooccur, col.names = colnames(cooccur))
cooccur_df$name <- row.names(cooccur) 
cooccur_df <- cooccur_df %>% select(name, everything())
#write_delim(cooccur_df, 'shaw_cooccurance.csv', delim = ';')


