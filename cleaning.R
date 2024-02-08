# --- LOAD PACKAGES ---
{
  
# install.packages("tidyverse")
# install.packages("dplyr")
# install.packages("berryFunctions")
# 
# library("tidyverse")
# library("berryFunctions")
# library("dplyr")

}

# --- LOAD RAW DATA ---
{
raw_data_black_games <- read.csv("Black_Games.txt")
raw_data_white_games <- read.csv("White_Games.txt")

}
# --- CLEANING RAW DATA ---
# All raw data is two csv text files. Each game is 23 row of raw data, and data structure repeats in same order.
# View first 23 rows of data in "White_Games.txt" file to see this repeating structure
{

# There appeared to be some corrupted data for a game that didn't have the correct data structure. The inconsistent
# formatting was calling the rest of the black games to be offset
raw_data_black_games_v2 <- data.frame(raw_data_black_games[-seq(25944,25964, by=1),])


names(raw_data_white_games)[1] = "raw_data"
names(raw_data_black_games_v2)[1] = "raw_data"

# Combine the raw data for white and black games played
raw_data_all_games <- rbind(raw_data_white_games,raw_data_black_games_v2)

# A game was missing a fow of data, which caused the rest of the data below it to be offset. Adding this filler line
# in order to counteract the offset
raw_data_all_games <- insertRows(raw_data_all_games,43102,"INSERTED ROW TO CORRECT OFFSET")

}

# --- PULLING DATA COLUMNS ---
# As mentioned, each game is 23 lines of raw data. The following code pulls a variable for each game and produces a
# a long vector of that variable for every game made. It concludes with merging all vectors to one data frame that
# will be much easier to performe data analsis from
{

# Sets the number index for each game. Each game has 23 lines of data. This index sets the row number of the first row of data
# for each game. Increment off this number will efficiently update the reference row number based on data to pull.
raw_data_index = seq(1,86156,by = 23)

# Pull white player name, which is always 3 rows down of start of specific game data. This method is used for each of the following
# variables being pulled with some nuance based on the data type and structure. Used substr function to help remove the "[]" symbols
white_player <- data.frame(raw_data_all_games$raw_data[raw_data_index + 3]) 
names(white_player)[1] = "white_player"
white_player <- mutate(white_player,charcters = nchar(white_player))
white_player <- data.frame(substr(white_player$white_player,8,white_player$charcters-1))
names(white_player)[1] = "white_player"

black_player <- data.frame(raw_data_all_games$raw_data[raw_data_index + 4]) 
names(black_player)[1] = "black_player"
black_player <- mutate(black_player,charcters = nchar(black_player))
black_player <- data.frame(substr(black_player$black_player,8,black_player$charcters-1))
names(black_player)[1] = "black_player"

final_position <- data.frame(raw_data_all_games$raw_data[raw_data_index + 6])
names(final_position)[1] = "final_position"
final_position <- mutate(final_position,charcters = nchar(final_position))
final_position <- data.frame(substr(final_position$final_position,18,final_position$charcters-1))
names(final_position)[1] = "final_position"

opening_code <- data.frame(raw_data_all_games$raw_data[raw_data_index + 8])
names(opening_code)[1] = "opening_code"
opening_code <- mutate(opening_code,charcters = nchar(opening_code))
opening_code <- data.frame(substr(opening_code$opening_code,2,opening_code$charcters-1))
names(opening_code)[1] = "opening_code"

opening <- data.frame(raw_data_all_games$raw_data[raw_data_index + 9])
names(opening)[1] = "opening"
opening <- mutate(opening,charcters = nchar(opening))
opening <- data.frame(substr(opening$opening,40,opening$charcters-1))
names(opening)[1] = "opening"


# Game dates was pulling as a char data type when it needs to be in a date format
game_dates <- data.frame(raw_data_all_games$raw_data[raw_data_index + 10])
names(game_dates)[1] = "game_dates"
game_dates <- data.frame(substr(game_dates$game_dates,10,19))
names(game_dates)[1] = "game_dates"
game_dates$year <- substr(game_dates$game_dates,0,4)
game_dates$month <- substr(game_dates$game_dates,6,7)
game_dates$day <- substr(game_dates$game_dates,9,10)
game_dates <- data.frame(paste(game_dates$year,"/",game_dates$month,"/",game_dates$day,sep = ""))
names(game_dates)[1] = "game_dates"
game_dates <- data.frame(as.Date(game_dates$game_dates))
names(game_dates)[1] = "game_dates"

# Elo number was being pulled as a char data type and needed to be num data type
white_elo <- data.frame(raw_data_all_games$raw_data[raw_data_index + 12])
names(white_elo)[1] = "white_elo"
white_elo <- mutate(white_elo,charcters = nchar(white_elo))
white_elo <- data.frame(substr(white_elo$white_elo,10,white_elo$charcters-1))
names(white_elo)[1] = "white_elo"
white_elo <- as.numeric(white_elo$white)
names(white_elo)[1] = "white_elo"

# Elo number was being pulled as a char data type and needed to be num data type
black_elo <- data.frame(raw_data_all_games$raw_data[raw_data_index + 13])
names(black_elo)[1] = "black_elo"
black_elo <- mutate(black_elo,charcters = nchar(black_elo))
black_elo <- data.frame(substr(black_elo$black_elo,10,black_elo$charcters-1))
names(black_elo)[1] = "black_elo"
black_elo <- as.numeric(black_elo$black_elo)
names(black_elo)[1] = "black_elo"

time_control <- data.frame(raw_data_all_games$raw_data[raw_data_index + 14])
names(time_control)[1] = "time_control"
time_control <- mutate(time_control,charcters = nchar(time_control))
time_control <- data.frame(substr(time_control$time_control,14,time_control$charcters-1))
names(time_control)[1] = "time_control"

match_result <- data.frame(raw_data_all_games$raw_data[raw_data_index + 15])
names(match_result)[1] = "match_result"
match_result <- mutate(match_result,charcters = nchar(match_result))
match_result <- data.frame(substr(match_result$match_result,2,match_result$charcters-1))
names(match_result)[1] = "match_result"

game_link <- data.frame(raw_data_all_games$raw_data[raw_data_index + 19])
names(game_link)[1] = "game_link"
game_link <- mutate(game_link,charcters = nchar(game_link))
game_link <- data.frame(substr(game_link$game_link,7,game_link$charcters-1))
names(game_link)[1] = "game_link"

notations <- data.frame(raw_data_all_games$raw_data[raw_data_index + 21])
names(notations)[1] = "notations"

}

# --- COMBINE TO FINAL DATA FRAME ---
# Final data frame that organizes every games with specific variables broken out
{
chess_game_data <- data.frame(game_dates, 
                              white_player, white_elo,
                              black_player, black_elo,
                              time_control, opening_code, opening,
                              notations, final_position, match_result,
                              game_link)
}