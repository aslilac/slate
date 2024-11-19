module Main exposing (main)

import App.CheckedWord exposing (CheckedChar, checkWord, colorByMatchLevel)
import App.Hints exposing (Hint, HintLevel(..), Hints, colorByHintLevel, findHints)
import Array
import Browser
import Browser.Events exposing (onKeyDown)
import Data.Words exposing (words)
import Dict
import Html exposing (..)
import Html.Attributes exposing (autofocus, class, disabled, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Decode as Decode
import Random



--------------------------------------------------------------------------------
---- Init ----------------------------------------------------------------------


type alias Flags =
    { dayOfGame : Int
    }


{-| Nothing is used as an error state
-}
type alias Model =
    Maybe Game


{-| Our actual state type
-}
type alias Game =
    { answer : String
    , guesses : List String
    , status : Status
    }


type Status
    = PendingGuess String
    | Lost
    | Won


canSubmitGuess : Game -> Bool
canSubmitGuess game =
    case game.status of
        PendingGuess guess ->
            String.length guess == 5

        _ ->
            False


{-| Using the date flag passed to us from JavaScript, we pick the word of the
day randomly from the list in Data.Words.
-}
init : Flags -> ( Model, Cmd message )
init flags =
    let
        range =
            Random.int 0 (Array.length words)

        ( index, _ ) =
            Random.initialSeed flags.dayOfGame |> Random.step range

        answer =
            Array.get index words
                |> Maybe.map String.toUpper
    in
    ( Maybe.map initGame answer
    , Cmd.none
    )


{-| Given an answer, creates the initial game state.
-}
initGame : String -> Game
initGame answer =
    { answer = answer
    , guesses = []
    , status = PendingGuess ""
    }



--------------------------------------------------------------------------------
---- Update --------------------------------------------------------------------


type Message
    = Ignore
    | ReplaceGuess String
    | AppendGuess Char
    | BackspaceGuess
    | SubmitGuess


update : Message -> Model -> ( Model, Cmd message )
update action model =
    ( Maybe.map (updateGame action) model
    , Cmd.none
    )


updateGame : Message -> Game -> Game
updateGame action game =
    case ( action, game.status ) of
        ( ReplaceGuess guess, _ ) ->
            { game | status = PendingGuess <| sanitizeGuess guess }

        ( AppendGuess it, PendingGuess guess ) ->
            { game | status = PendingGuess <| sanitizeGuess (guess ++ String.fromChar it) }

        ( BackspaceGuess, PendingGuess guess ) ->
            { game | status = PendingGuess <| String.slice 0 (String.length guess - 1) guess }

        ( SubmitGuess, PendingGuess guess ) ->
            let
                guesses =
                    if List.member guess game.guesses then
                        game.guesses

                    else
                        guess :: game.guesses

                nextState =
                    if guess == game.answer then
                        Won

                    else if List.length guesses >= 6 then
                        Lost

                    else
                        PendingGuess ""
            in
            case canSubmitGuess game of
                True ->
                    { game | guesses = guesses, status = nextState }

                False ->
                    game

        _ ->
            game


sanitizeGuess : String -> String
sanitizeGuess guess =
    String.filter Char.isAlpha guess |> String.slice 0 5 |> String.toUpper



--------------------------------------------------------------------------------
---- View ----------------------------------------------------------------------


view : Model -> Html Message
view model =
    div [ class "min-h-dvh flex flex-col" ]
        [ viewHeader
        , div [ class "min-h-full flex flex-col items-center justify-center p-4 pb-8 m-auto" ]
            [ case model of
                Just status ->
                    viewGame status

                Nothing ->
                    div []
                        [ h1 [] [ text "Something went terribly wrong D:" ]
                        , p [] [ text "This is definitely a bug. Sorry about that!" ]
                        ]
            ]
        ]


viewHeader : Html msg
viewHeader =
    h1 [ class "text-2xl font-title text-center border-b border-gray-200 shadow-sm p-2" ]
        [ text "Slate" ]


viewGame : Game -> Html Message
viewGame game =
    div [ class "flex flex-col gap-4 items-center justify-between" ]
        -- The grid of guessed words
        [ viewGuessGrid game

        -- The current guess
        , viewControls game
        ]


viewGuessGrid : Game -> Html msg
viewGuessGrid game =
    let
        remainingGuesses =
            case game.status of
                PendingGuess _ ->
                    5 - List.length game.guesses

                _ ->
                    0
    in
    div [ class "flex flex-col items-center justify-center gap-2 text-4xl" ] <|
        List.concat
            [ List.map (viewPreviousGuess game.answer) (List.reverse game.guesses)
            , [ viewCurrentGuess game ]
            , viewPlaceholders <| remainingGuesses
            ]


viewPreviousGuess : String -> String -> Html msg
viewPreviousGuess answer guess =
    div [ class "flex flex-row gap-2" ] <|
        List.map viewGuessChar (checkWord answer guess)


viewCurrentGuess : Game -> Html msg
viewCurrentGuess game =
    case game.status of
        PendingGuess guess ->
            div [ class "flex flex-row gap-2" ] <|
                List.concat
                    [ List.map viewGuessChar2 (String.toList guess)
                    , List.repeat (5 - String.length guess) viewPlaceholderChar
                    ]

        _ ->
            text ""


viewPlaceholders : Int -> List (Html msg)
viewPlaceholders i =
    List.repeat i <|
        div [ class "flex flex-row gap-2" ] <|
            List.repeat 5 viewPlaceholderChar


viewPlaceholderChar : Html msg
viewPlaceholderChar =
    -- The -my-px subtracts a little bit of margin to account for the height
    -- that the border adds.
    span [ class "border -my-px inline-block rounded w-14 p-3 text-center text-transparent select-none" ]
        [ text "•" ]


viewGuessChar2 : Char -> Html msg
viewGuessChar2 char =
    -- The -my-px subtracts a little bit of margin to account for the height
    -- that the border adds.
    span [ class "border -my-px text-gray-600 inline-block rounded w-14 p-3 text-center" ]
        [ text (String.fromChar char) ]


viewGuessChar : CheckedChar -> Html msg
viewGuessChar ( match, char ) =
    let
        className =
            colorByMatchLevel match ++ " inline-block rounded w-14 p-3 text-center"
    in
    span [ class className ]
        [ text (String.fromChar char) ]


viewControls : Game -> Html Message
viewControls game =
    case game.status of
        PendingGuess guess ->
            viewKeyboard game

        Lost ->
            viewStatus <| text game.answer

        Won ->
            viewStatus <| text "You won! 🥳"


viewStatus : Html msg -> Html msg
viewStatus status =
    div [ class "text-xl" ] [ status ]


viewHints : Game -> Html msg
viewHints game =
    let
        hints =
            Dict.toList <| findHints game.answer game.guesses

        -- We only need to show hints if the game is in progress
        hintsContent =
            case game.status of
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
        color =
            colorByHintLevel hint
    in
    span [ class <| color ++ " w-3 text-center" ]
        [ text (String.fromChar char) ]


viewKeyboard : Game -> Html Message
viewKeyboard game =
    let
        hints =
            findHints game.answer game.guesses
    in
    div [ class "keyboard flex flex-col gap-1 items-center" ]
        [ div [ class "flex gap-1" ] <|
            List.map
                (viewKeyboardButton hints)
                [ 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P' ]
        , div [ class "flex gap-1" ] <|
            List.map
                (viewKeyboardButton hints)
                [ 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L' ]
        , div [ class "flex gap-1" ] <|
            List.concat
                [ List.map
                    (viewKeyboardButton hints)
                    [ 'Z', 'X', 'C', 'V', 'B', 'N', 'M' ]
                , [ viewKeyboardBackspaceButton ]
                ]
        , div [ class "pt-3" ]
            [ button
                [ class "rounded border px-4 py-2 disabled:text-gray-300 text-gray-800 uppercase tracking-widest text-center w-96"
                , disabled <| not <| canSubmitGuess game
                , type_ "buttom"
                , onClick SubmitGuess
                ]
                [ text "Guess" ]
            ]
        ]


viewKeyboardButton : Hints -> Char -> Html Message
viewKeyboardButton hints char =
    let
        hint =
            Dict.get char hints
                |> Maybe.withDefault Unknown

        color =
            colorByHintLevel hint
    in
    button
        [ class <| color ++ " rounded bg-gray-100 px-2 py-3 w-8 text-center"
        , onClick <| AppendGuess char
        ]
        [ text <| String.fromChar char ]


viewKeyboardBackspaceButton : Html Message
viewKeyboardBackspaceButton =
    button
        [ class "flex rounded items-center justify-center bg-gray-100 p-2 w-12"
        , onClick BackspaceGuess
        ]
        [ img [ class "w-5 h-5", src "delete.svg" ] [] ]



--------------------------------------------------------------------------------
---- Subscriptions -------------------------------------------------------------


subscriptions : a -> Sub Message
subscriptions _ =
    onKeyDown decodeKeyDown


decodeKeyDown : Decode.Decoder Message
decodeKeyDown =
    Decode.field "key" Decode.string
        |> Decode.map (decodeKey >> keyToMessage)


{-| Intermediate type that represents pretty directly to a Message, but having
that slight indirection
-}
type Key
    = Letter Char
    | Backspace
    | Enter
    | Other


{-| keyToMessage takes our intermediate type and does the actual mapping
-}
keyToMessage : Key -> Message
keyToMessage key =
    case key of
        Letter char ->
            AppendGuess char

        Backspace ->
            BackspaceGuess

        Enter ->
            SubmitGuess

        Other ->
            Ignore


{-| Maps key events into our more semantic Key type
-}
decodeKey : String -> Key
decodeKey key =
    case key of
        "Backspace" ->
            Backspace

        "Enter" ->
            Enter

        _ ->
            let
                uncons =
                    String.uncons key

                isLetter =
                    uncons
                        |> Maybe.map (Tuple.first >> Char.isAlpha)
                        |> Maybe.withDefault False
            in
            case ( uncons, isLetter ) of
                ( Just ( char, "" ), True ) ->
                    Letter char

                _ ->
                    Other



--------------------------------------------------------------------------------
---- Program -------------------------------------------------------------------


main : Program Flags Model Message
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
