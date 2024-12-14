module App.Hints exposing (Hint(..), Hints, fromMatchedGuesses, get)

{-| This module is responsible for consolidating matched guesses into the
keyboard hints.
-}

import App.LetterCount as LetterCount
import App.MatchedWord exposing (Matched(..), MatchedWord)
import Array
import Dict exposing (Dict)


type alias Hints =
    Dict Char Hint


empty : Hints
empty =
    Dict.empty


fromMatchedGuesses : List MatchedWord -> Hints
fromMatchedGuesses guesses =
    guesses
        |> List.concat
        |> List.foldl addMatchedLetter empty


addMatchedLetter { match, letter } hints =
    let
        hint =
            case match of
                No ->
                    Missing

                Yellow ->
                    Present

                Green ->
                    Found

        highestHint =
            highest hint (get letter hints)
    in
    Dict.insert letter highestHint hints


get : Char -> Hints -> Hint
get letter hints =
    Dict.get letter hints
        |> Maybe.withDefault Unknown



--------------------------------------------------------------------------------


type Hint
    = Unknown -- The letter has not yet been guessed
    | Missing -- The letter is not in the word
    | Present -- The letter is in the word, but the exact location is not known
    | Found -- The letter is in the word and an exact location is known


highest : Hint -> Hint -> Hint
highest a b =
    if a == Found || b == Found then
        Found

    else if a == Present || b == Present then
        Present

    else if a == Missing || b == Missing then
        Missing

    else
        Unknown
