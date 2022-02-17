module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Friend exposing (..)


type alias Model =
    Int


type Action
    = Increment


main : Program () Model Action
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


init : Model
init =
    0


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


update : Action -> Model -> Model
update action model =
    case action of
        Increment ->
            model + 1
