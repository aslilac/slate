module App.Hints exposing (..)

import Array
import Dict exposing (Dict)


type alias Hints =
    Dict Char HintLevel


type alias Hint =
    ( Char, HintLevel )


type HintLevel
    = Unknown -- The letter has not yet been guessed
    | Missing -- The letter is not in the word
    | Present -- The letter is in the word, but an exact location is not yet known
    | Found -- The letter is in the word and an exact location is known


findHints : String -> List String -> Hints
findHints answer guesses =
    List.foldl (checkGuess answer) initHints guesses


checkGuess : String -> String -> Hints -> Hints
checkGuess answer guess hints =
    let
        chars =
            String.toList guess
    in
    List.foldl
        (\( i, char ) ->
            \nextHints ->
                let
                    charInAnswer =
                        String.contains (String.fromChar char) answer

                    isExact =
                        Array.get i (Array.fromList (String.toList answer)) == Just char

                    localHint =
                        case ( charInAnswer, isExact ) of
                            ( True, True ) ->
                                Found

                            ( True, False ) ->
                                Present

                            ( False, _ ) ->
                                Missing

                    -- If the hint for this letter is already `Found`, don't demote it
                    hint =
                        if Dict.get char nextHints == Just Found then
                            Found

                        else
                            localHint
                in
                Dict.insert char hint nextHints
        )
        hints
        (List.indexedMap Tuple.pair chars)


initHints : Hints
initHints =
    Dict.fromList
        [ ( 'A', Unknown )
        , ( 'B', Unknown )
        , ( 'C', Unknown )
        , ( 'D', Unknown )
        , ( 'E', Unknown )
        , ( 'F', Unknown )
        , ( 'G', Unknown )
        , ( 'H', Unknown )
        , ( 'I', Unknown )
        , ( 'J', Unknown )
        , ( 'K', Unknown )
        , ( 'L', Unknown )
        , ( 'M', Unknown )
        , ( 'N', Unknown )
        , ( 'O', Unknown )
        , ( 'P', Unknown )
        , ( 'Q', Unknown )
        , ( 'R', Unknown )
        , ( 'S', Unknown )
        , ( 'T', Unknown )
        , ( 'U', Unknown )
        , ( 'V', Unknown )
        , ( 'W', Unknown )
        , ( 'X', Unknown )
        , ( 'Y', Unknown )
        , ( 'Z', Unknown )
        ]


colorByHintLevel : HintLevel -> String
colorByHintLevel match =
    case match of
        Unknown ->
            "bg-gray-100 text-gray-600"

        Missing ->
            "bg-gray-50 text-gray-300"

        Present ->
            "bg-amber-100 text-amber-500"

        Found ->
            "bg-emerald-100 text-emerald-500"
