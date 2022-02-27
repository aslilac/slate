module App.View exposing (..)

import App.CheckedWord exposing (..)
import App.HtmlUtil exposing (focus)
import App.Model exposing (..)
import App.Update exposing (..)
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
        viewGuessBaked =
            viewGuess model.answer
    in
    div [ class "prose p-5 m-auto" ]
        [ div [ class "flex flex-col grow items-center justify-center gap-2" ]
            (List.concat
                [ [ h1 [ class "font-hello text-center" ] [ text "Slate" ]
                  ]

                -- The grid of guessed words
                , List.map viewGuessBaked (List.reverse model.guesses)

                -- The current guess
                , [ input
                        [ class "rounded border-2 px-4 py-2 focus:border-green-200 "
                        , focus
                        , onInput UpdateGuess
                        , value model.pendingGuess
                        ]
                        []
                  , button [ class "rounded border-2 px-4 py-2 disabled:text-gray-400 text-green-500", onClick SubmitGuess, disabled (String.length model.pendingGuess < 5) ] [ text "Guess" ]
                  ]
                ]
            )
        ]


viewGuess : String -> String -> Html Message
viewGuess answer guess =
    div [ class "flex flex-row gap-2 text-5xl" ]
        (List.map (\( match, char ) -> viewGuessChar match char) (checkWord answer guess))


viewGuessChar : MatchLevel -> Char -> Html Message
viewGuessChar match char =
    div [ class (String.join " " [ colorByMatchLevel match, "rounded w-16 p-3 text-center" ]) ]
        [ text (String.fromChar char) ]
