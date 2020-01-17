 #################################################################
 ##                 Pull Spotify Mood Playlists                 ##
 ##                        Joel Larwood                         ##
 ##                        @JoelLarwood                         ##
 #################################################################
 
 ##----------------------------------------------------------------
 ##                          Package Load                         -
 ##----------------------------------------------------------------
 
#install.packages("spotifyr")
library(spotifyr)
#install.packages("genius")
library(genius)
#install.packages("countrycode")
library(countrycode)
#install.packages("tidyverse")
library(tidyverse)
#install.packages("cld2")
library(cld2)

 ##----------------------------------------------------------------
 ##                    Set up spotify details                     -
 ##----------------------------------------------------------------
 
source("SpotifyKey.R")


 ##---------------------------------------------------------------
 ##                        Get mood playlists                    -
 ##---------------------------------------------------------------
 
# I am going to be taking from playlists spotify has tagged with "mood"
# I am going to do this from a number of countries


countries <- countrycode(sourcevar = c("Australia", "USA", "United Kingdom", "Canada", "New Zealand", "Ireland"), 
                         origin = "country.name",
                        destination ='iso2c')


mood_playlists <- data.frame()

for (i in countries){ 
  tmp_playlist = spotifyr::get_category_playlists(category_id = "mood", 
                                                  country = i)
  mood_playlists = rbind(tmp_playlist, mood_playlists)
}



 ##---------------------------------------------------------------
 ##                'Happy' search platlist returns               -
 ##---------------------------------------------------------------

offset<- c(0, 50, 100, 150, 200, 250, 300)
happy_playlists <- data.frame()

for (i in offset){
  tmp = spotifyr::search_spotify(q = "happy", 
                                       type = "playlist",
                                       limit = 50, 
                                       offset = i)
  tmp = cbind(SearchString = "Happy", tmp)
  happy_playlists = rbind(tmp, happy_playlists)
}


 ##----------------------------------------------------------------
 ##                  'Sad' search playlist return                 -
 ##----------------------------------------------------------------
 
sad_playlists <- data.frame()

for (i in offset){
  tmp = spotifyr::search_spotify(q = "sad", 
                                       type = "playlist",
                                       limit = 50, 
                                       offset = i)
  tmp = cbind(SearchString = "Sad", tmp)
  sad_playlists = rbind(tmp, sad_playlists)
}


 ##----------------------------------------------------------------
 ##                'Angry' search playlist return                 -
 ##----------------------------------------------------------------
 
angry_playlists <- data.frame()

for (i in offset){
  tmp = spotifyr::search_spotify(q = "angry", 
                                       type = "playlist",
                                       limit = 50, 
                                       offset = i)
  tmp = cbind(SearchString = "Angry", tmp)
  angry_playlists = rbind(tmp, angry_playlists)
}


 ##---------------------------------------------------------------
 ##                'Tender' search playlist return               -
 ##---------------------------------------------------------------
 
tender_playlists <- data.frame()

for (i in offset){
  tmp = spotifyr::search_spotify(q = "tender", 
                                       type = "playlist",
                                       limit = 50, 
                                       offset = i)
  tmp = cbind(SearchString = "Tender", tmp)
  tender_playlists = rbind(tmp, tender_playlists)
}


 ##----------------------------------------------------------------
 ##                    Emotion playlists binded                   -
 ##----------------------------------------------------------------

emotion_playlists <- rbind(happy_playlists, sad_playlists, angry_playlists, tender_playlists) %>% 
  select(SearchString, 
         description, 
         name,
         id,
         owner.display_name, 
         owner.uri, 
         tracks.total) 

##---------------------------------------------------------------
##                    Spotify Playlist Tracks                   -
##---------------------------------------------------------------

select_playlists <-emotion_playlists %>% 
  select(id,
         description, 
         name, 
         SearchString, 
         tracks.total
  ) %>% 
  mutate(
    language = cld2::detect_language(
      text = description, lang_code = FALSE
      )
    ) %>% 
  filter(
    language == "ENGLISH"
    ) %>% 
  mutate(
    emoWord = stringr::str_detect(
      string = name,
    pattern = "angry|sad|happy|tender"
    )
  ) %>% 
  filter(
    emoWord == TRUE
    )

table(select_playlists$SearchString)

count_songs <- select_playlists %>% 
  group_by(SearchString) %>% 
  summarise(sum = sum(tracks.total))



