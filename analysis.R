# -- LOAD PACKAGES ---
{
# install.packages("tidyverse")
# install.packages("dplyr")
# install.packages("berryFunctions")
# install.packages("ggplot2")
# install.packages("stringr")
#   
# library("tidyverse")
# library("berryFunctions")
# library("dplyr")
# library("ggplot2")
# library(stringr)
}

# --- ELO SUBTABLE ---
# Following code makes a subtable that sorts each game played into three categories of games based on the time control.
# The table also sorts Harsh's elo for each game regardless of if playing Black or White.
{

# Lists for each time control category
bullet_list <-list("60","60+1","120+1")
blitz_list <-list("180","180+2","300","300+5")
rapid_list <- list("1800","600","600+5","3600","7200","900+10")

elo_subtable <- data.frame(game_dates,time_control,white_player,white_elo,black_elo,black_player)

# Organizes the elo rating out based on if Harsh's chess.com account name is either the Black or White player
elo_subtable$Harsh_elo <- ifelse(elo_subtable$white_player == "BrownInTown94", elo_subtable$white_elo, elo_subtable$black_elo)

# Classifies each game into the three time control categories
elo_subtable <- mutate(elo_subtable, time_control_cat =
                         ifelse(time_control %in% bullet_list, "Bullet",
                         ifelse(time_control %in% blitz_list, "Blitz",
                         ifelse(time_control %in% rapid_list, "Rapid", "Other"
                                ))))

# Removing games not listed in identified time control categories due to not haveing many data points in those time controls
elo_subtable <- elo_subtable %>%
  filter(!(time_control_cat == "Other"))
}

# --- GAMES PLAYED ---
# The following code aggregates the number of games played each year for each time control category
{
  
games_played <- select(elo_subtable,game_dates,time_control_cat)
games_played$year <- strftime(games_played$game_dates , "%Y")

# Data frames for all games played in each time control
games_played_bullet <- filter(games_played, time_control_cat == "Bullet")
games_played_blitz <- filter(games_played, time_control_cat == "Blitz")
games_played_rapid <- filter(games_played, time_control_cat == "Rapid")

# Aggregates each time control for number of games played each year
games_played_aggr1 <- aggregate(games_played_bullet$time_control_cat ~ year,games_played_bullet, FUN = length)
names(games_played_aggr1)[2] = "games_played"
games_played_aggr1 <- mutate(games_played_aggr1, time_control_cat = "bullet")

games_played_aggr2 <- aggregate(games_played_blitz$time_control_cat ~ year,games_played_blitz, FUN = length)
names(games_played_aggr2)[2] = "games_played"
games_played_aggr2 <- mutate(games_played_aggr2, time_control_cat = "blitz")

games_played_aggr3 <- aggregate(games_played_rapid$time_control_cat ~ year,games_played_rapid, FUN = length)
names(games_played_aggr3)[2] = "games_played"
games_played_aggr3 <- mutate(games_played_aggr3, time_control_cat = "rapid")

# Combines all three aggregate time control tables to one large one that will be plotted. Also correct data types
games_played_aggr_all <- rbind(games_played_aggr1, games_played_aggr2, games_played_aggr3)
games_played_aggr_all$year <- as.numeric(games_played_aggr_all$year)
games_played_aggr_all$elo <- as.numeric(games_played_aggr_all$games_played)

}

# --- FINAL POSITION ANALYSIS ---
# Following code is used to find the average number of specific pieces remaining for Harsh and his opponent when
# Harsh wins or loses a game.
{

final_position_subtable <- select(chess_game_data, white_player, black_player, notations ,match_result, final_position, game_link)

# Identifies if Harsh won or lost each game
final_position_subtable$result <- ifelse(grepl("drawn",final_position_subtable$match_result), "draw",
                                  ifelse(grepl("BrownInTown94",final_position_subtable$match_result), "won", "lost"))

# Pulls the first field of the final position code from the FEN notation
final_position_subtable$field1 <- str_extract(final_position_subtable$final_position,  "^[^ ]+")

# Counts the number of pieces Harsh and his opponent has at the end of the each game. Then adds up each peice value to determine
# the piece point advantage Harsh has. Negative would mean his opponent has more piece advantage.
# White = Upper Case, Black = Lower Case
# P or p = Pawn
# R or r = Rook
# N or n = Knight
# B or b = Bishop
# Q or q = Queen

final_position_subtable <- final_position_subtable %>% 
  mutate(P_count_Harsh = ifelse(white_player == "BrownInTown94", str_count(field1, "P") , str_count(field1, "p"))) %>% 
  mutate(R_count_Harsh = ifelse(white_player == "BrownInTown94", str_count(field1, "R") , str_count(field1, "r"))) %>% 
  mutate(N_count_Harsh = ifelse(white_player == "BrownInTown94", str_count(field1, "N") , str_count(field1, "n"))) %>%
  mutate(B_count_Harsh = ifelse(white_player == "BrownInTown94", str_count(field1, "B") , str_count(field1, "b"))) %>%
  mutate(Q_count_Harsh = ifelse(white_player == "BrownInTown94", str_count(field1, "Q") , str_count(field1, "q"))) %>%

  mutate(P_count_Oppenent = ifelse(white_player == "BrownInTown94", str_count(field1, "p") , str_count(field1, "P"))) %>% 
  mutate(R_count_Oppenent = ifelse(white_player == "BrownInTown94", str_count(field1, "r") , str_count(field1, "R"))) %>% 
  mutate(N_count_Oppenent = ifelse(white_player == "BrownInTown94", str_count(field1, "n") , str_count(field1, "N"))) %>% 
  mutate(B_count_Oppenent = ifelse(white_player == "BrownInTown94", str_count(field1, "b") , str_count(field1, "B"))) %>% 
  mutate(Q_count_Oppenent = ifelse(white_player == "BrownInTown94", str_count(field1, "q") , str_count(field1, "Q"))) %>% 
  
  mutate(points = (P_count_Harsh + (R_count_Harsh*5) + (N_count_Harsh*3) + (B_count_Harsh*3) + (Q_count_Harsh*8)) - 
                  (P_count_Oppenent + (R_count_Oppenent*5) + (N_count_Oppenent*3) + (B_count_Oppenent*3) + (Q_count_Oppenent*8)))

# Filters down to only games won, then finds the average number of pieces remaining at the end of the game
piece_count_means_won <- select(filter(final_position_subtable, result == "won"),
          P_count_Harsh, R_count_Harsh, N_count_Harsh, B_count_Harsh, Q_count_Harsh,
          P_count_Oppenent, R_count_Oppenent, N_count_Oppenent, B_count_Oppenent, Q_count_Oppenent) %>% 
  summarize(across(everything(), mean, na.rm = TRUE))

# Reformats data from wide to long structure in order to be easier to plot
piece_count_means_won <- gather(piece_count_means_won, key = "Piece", value = "Count")
piece_count_means_won$Group <- rep(c("Harsh Piece Count", "Opponent Piece Count"), 5)
piece_count_means_won$Piece <- c(rep(c("Pawn", "Rook", "Knight", "Bishop", "Queen"),1))


# Filters down to only games lost, then finds the average number of pieces remaining at the end of the game
piece_count_means_lost <- select(filter(final_position_subtable, result == "lost"),
                                P_count_Harsh, R_count_Harsh, N_count_Harsh, B_count_Harsh, Q_count_Harsh,
                                P_count_Oppenent, R_count_Oppenent, N_count_Oppenent, B_count_Oppenent, Q_count_Oppenent) %>% 
  summarize(across(everything(), mean, na.rm = TRUE))

# Reformats data from wide to long structure in order to be easier to plot
piece_count_means_lost <- gather(piece_count_means_lost, key = "Piece", value = "Count")
piece_count_means_lost$Group <- rep(c("Harsh Piece Count", "Opponent Piece Count"), 5)
piece_count_means_lost$Piece <- c(rep(c("Pawn", "Rook", "Knight", "Bishop", "Queen"),1))

}

# --- NOTABLE GAMES ---
# The following code is to help identify notable games. In this analysis, a notable game is considered winning down on material,
# and checkmating the opponent with an uncommon peice such as a Knight or Pawn
{
  
notable_games_subtable <- final_position_subtable %>% 
  select(result, notations, points, game_link)

# The following chunk of code has multiple operations. It first checks and filters down for games won with checkmate. Checkmat is
# is identified with a "#" in the notations. Next operation pulls the checkmating move then identifies which peice was used
notable_games_subtable <- notable_games_subtable %>%
  mutate(checkmate = str_count(notations,"#")) %>%
  filter(result == "won" & checkmate == 1) %>%
  mutate(pound_loc = str_locate(notations, "#")) %>% 
  mutate(checkmate_move_rough_pull = substr(notations, pound_loc[, "start"] - 7, pound_loc[, "end"])) %>% 
  mutate(checkmate_move = str_extract(checkmate_move_rough_pull, "(?<=\\s)\\S+(?=#)")) %>% 
  select(result, notations, points, game_link, checkmate_move) %>% 
  mutate(mating_peice = ifelse(str_count(checkmate_move,"Q"), "Queen",
                        ifelse(str_count(checkmate_move,"R"), "Rook",
                        ifelse(str_count(checkmate_move,"B"), "Bishop",
                        ifelse(str_count(checkmate_move,"N"), "Knight", "Pawn")))))

# Counts the number of times a peice was used for checkmate
mating_peice_totals <- notable_games_subtable %>% 
  count(mating_peice)

# Counts the number of times a specific checkmating move was played with the Queen
mating_move_queen <- notable_games_subtable %>% 
  filter(mating_peice == "Queen") %>% 
  mutate(final_square = substr(checkmate_move, nchar(checkmate_move)-1, nchar(checkmate_move))) %>% 
  count(final_square) %>% 
  arrange(n) %>% 
  filter(n > 0)

  # last_two_characters <- substr(my_string, nchar(my_string) - 1, nchar(my_string))
  
  
}

# --- PLOTS ---
# All plots that are generated from the previous data analysis
{

# --- Mating Piece ---
plot_mating_peice <- ggplot(mating_peice_totals, aes(x = mating_peice, y = n)) +
  geom_bar(stat = "identity", position = "dodge", color = "black" , fill = "skyblue") +
  labs(title = "Checkmating Piece", subtitle = "Number of times a piece was used to checkmate the opponent ", x = "Mating Peice" , y = "") +
  theme_minimal() +
  theme(plot.subtitle = element_text(size = 9))


# --- Queen Mating Move ---
plot_mating_move_queen <- ggplot(mating_move_queen, aes(x = reorder(final_square, -n), y = n)) +
  geom_bar(stat = "identity", position = "dodge", color = "black" , fill = "skyblue") +
labs(title = "Queen Checkmating Position", subtitle = "Square that Queen delivered checkmate", x = "Square" , y = "Number of Checkmates") +
  theme_minimal() +
  theme(plot.subtitle = element_text(size = 9))


# --- plot_final_piece_counts ---
plot_piece_counts_won <- ggplot(piece_count_means_won, aes(x = Piece, y = Count, fill = Group)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(title = "Average Piece Counts When Harsh Wins", y = "Count") +
  theme_minimal()

plot_piece_counts_lost <- ggplot(piece_count_means_lost, aes(x = Piece, y = Count, fill = Group)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(title = "Average Piece Counts When Harsh Loses", y = "Count") +
  theme_minimal()


# --- Harsh's Games Played ---
plot_games_played <- ggplot(games_played_aggr_all, aes(x = year, y = games_played, color = time_control_cat)) +
  geom_line(size = 1.25) +
  labs(x = "" , y = "Games Played", title = "Chess Games Played") +
  theme(plot.title = element_text(size = 20, hjust = .5))+
  guides(color = guide_legend(title = "Time Control")) +
  theme_minimal()


# --- Harsh's Chess Elo Plot ---
plot_elo_rating <- ggplot(data = elo_subtable) +
  geom_smooth(mapping = aes (x=game_dates, y=Harsh_elo, color = time_control_cat),se = FALSE) +
  labs(x = "" , y = "Elo Rating", title = "Harsh's Chess Elo") +
  theme(plot.title = element_text(size = 20, hjust = .5))+
  guides(color = guide_legend(title = "Time Control"))+
  theme_minimal() +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y")

}