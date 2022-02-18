module App.View exposing (..)

import App.Model exposing (..)
import App.Update exposing (..)
import Friend exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Action
view count =
    div [ class "prose p-5 m-auto" ]
        [ div [ class "flex flex-col grow items-center justify-center" ]
            [ h1 [ class "font-hello text-center" ] [ text "Wordle" ]
            , hello
            , helloToFriend "Hayleigh"
            , button [ onClick Increment ] [ text "+" ]
            , p [ class "color-red" ] [ text (String.fromInt count) ]
            ]
        ]
