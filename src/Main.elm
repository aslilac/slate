module Main exposing (main)

import App.CheckedWord exposing (CheckedChar, checkWord, colorByMatchLevel)
import App.Words exposing (words)
import Array
import Browser
import Html exposing (..)
import Html.Attributes exposing (autofocus, class, disabled, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Random



------------------------------------------------------------------------------------------
-- Init ----------------------------------------------------------------------------------


type alias Model =
    { answer : Maybe String
    , guesses : List String
    , pendingGuess : String
    }


type alias StrictModel =
    { answer : String
    , guesses : List String
    , pendingGuess : String
    }


type alias Flags =
    { dayOfGame : Int
    }


init : Flags -> ( Model, Cmd message )
init flags =
    let
        range =
            Random.int 0 (Array.length words)

        seed =
            Random.initialSeed flags.dayOfGame

        ( index, _ ) =
            Random.step range seed

        answer =
            Array.get index words
                |> Maybe.map String.toUpper

        model =
            { answer = answer
            , guesses = []
            , pendingGuess = ""
            }
    in
    ( model
    , Cmd.none
    )



------------------------------------------------------------------------------------------
-- Update --------------------------------------------------------------------------------


type Message
    = UpdateGuess String
    | SubmitGuess


update : Message -> Model -> ( Model, Cmd message )
update action model =
    case action of
        UpdateGuess guess ->
            ( { model | pendingGuess = sanitizeGuess guess }
            , Cmd.none
            )

        SubmitGuess ->
            ( { model | guesses = model.pendingGuess :: model.guesses, pendingGuess = "" }
            , Cmd.none
            )


sanitizeGuess : String -> String
sanitizeGuess guess =
    let
        filtered =
            String.filter Char.isAlpha guess

        trimmed =
            String.slice 0 5 filtered

        formatted =
            String.toUpper trimmed
    in
    formatted



------------------------------------------------------------------------------------------
-- View ----------------------------------------------------------------------------------


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
    div [ class "prose p-5 m-auto" ]
        [ div [ class "flex flex-col grow items-center justify-center gap-4" ]
            -- App header
            [ viewHeader

            -- The grid of guessed words
            , viewHistory model

            -- The current guess
            , viewGuessInput model
            ]
        ]


viewHeader : Html msg
viewHeader =
    h1 [ class "font-hello text-center" ] [ text "Slate" ]


viewHistory : StrictModel -> Html msg
viewHistory model =
    div [ class "flex flex-col items-center justify-center gap-2" ]
        (List.map (viewGuess model.answer) (List.reverse model.guesses))


viewGuess : String -> String -> Html msg
viewGuess answer guess =
    div [ class "flex flex-row gap-2 text-5xl" ]
        (List.map viewGuessChar (checkWord answer guess))


viewGuessChar : CheckedChar -> Html msg
viewGuessChar ( match, char ) =
    let
        className =
            colorByMatchLevel match ++ " rounded w-16 p-3 text-center"
    in
    div [ class className ]
        [ text (String.fromChar char) ]


viewGuessInput : StrictModel -> Html Message
viewGuessInput model =
    form [ class "flex flex-row gap-2", onSubmit SubmitGuess ]
        [ input
            [ class "rounded border-2 px-4 py-2 focus:border-green-200 "
            , autofocus True
            , onInput UpdateGuess
            , value model.pendingGuess
            ]
            []
        , button
            [ class "rounded border-2 px-4 py-2 disabled:text-gray-400 text-green-500"
            , disabled (String.length model.pendingGuess < 5)
            , type_ "submit"
            ]
            [ text "Guess" ]
        ]



---------------------------------------------------------------------------------
-- Program -------------------------------------------------------------------------------


main : Program Flags Model Message
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none -- No subscriptions
        }
