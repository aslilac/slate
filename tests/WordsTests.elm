module WordsTests exposing (allAnswersAreValid)

import Data.Words as Words
import Expect
import Test exposing (..)


allAnswersAreValid : Test
allAnswersAreValid =
    test "all answers are valid" <|
        \_ ->
            Words.answers
                |> List.foldl addMissing []
                |> Expect.equal []


addMissing it missing =
    if not <| List.member it Words.valid then
        it :: missing

    else
        missing
