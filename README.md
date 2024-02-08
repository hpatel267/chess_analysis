# Chess Games Analysis
## by Harsh Patel <img src ="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/2aba3bf0-2e54-433f-9938-dab5e15cdb57" height="125" align="right">
**Date last Updated: 2/6/2022**

## Table of Contents

[<img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/e6b0563b-c333-4d8a-852c-7d91ab1024d2" width="150">](#data-collection)
[<img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/fa133f15-b407-4431-a183-9aa8314752b8" width="150">](#data-cleaning)
[<img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/25439d60-4f34-474f-a8ea-ac2d31cf33f3" width="150">](#data-analysis)
[<img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/6eba635f-32ec-4d4a-831d-186d8818ef7a" width="150">](#conclusion)

## Overview 
For this project, I conducted an in-depth analysis of all the chess games I have played on Chess.com from 2018 to 2023. My objective was to uncover insights to improve my gameplay, and to illustrate the intricate nature of chess.

I chose to exclusively utilize the programming language R for this analysis. Despite being relatively new to R, I viewed this project as an opportunity to challenge myself and leverage R's robust tools for data analysis and visualization.

# Data Collection 

<img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/26266505-947a-4a8e-b0fc-f9f62027d956" width="200" align="left">

[Chess.com](https://www.chess.com) archives data for every game played on their platform. However, the website limits the number of games that can be retrieved at once. 

I discovered [openingtree.com](https://www.openingtree.com), a third-party platform that enables users to extract all their games at once. To ensure the reliability of the data, I cross-referenced it with my game data on chess.com.

The raw data was received in two long format CSV files. Each game comprises 23 lines of consistently formatted metadata. This can be seen below with explanations of somee of the key attributes.

<br>

### Chess Game Metadata Structure
~~~~~
[Event "Live Chess"]
[Site "Chess.com"]
[Date "2023.10.05"]
[Round "-"]
[White "BrownInTown94"]
[Black "RHughMyron"]
[Result "1-0"]
[CurrentPosition "r1b2rk1/pp1npp1Q/1q1p3p/6N1/2Pb4/2N3P1/PP2BPP1/R3K2R b KQ -"]
[Timezone "UTC"]
[ECO "A53"]
[ECOUrl "https://www.chess.com/openings/Old-Indian-Defense-Duz-Khotimirsky-Variation"]
[UTCDate "2023.10.05"]
[UTCTime "17:13:35"]
[WhiteElo "916"]
[BlackElo "995"]
[TimeControl "60+1"]
[Termination "BrownInTown94 won by checkmate"]
[StartTime "17:13:35"]
[EndDate "2023.10.05"]
[EndTime "17:14:46"]
[Link "https://www.chess.com/game/live/90265145607"]
                
1. d4  Nf6 2. c4  d6 3. Nc3  Nbd7 4. Bg5  h6 5. Bh4  g5 6. Bg3  Bg7 7. e3  O-O 8. Nf3  Nh5 9. Be2  Nxg3 10. hxg3  c5 11. Qd3  cxd4 12. exd4  Qb6 13. Nxg5  Bxd4 14. Qh7# 1-0
~~~~~
### *Current Position*
~~~~~
[CurrentPosition "r1b2rk1/pp1npp1Q/1q1p3p/6N1/2Pb4/2N3P1/PP2BPP1/R3K2R b KQ -"]
~~~~~

The current position data represents the final board position, and is formatted using Forsyth-Edwards Notation (FEN). FEN is a standardized notation for describing chess positions, making it possible to represent any board state. For a detailed explanation of FEN, I highly recommend reading this [Forsyth-Edwards Notation (FEN) article](https://www.chess.com/terms/fen-chess#why-is-fen-important)

<p align="center">
    <img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/ea3c8bed-50fc-4f43-992d-4856651b40c5" height="200">
</p>

### *Time Control*
~~~~~
[TimeControl "60+1"]
~~~~~
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/acadb469-7417-48a8-a1db-b97160a9d915" height="150" align="right">

The Time Control parameter defines the duration of time allocated to each player. Each player's time diminishes during their respective turns, and if their clock reaches zero, they forfeit the game. The first number in the Time Control specification denotes the initial total time for each player in seconds, while the second number indicates the increment time added to their playtime after completing a move.

In this dataset, games are categorized into formats known as Bullet, Blitz, and Rapid, based by their Time Controls seen below.

<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/1fa4e59d-9fe2-4c6b-94e3-24d652c337c7" height="175">
</p>

### *Elo Rating*
~~~~~
[WhiteElo "916"]
[BlackElo "995"]
~~~~~
The Elo rating system assesses a player's relative skill level compared to the broader population. While it is somewhat analogous to a player's strength, its primary purpose is to estimate the likely results of match based on each player's relative Elo rating. To delve deeper into the Elo Rating system, I recommend reading this [Elo Rating System article](https://www.chess.com/terms/elo-rating-chess)

In this dataset, each player's Elo rating is categorized by the different Time Control formats. This means you would have a different Elo rating for Bullet, Blitz, and Rapid time formates. 

<br>

### *Algebraic Notation*
~~~~~
1. d4  Nf6 2. c4  d6 3. Nc3  Nbd7 4. Bg5  h6 5. Bh4  g5 6. Bg3  Bg7 7. e3  O-O 8. Nf3  Nh5 9. Be2  Nxg3 10. hxg3  c5 11. Qd3  cxd4 12. exd4  Qb6 13. Nxg5  Bxd4 14. Qh7# 1-0
~~~~~

<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/673db986-b46a-4d61-adc3-e1bb2182aeda" height="200" align="right">

Algebraic notation records every move made during a game. Each turn is marked with the turn number, followed by White's and then Black's move. Typically, a move begins with a letter representing the piece, followed by a combination of letters and numbers indicating the destination square. Various notations exist, including the use of "x" to signify a capture, as demonstrated in the example image on the right for turn 9 of this game. Read this [Chess Notation article](https://www.chess.com/terms/chess-notation) for a deeper dive.

<br>
<br>

# Data Cleaning 
<img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/2f9099c9-afaf-4649-8b85-165dd4475659" width="200" align="right">

The primary objective of the data cleaning process was to convert the lengthy CSV text files into a structured data frame format. Each game entry in the raw data comprises 23 lines of metadata. I established a Base Vector that increments by 23, enabling the identification of the initial row for each game's metadata.

Subsequently, each game attribute was assigned a fixed index relative to the Base Vector. In the provided example below, the White Elo Vector is situated 13 rows from the Base Vector. Leveraging the White Elo Vector, I extracted each game's White Elo rating, eliminated redundant text, and standardized the data type to INT.

<br>

### *Base Vector and White Elo Vector Visual*
<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/c875f2f2-f4b6-452b-8149-ce26e3cecb67">
</p>

<br>

### *White Elo Data Pull and Corrections*
<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/4d4604fa-27b1-4fb8-afd1-fa9a3b7a6deb">
</p>

The methodology employed allowed for the extraction of every game attribute, which then was combined into a single data frame with correct data types. There were some nuanced steps detailed in the comments of the R code "Code - Data Cleaning.R".

For instance, a corrupted game was discovered missing certain lines of metadata. Consequently, this caused a partial offset in the Base Vector. Upon removing the corrupted game data, the Base Vector functioned as intended.

# Data Analysis

<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/87eb6913-4bae-403e-babe-c23f05b749cd" height="200" align="left">

The step-by-step preparation of the data, from the data frame to the subsequent data visualizations, is documented in the file "Code - Chess Game Analysis.R". Most common tools were the use of conditional functions, filter functions, aggragate functions, descriptive statistics functions, and ggplot data visualizations.

Each data visualization is presented with insights directly derived from the data and key takeaways.

<br>
<br>

## Elo Trends

<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/e4cc15aa-9bbf-4399-8426-ca821e9abd81" height="300">
</p>

### *Insights*
In 2022 there was a large shift in Elo ratings and total games played
* Bullet Elo became volatile (fastest time format)
* Blitz Elo improved (mid-speed time format).
* Rapid Elo declined (slowest time format).
* There was a significant increase in Bullet games played, coupled with a decrease in Blitz games played.

### *Key Takeaways*
In chess, Time Controls significantly influence the style of play. Faster formats like Blitz and Bullet often rely on instinct, while slower time formats like Rapid allow for deeper analysis.

As I played more Bullet games in 2022, my chess strategy became more instinctual, diminishing the emphasis on analysis. Consequently, this shift adversely impacted my Rapid Elo, as it fostered habits better suited for Bullet games.

However, my Blitz Elo saw improvement as Blitz serves as a middle ground between Bullet and Rapid, accommodating both instinctual moves and some degree of strategic planning.

## Average Piece Counts (Win vs Lost)

<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/5c4bc53f-8b41-49cd-a3df-52c289f2d742" height="350">
</p>

### *Insights*
This data shows the average number of pieces my opponent and I had at the end of the game depending on if I had won or lost the game
* For games won, I have advantage with my Pawns and Queen, and Knights have little impact
* For games lost, I have disadvantage with my Pawns and Queen; however, I am still up in Rooks
* Both charts are essiently mirrored except for Knight and Rooks

### *Key Takeaways*
At my level of play, both my opponent and I rely heavily on our Queens and Pawns. While Knights don't seem to provide a significant advantage when I win, they do seem play a role in my opponents' victories. Improving my proficiency with Knights could lead to more wins, especially when I have an advantage in Knight count. Interestingly, a Rook advantage doesn't significantly impact games when I lose. I believe this might be due to exchanging rooks for queens; however, further analysis is needed to understand this dynamic.

## Checkmating Piece

<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/3d91ffa5-748b-44e9-9cb7-843020303138" height="350" align="right">

### *Insights*
"This data outlines the pieces I used to deliver checkmate in games
* Checkmate is predominantly delivered by the Queen, with roughly a third less by Rooks.
* Checkmates with Knights and Pawns are equally uncommon.
* Bishop checkmates are slightly more common than Knight checkmates.

### *Key Takeaways*
Queens are the most powerful piece, and is the easiet to checkmate with. Rooks are the next strongest piece, and have simple checkmating paterns in the end game.

Knights, although stronger than Pawns, are challenging to use for delivering checkmate due to their tricky movement. Bishops and Knights possess comparable strength, but Bishops excel in the endgame with clearer movement patterns. This explains the slightly higher frequency of checkmates with Bishops.

## Queen Checkmating Squares

<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/4b7b4e44-ff6a-4d1e-a56c-fbe704f4c3c8" height="400" align="right">

### *Insights*
This data is showing the total number of times I delivered checkmate with the Queen on each square.
* Column positions are identified by letters, while rows are identified by numbers.
* Two prominent hotspots are observed around g7 and g2.
* Additionally, two spots of interest are noted at b2 and b7.

### *Key Takeaways*
Typically, both players will castle their Kings short, positioning them on g8 and g1 respectively. This setup often correlates with the Queen delivering checkmate around these squares.

Less commonly, players opt for long castling, placing their Kings on c1 and c8. This also relates to the hot spots at b2 and b7.

As White, I frequently employ the Queen’s Gambit opening, which applies additional pressure around the g7 square. Consequently, more checkmates occur in proximity to g7.

## Notable Checkmates

<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/56e41a6c-26e7-4760-a880-b6fd01bc516d" height="325" align="right">

Utilizing the analyzed data for games won by checkmate, I searched for games that ended in notable checkmates.

Can you identify the winning move for White seen in the image on the right?

<details>
  <summary>CLICK HERE to see winning combination</summary>

  <h1 style="font-size: 64px;">Pawn to c2!</h1>

  This move checks the Black King and forces it to move to either c4 or c5. In either case, the result is checkmate against Black by a Pawn! As shown with the previous data, this is very rare!
  
  When executed correctly by White, this combination is termed a "Mate in Three." This implies that regardless of Black's response, White will achieve checkmate within three moves.

<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/16a2bdf8-e6a9-4df0-995d-f4d9cd9768da" height="300">
</p>


<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/fada60b3-000d-464a-8672-28eefcf254bd">
</p>

</details>

## Other Notable Checkmates
Here are some other notable checkmates that can be viewed on Chess.com
* [Rook Sack Checkmate](https://www.chess.com/analysis/game/live/4152911213?tab=review&move=36)
* [Bishop and Queen Sack Checkmate](https://www.chess.com/analysis/game/live/13492923157?tab=review&move=37)
* [Queen Sack Mate in 3](https://www.chess.com/analysis/game/live/13107128945?tab=review&move=30)
* [Knight Smothered Checkmate](https://www.chess.com/analysis/game/live/3005976276?tab=review&move=23)
* [Pawn Mate in 3](https://www.chess.com/game/live/3610354227)
* [Mid Game Knight Mate](https://www.chess.com/game/live/65820803219)
* [Knight Discovered Check, Mate in 3](https://www.chess.com/game/live/2999297096)
* [Bishop Smothered Mate](https://www.chess.com/game/live/78912041549)
* [En Passant to Bishop Smothered Mate](https://www.chess.com/game/live/89999315309)

# Conclusion

<img src="https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/72ec127f-6514-41c2-9f92-b8b8890492c5" width="200" align="right">

In this analysis, I deepened my understanding of R's functions and capabilities. Moving forward, I'll use this code to assess my progress in two key areas:
* Enhancing my Knight chess play.
* Shifting focus to longer time control formats to avoid relying solely on instincts.

In the future, analyzing chess Grandmaster play would be intriguing. I anticipate that the margin of advantage may be minimal at higher competitive levels. Additionally, examining a diverse spectrum of chess play could benefit players at all skill levels.

Exploring Chess documentation, including Forsyth-Edwards Notation and Algebraic Notation, was enlightening. These concepts demonstrate how complex chess positions can be represented as structured data. Additionally, discovering notable checkmates and Queen checkmate patterns was a highlight of this analysis.

I hope this analysis inspires you to play chess! It's a timeless game that people at all levels can enjoy

<p align="center">
<img src = "https://github.com/hpatel267/Harsh-Patel-Portfolio/assets/151773608/06dff93e-355a-453d-864f-9bbefc6e09ea">
</p>

<br>
<br>
<br>
<br>
<br>
<br>
