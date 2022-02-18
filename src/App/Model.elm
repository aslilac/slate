module App.Model exposing (..)


defaultFriendName : String
defaultFriendName =
    "Hayleigh"


otherFriendNames : List String
otherFriendNames =
    [ "August", "Dot", "Toby" ]


type alias Model =
    { guesses : List String
    , pendingGuess : String
    , count : Int
    , friendName : String
    }


init : Model
init =
    { guesses = []
    , pendingGuess = ""
    , count = 0
    , friendName = defaultFriendName
    }
