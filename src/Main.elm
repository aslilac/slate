module Main exposing (main)

import App.Hints as Hints exposing (Hint(..), Hints)
import App.MatchedWord exposing (..)
import Browser
import Browser.Events
import Data.Words as Words
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, disabled, src, type_)
import Html.Events exposing (onClick, onMouseDown, preventDefaultOn)
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
    , problem : Maybe Problem
    }


type Status
    = PendingGuess String
    | Lost
    | Won


type Problem
    = Duplicate
    | TooShort
    | UnknownWord


{-| Using the date flag passed to us from JavaScript, we pick the word of the
day randomly from the list in Data.Words.
-}
init : Flags -> ( Model, Cmd message )
init flags =
    let
        range =
            Random.int 0 (List.length Words.answers)

        ( index, _ ) =
            Random.initialSeed flags.dayOfGame |> Random.step range

        answer =
            Words.answers
                |> List.drop index
                |> List.head
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
    , problem = Nothing
    }



--------------------------------------------------------------------------------
---- Update --------------------------------------------------------------------


type Message
    = Ignore
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
        ( AppendGuess it, PendingGuess guess ) ->
            if String.length guess >= 5 then
                game

            else
                { game
                    | status = PendingGuess <| sanitizeGuess (guess ++ String.fromChar it)
                    , problem = Nothing
                }

        ( BackspaceGuess, PendingGuess guess ) ->
            { game
                | status = PendingGuess <| String.slice 0 (String.length guess - 1) guess
                , problem = Nothing
            }

        ( SubmitGuess, PendingGuess guess ) ->
            if String.length guess /= 5 then
                { game | problem = Just TooShort }

            else if List.member guess game.guesses then
                { game | status = PendingGuess "", problem = Just Duplicate }

            else if not <| List.member guess Words.valid then
                { game | problem = Just UnknownWord }

            else
                let
                    guesses =
                        guess :: game.guesses

                    status =
                        if guess == game.answer then
                            Won

                        else if List.length guesses >= 6 then
                            Lost

                        else
                            PendingGuess ""
                in
                { game | guesses = guesses, status = status, problem = Nothing }

        _ ->
            game


sanitizeGuess : String -> String
sanitizeGuess guess =
    guess
        |> String.filter Char.isAlpha
        |> String.slice 0 5
        |> String.toLower



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
    h1 [ class "text-2xl font-title text-center border-b border-gray-200 shadow-xs p-2" ]
        [ text "Slate" ]


viewGame : Game -> Html Message
viewGame game =
    let
        matchedGuesses =
            game.guesses |> List.reverse |> List.map (matchGuess game.answer)
    in
    div [ class "flex flex-col gap-4 items-center justify-between" ]
        -- The grid of guessed words
        [ viewGuessGrid game matchedGuesses

        -- Explanation of why a guess was rejected
        , game.problem
            |> Maybe.map viewProblem
            |> Maybe.withDefault (text "")

        -- The current guess
        , viewControls game <| Hints.fromMatchedGuesses matchedGuesses
        ]


viewGuessGrid : Game -> List MatchedWord -> Html msg
viewGuessGrid game guesses =
    let
        remainingGuesses =
            case game.status of
                PendingGuess _ ->
                    5 - List.length guesses

                _ ->
                    0
    in
    div [ class "flex flex-col items-center justify-center gap-2 text-4xl" ] <|
        List.concat
            -- Previous guesses
            [ List.map viewPreviousGuess guesses

            -- The guess currently being input
            , [ viewGuess game ]

            -- Placeholders for the number of guesses remaining
            , viewPlaceholders remainingGuesses
            ]


viewPreviousGuess : MatchedWord -> Html msg
viewPreviousGuess guess =
    div [ class "flex flex-row gap-2" ] <|
        List.map viewPreviousGuessLetter guess


viewPreviousGuessLetter : MatchedLetter -> Html msg
viewPreviousGuessLetter { match, letter } =
    let
        color =
            case match of
                No ->
                    "bg-gray-100"

                Yellow ->
                    "bg-amber-200"

                Green ->
                    "bg-emerald-300"

        className =
            color ++ " inline-block rounded-sm w-14 p-3 text-center uppercase"
    in
    span [ class className ]
        [ text (String.fromChar letter) ]


viewGuess : Game -> Html msg
viewGuess game =
    case game.status of
        PendingGuess guess ->
            div [ class "flex flex-row gap-2" ] <|
                List.concat
                    [ List.map viewGuessLetter (String.toList guess)
                    , List.repeat (5 - String.length guess) viewPlaceholderLetter
                    ]

        _ ->
            text ""


viewGuessLetter : Char -> Html msg
viewGuessLetter letter =
    -- The -my-px subtracts a little bit of margin to account for the height
    -- that the border adds.
    span [ class "border -my-px text-gray-600 inline-block rounded-sm w-14 p-3 text-center uppercase" ]
        [ text (String.fromChar letter) ]


viewPlaceholders : Int -> List (Html msg)
viewPlaceholders i =
    List.repeat i <|
        div [ class "flex flex-row gap-2" ] <|
            List.repeat 5 viewPlaceholderLetter


viewPlaceholderLetter : Html msg
viewPlaceholderLetter =
    -- The -my-px subtracts a little bit of margin to account for the height
    -- that the border adds.
    span [ class "border -my-px inline-block rounded-sm w-14 p-3 text-center text-transparent select-none" ]
        [ text "•" ]


viewProblem problem =
    let
        description =
            case problem of
                Duplicate ->
                    "You already guessed that"

                TooShort ->
                    "Guesses must be five letters"

                UnknownWord ->
                    "I don't recognize that word"
    in
    div []
        [ text description
        ]


viewControls : Game -> Hints -> Html Message
viewControls game hints =
    case game.status of
        Won ->
            viewStatus <| text "You won! 🥳"

        Lost ->
            viewStatus <| text game.answer

        PendingGuess guess ->
            viewKeyboard <| hints


viewStatus : Html msg -> Html msg
viewStatus status =
    div [ class "text-xl" ] [ status ]


viewKeyboard : Hints -> Html Message
viewKeyboard hints =
    div [ class "keyboard flex flex-col gap-1 items-center" ]
        [ div [ class "flex gap-1" ] <|
            List.map
                (viewKeyboardButton hints)
                [ 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p' ]
        , div [ class "flex gap-1" ] <|
            List.map
                (viewKeyboardButton hints)
                [ 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l' ]
        , div [ class "flex gap-1" ] <|
            List.concat
                [ List.map
                    (viewKeyboardButton hints)
                    [ 'z', 'x', 'c', 'v', 'b', 'n', 'm' ]
                , [ viewKeyboardBackspaceButton ]
                ]
        , div [ class "pt-3" ]
            [ button
                [ class "rounded-sm border px-4 py-2 disabled:text-gray-300 text-gray-800 uppercase tracking-widest text-center w-96"
                , type_ "button"
                , onClick SubmitGuess
                ]
                [ text "Guess" ]
            ]
        ]


viewKeyboardButton : Hints -> Char -> Html Message
viewKeyboardButton hints letter =
    let
        hint =
            Hints.get letter hints

        color =
            case hint of
                Unknown ->
                    "bg-gray-100 text-gray-600"

                Missing ->
                    "bg-gray-50 text-gray-300"

                Present ->
                    "bg-amber-100 text-amber-500"

                Found ->
                    "bg-emerald-100 text-emerald-500"
    in
    button
        [ class <| color ++ " rounded-sm bg-gray-100 px-2 py-3 w-8 text-center uppercase"
        , onMouseDown <| AppendGuess letter
        , preventDefaultOn "touchstart" <| Decode.succeed ( AppendGuess letter, True )
        ]
        [ text <| String.fromChar letter ]


viewKeyboardBackspaceButton : Html Message
viewKeyboardBackspaceButton =
    button
        [ class "flex rounded-sm items-center justify-center bg-gray-100 p-2 w-12"
        , onMouseDown BackspaceGuess
        , preventDefaultOn "touchstart" <| Decode.succeed ( BackspaceGuess, True )
        ]
        [ img [ class "w-5 h-5", src "delete.svg" ] [] ]



--------------------------------------------------------------------------------
---- Subscriptions -------------------------------------------------------------


subscriptions : a -> Sub Message
subscriptions _ =
    Browser.Events.onKeyDown decodeKeyDown


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
        Letter letter ->
            AppendGuess letter

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
                ( Just ( letter, "" ), True ) ->
                    Letter letter

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
