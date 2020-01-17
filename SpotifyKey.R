
##----------------------------------------------------------------
##                          SpotifyKey                           -
##----------------------------------------------------------------
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '71df4006c91441bc8755ad3b5b9bd0d2')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'b813f0c4195a4dbea22c38d5c42b975c')

access_token <- get_spotify_access_token()

