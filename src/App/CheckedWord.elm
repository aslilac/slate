module App.CheckedWord exposing (CheckedChar, CheckedWord, MatchLevel(..), checkWord, colorByMatchLevel)

import App.CharCount exposing (CharCount, addChar, countChars, initCharCount, numOfChar)
import Array exposing (Array)


type alias CheckedWord =
    List CheckedChar


type alias CheckedChar =
    ( MatchLevel, Char )


type MatchLevel
    = Exact
    | Near
    | None


checkWord : String -> String -> CheckedWord
checkWord answer guess =
    let
        answerChars =
            String.toList answer

        answerCharsArray =
            Array.fromList answerChars

        answerCharCount =
            countChars answerChars

        guessChars =
            String.toList guess

        -- Check for exact letter matches
        ( guessExactCharCount, exactCheckedWord ) =
            chompExact answerCharsArray initCharCount guessChars

        -- We want to foldl, because intuitively we would expect the guess to be checked
        -- from left to right as the player. But this does result in our checked word
        -- being in reverse order, because `::` attaches to the front.
        nearCheckedWord =
            chompNear answerCharCount guessExactCharCount guessChars
    in
    mergeExactAndNear ( exactCheckedWord, nearCheckedWord )


chompExact : Array Char -> CharCount -> List Char -> ( CharCount, CheckedWord )
chompExact answerCharsArray guessCharCount guessChars =
    let
        exactCheckedWord =
            List.indexedMap
                (\i ->
                    \char ->
                        ( if Array.get i answerCharsArray == Just char then
                            Exact

                          else
                            None
                        , char
                        )
                )
                guessChars

        nextCharCount =
            List.foldl
                (\( matchLevel, char ) ->
                    \charCount ->
                        if matchLevel == Exact then
                            addChar char charCount

                        else
                            charCount
                )
                guessCharCount
                exactCheckedWord
    in
    ( nextCharCount, exactCheckedWord )


chompNear : CharCount -> CharCount -> List Char -> CheckedWord
chompNear answerCharCount guessCharCount guessChars =
    let
        ( _, backwardsCheckedWord ) =
            List.foldl (chomp answerCharCount) ( guessCharCount, [] ) guessChars

        checkedWord =
            List.reverse backwardsCheckedWord
    in
    checkedWord


chomp : CharCount -> Char -> ( CharCount, CheckedWord ) -> ( CharCount, CheckedWord )
chomp answerCharCount char ( guessCharCount, acc ) =
    let
        matchLevel =
            if numOfChar char answerCharCount > numOfChar char guessCharCount then
                Near

            else
                None

        nextCharCount =
            addChar char guessCharCount
    in
    ( nextCharCount, ( matchLevel, char ) :: acc )


mergeExactAndNear : ( CheckedWord, CheckedWord ) -> CheckedWord
mergeExactAndNear ( exact, near ) =
    let
        exactArray =
            Array.fromList exact

        merged =
            List.indexedMap
                (\i ->
                    \( matchLevel, char ) ->
                        if Array.get i exactArray == Just ( Exact, char ) then
                            ( Exact, char )

                        else
                            ( matchLevel, char )
                )
                near
    in
    merged


colorByMatchLevel : MatchLevel -> String
colorByMatchLevel match =
    case match of
        Exact ->
            "bg-emerald-300"

        Near ->
            "bg-amber-200"

        None ->
            "bg-gray-100"
