module MatchedWordTests exposing (..)

import App.MatchedWord exposing (Matched(..), matchGuess)
import Expect
import Test exposing (..)


correctAnswer : Test
correctAnswer =
    test "correct answer" <|
        \_ ->
            matchGuess "slate" "slate"
                |> List.map .match
                |> Expect.equal [ Green, Green, Green, Green, Green ]


veryCloseAnswer : Test
veryCloseAnswer =
    test "very close answer" <|
        \_ ->
            matchGuess "slate" "elate"
                |> List.map .match
                |> Expect.equal [ No, Green, Green, Green, Green ]


nearDuplicateAfterExact : Test
nearDuplicateAfterExact =
    test "near duplicate after exact" <|
        \_ ->
            matchGuess "offer" "--ff-"
                |> List.map .match
                |> Expect.equal [ No, No, Green, Yellow, No ]


noDuplicateInAnswer : Test
noDuplicateInAnswer =
    test "no duplicate in answer" <|
        \_ ->
            matchGuess "final" "offer"
                |> List.map .match
                |> Expect.equal [ No, Yellow, No, No, No ]
