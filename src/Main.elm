module Main exposing (main)

import App.CheckedWord exposing (CheckedChar, checkWord, colorByMatchLevel)
import App.Hints exposing (Hint, HintLevel(..), colorByHintLevel, findHints)
import App.Words exposing (words)
import Array
import Browser
import Dict
import Html exposing (..)
import Html.Attributes exposing (autofocus, class, disabled, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Random



------------------------------------------------------------------------------------------
-- Init ----------------------------------------------------------------------------------


type alias Model =
    { answer : Maybe String
    , guesses : List String
    , state : GameState
    }


type alias StrictModel =
    { answer : String
    , guesses : List String
    , state : GameState
    }


type alias Flags =
    { dayOfGame : Int
    }


type GameState
    = PendingGuess String
    | Lost
    | Won


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
            , state = PendingGuess ""
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
    case ( action, model.state ) of
        ( UpdateGuess guess, _ ) ->
            ( { model | state = PendingGuess (sanitizeGuess guess) }
            , Cmd.none
            )

        ( SubmitGuess, PendingGuess guess ) ->
            let
                guesses =
                    if List.member guess model.guesses then
                        model.guesses

                    else
                        guess :: model.guesses

                nextState =
                    if Just guess == model.answer then
                        Won

                    else if List.length guesses >= 6 then
                        Lost

                    else
                        PendingGuess ""
            in
            ( { model | guesses = guesses, state = nextState }
            , Cmd.none
            )

        ( _, _ ) ->
            ( model
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
                , state = model.state
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
            , viewGameState model

            -- Hints
            , viewHints model
            ]
        ]


viewHeader : Html msg
viewHeader =
    h1 [ class "font-slate text-center" ] [ text "Slate" ]


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


viewGameState : StrictModel -> Html Message
viewGameState model =
    case model.state of
        PendingGuess guess ->
            viewGuessInput guess

        Lost ->
            viewStatusText "Oh heck 😭"

        Won ->
            viewStatusText "You won! 🥳"


viewStatusText : String -> Html Message
viewStatusText statusText =
    div [ class "text-xl" ] [ text statusText ]


viewGuessInput : String -> Html Message
viewGuessInput pendingGuess =
    form [ class "flex flex-row gap-2", onSubmit SubmitGuess ]
        [ input
            [ class "rounded border-2 px-4 py-2 focus:border-green-200 "
            , autofocus True
            , onInput UpdateGuess
            , value pendingGuess
            ]
            []
        , button
            [ class "rounded border-2 px-4 py-2 disabled:text-gray-400 text-green-500"
            , disabled (String.length pendingGuess < 5)
            , type_ "submit"
            ]
            [ text "Guess" ]
        ]


viewHints : StrictModel -> Html msg
viewHints model =
    let
        hints =
            Dict.toList <| findHints model.answer model.guesses

        -- We only need to show hints if the game is in progress
        hintsContent =
            case model.state of
                PendingGuess _ ->
                    List.map viewHintChar hints

                _ ->
                    []
    in
    div [ class "flex flex-row flex-wrap justify-center w-80 gap-3" ]
        hintsContent


viewHintChar : Hint -> Html msg
viewHintChar ( char, hint ) =
    let
        className =
            colorByHintLevel hint ++ " w-3 text-center"
    in
    span [ class className ] [ text (String.fromChar char) ]



------------------------------------------------------------------------------------------
-- Program -------------------------------------------------------------------------------


main : Program Flags Model Message
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none -- No subscriptions
        }
