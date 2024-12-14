module App.LetterCount exposing (LetterCount, add, empty, fromString, get, sub)

import Dict exposing (Dict)


type alias LetterCount =
    Dict Char Int


empty : LetterCount
empty =
    Dict.empty


fromString : String -> LetterCount
fromString word =
    String.toList word
        |> List.foldl add empty


get : Char -> LetterCount -> Int
get letter letterCount =
    Dict.get letter letterCount
        |> Maybe.withDefault 0


add : Char -> LetterCount -> LetterCount
add letter letterCount =
    mutate (\it -> it + 1) letter letterCount


sub : Char -> LetterCount -> LetterCount
sub letter letterCount =
    mutate (\it -> it - 1) letter letterCount


mutate : (Int -> Int) -> Char -> LetterCount -> LetterCount
mutate mutation letter letterCount =
    get letter letterCount
        |> mutation
        |> (\count -> Dict.insert letter count letterCount)
