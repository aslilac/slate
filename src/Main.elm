module Main exposing (..)

import Friend exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


main: Html msg
main =
    div [ class "prose p-5 m-auto" ]
        [ div [ class "flex flex-col grow items-center justify-center" ]
            [ h1 [ class "font-hello text-center" ] [ text "Wordle" ]
            , hello
            , helloToFriend "Hayleigh"
            ]
        ]
