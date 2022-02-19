module App.View exposing (..)

import App.Model exposing (..)
import App.Update exposing (..)
import Friend exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Action
view model =
    div [ class "prose p-5 m-auto" ]
        [ div [ class "flex flex-col grow items-center justify-center" ]
            (List.concat
                [ [ h1 [ class "font-hello text-center" ] [ text "Wordle" ]
                  ]
                , List.map viewGuess (List.reverse model.guesses)
                , [ input [ attribute "focus" "true", onInput UpdateGuess, value model.pendingGuess ] []
                  , button [ onClick SubmitGuess ] [ text "Guess" ]
                  , p [ class "color-red" ] [ text model.pendingGuess ]
                  ]
                ]
            )
        ]


viewGuess : String -> Html Action
viewGuess guessText =
    div [] [ text guessText ]
