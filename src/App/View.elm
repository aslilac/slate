module App.View exposing (..)

import App.Model exposing (..)
import App.Update exposing (..)
import Friend exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Message
view model =
    case model.answer of
        Just answer ->
            viewGame
                { answer = answer
                , guesses = model.guesses
                , pendingGuess = model.pendingGuess
                }

        Nothing ->
            div [] [ text "Something went terribly wrong D:" ]


viewGame : StrictModel -> Html Message
viewGame model =
    let
        _ =
            Debug.log "The answer is" model.answer
    in
    div [ class "prose p-5 m-auto" ]
        [ div [ class "flex flex-col grow items-center justify-center" ]
            (List.concat
                [ [ h1 [ class "font-hello text-center" ] [ text "Wordle" ]
                  ]
                , List.map viewGuess (List.reverse model.guesses)
                , [ input [ class "border-2 focus:border-green-200 rounded", focus, onInput UpdateGuess, value model.pendingGuess ] []
                  , button [ onClick SubmitGuess ] [ text "Guess" ]
                  , p [ class "color-red" ] [ text model.pendingGuess ]
                  ]
                ]
            )
        ]


focus : Attribute msg
focus =
    attribute "focus" "true"


viewGuess : String -> Html Message
viewGuess guessText =
    let
        chars =
            String.toList guessText
    in
    div [ class "flex flex-row gap-2 text-5xl" ] (List.map (\char -> viewGuessChar char) chars)


viewGuessChar : Char -> Html Message
viewGuessChar char =
    div [ class "bg-gray-100 rounded aspect-square p-3" ] [ text (String.fromChar char) ]
