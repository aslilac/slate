module App.Model exposing (..)


type alias Model =
    { guesses : List String
    , pendingGuess : String
    }


init : Model
init =
    { guesses = []
    , pendingGuess = ""
    }
