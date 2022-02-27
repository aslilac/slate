module App.CharCount exposing (..)


countChars : List Char -> CharCount
countChars chars =
    List.foldl addChar initCharCount chars


numOfChar : Char -> CharCount -> Int
numOfChar char charCount =
    case Char.toUpper char of
        'A' ->
            charCount.a

        'B' ->
            charCount.b

        'C' ->
            charCount.c

        'D' ->
            charCount.d

        'E' ->
            charCount.e

        'F' ->
            charCount.f

        'G' ->
            charCount.g

        'H' ->
            charCount.h

        'I' ->
            charCount.i

        'J' ->
            charCount.j

        'K' ->
            charCount.k

        'L' ->
            charCount.l

        'M' ->
            charCount.m

        'N' ->
            charCount.n

        'O' ->
            charCount.o

        'P' ->
            charCount.p

        'Q' ->
            charCount.q

        'R' ->
            charCount.r

        'S' ->
            charCount.s

        'T' ->
            charCount.t

        'U' ->
            charCount.u

        'V' ->
            charCount.v

        'W' ->
            charCount.w

        'X' ->
            charCount.x

        'Y' ->
            charCount.y

        'Z' ->
            charCount.z

        _ ->
            0


addChar : Char -> CharCount -> CharCount
addChar char charCount =
    case Char.toUpper char of
        'A' ->
            { charCount | a = charCount.a + 1 }

        'B' ->
            { charCount | b = charCount.b + 1 }

        'C' ->
            { charCount | c = charCount.c + 1 }

        'D' ->
            { charCount | d = charCount.d + 1 }

        'E' ->
            { charCount | e = charCount.e + 1 }

        'F' ->
            { charCount | f = charCount.f + 1 }

        'G' ->
            { charCount | g = charCount.g + 1 }

        'H' ->
            { charCount | h = charCount.h + 1 }

        'I' ->
            { charCount | i = charCount.i + 1 }

        'J' ->
            { charCount | j = charCount.j + 1 }

        'K' ->
            { charCount | k = charCount.k + 1 }

        'L' ->
            { charCount | l = charCount.l + 1 }

        'M' ->
            { charCount | m = charCount.m + 1 }

        'N' ->
            { charCount | n = charCount.n + 1 }

        'O' ->
            { charCount | o = charCount.o + 1 }

        'P' ->
            { charCount | p = charCount.p + 1 }

        'Q' ->
            { charCount | q = charCount.q + 1 }

        'R' ->
            { charCount | r = charCount.r + 1 }

        'S' ->
            { charCount | s = charCount.s + 1 }

        'T' ->
            { charCount | t = charCount.t + 1 }

        'U' ->
            { charCount | u = charCount.u + 1 }

        'V' ->
            { charCount | v = charCount.v + 1 }

        'W' ->
            { charCount | w = charCount.w + 1 }

        'X' ->
            { charCount | x = charCount.x + 1 }

        'Y' ->
            { charCount | y = charCount.y + 1 }

        'Z' ->
            { charCount | z = charCount.z + 1 }

        _ ->
            charCount


type alias CharCount =
    { a : Int
    , b : Int
    , c : Int
    , d : Int
    , e : Int
    , f : Int
    , g : Int
    , h : Int
    , i : Int
    , j : Int
    , k : Int
    , l : Int
    , m : Int
    , n : Int
    , o : Int
    , p : Int
    , q : Int
    , r : Int
    , s : Int
    , t : Int
    , u : Int
    , v : Int
    , w : Int
    , x : Int
    , y : Int
    , z : Int
    }


initCharCount : CharCount
initCharCount =
    { a = 0
    , b = 0
    , c = 0
    , d = 0
    , e = 0
    , f = 0
    , g = 0
    , h = 0
    , i = 0
    , j = 0
    , k = 0
    , l = 0
    , m = 0
    , n = 0
    , o = 0
    , p = 0
    , q = 0
    , r = 0
    , s = 0
    , t = 0
    , u = 0
    , v = 0
    , w = 0
    , x = 0
    , y = 0
    , z = 0
    }
