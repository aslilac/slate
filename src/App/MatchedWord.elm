module App.MatchedWord exposing (Matched(..), MatchedLetter, MatchedWord, matchGuess)

{-| This module is responsible for highlighting letters in your guesses as
green and yellow.
-}

import App.LetterCount as LetterCount exposing (LetterCount)
import Array exposing (Array)


type alias MatchedWord =
    List MatchedLetter


type alias MatchedLetter =
    { match : Matched
    , letter : Char
    }


matchGuess answer guess =
    List.map2 Tuple.pair (String.toList answer) (String.toList guess)
        |> List.foldr findExact { answerLetters = LetterCount.fromString answer, state = [] }
        |> (\it -> List.foldl (findNear answer) { it | state = [] } it.state)
        |> finish


{-| The initial fold to find green matches. Any letter that matches exactly gets
marked as green, subtracting one from the amount of available matches for that
letter.

Anything that isn't a green match gets marked as unmatched for now. Yellow
matches will be marked by the second pass.

-}
findExact : ( Char, Char ) -> Matching -> Matching
findExact ( answerLetter, guessLetter ) matching =
    if answerLetter == guessLetter then
        addGreen guessLetter matching

    else
        push { match = No, letter = guessLetter } matching


{-| The secondary fold to find yellow matches, now that all green matches have
been accounted for (since they are the higher priority). If the letter has not
been matched yet (might already be green), and there is still an available
letter to match in the answer, then the letter gets marked as yellow,
subtracting one from the amount of available matches for that letter.
-}
findNear : String -> MatchedLetter -> Matching -> Matching
findNear answer { match, letter } matching =
    if match == No && LetterCount.get letter matching.answerLetters > 0 then
        addYellow letter matching

    else
        push { match = match, letter = letter } matching



--------------------------------------------------------------------------------


type Matched
    = No
    | Yellow
    | Green


type alias Matching =
    { answerLetters : LetterCount
    , state : MatchedWord
    }


addGreen : Char -> Matching -> Matching
addGreen letter { answerLetters, state } =
    { answerLetters = LetterCount.sub letter answerLetters
    , state = { match = Green, letter = letter } :: state
    }


addYellow : Char -> Matching -> Matching
addYellow letter { answerLetters, state } =
    { answerLetters = LetterCount.sub letter answerLetters
    , state = { match = Yellow, letter = letter } :: state
    }


push : MatchedLetter -> Matching -> Matching
push letter { answerLetters, state } =
    { answerLetters = answerLetters
    , state = letter :: state
    }


finish : Matching -> MatchedWord
finish matching =
    matching
        |> .state
        |> List.reverse
