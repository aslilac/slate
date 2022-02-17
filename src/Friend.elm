module Friend exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


hello : Html msg
hello =
    p [] [ text "Howdy!" ]


helloToFriend : String -> Html msg
helloToFriend name =
    p []
        [ text "Howdy "
        , text name
        , text "!"
        ]
