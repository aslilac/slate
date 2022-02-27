module App.Model exposing (..)

import Array exposing (Array)
import Random


words : Array String
words =
    Array.fromList
        [ "aimed"
        , "alias"
        , "basic"
        , "books"
        , "build"
        , "check"
        , "coins"
        , "count"
        , "crate"
        , "cried"
        , "drink"
        , "eight"
        , "flack"
        , "flags"
        , "flask"
        , "gleam"
        , "guess"
        , "hello"
        , "hound"
        , "ingot"
        , "joint"
        , "jokes"
        , "knife"
        , "lamps"
        , "lists"
        , "model"
        , "moves"
        , "nails"
        , "nasty"
        , "novel"
        , "offer"
        , "order"
        , "paint"
        , "panda"
        , "plant"
        , "point"
        , "print"
        , "puppy"
        , "queen"
        , "quiet"
        , "quote"
        , "range"
        , "roles"
        , "rolls"
        , "seals"
        , "shade"
        , "shoes"
        , "slack"
        , "space"
        , "stops"
        , "treat"
        , "tries"
        , "tubes"
        , "under"
        , "vault"
        , "views"
        , "virus"
        , "waste"
        , "wheat"
        , "woods"
        , "words"
        , "world"
        , "yield"
        , "young"
        , "zones"

        -- hehe
        , "hayli"
        ]


type alias Flags =
    { dayOfGame : Int
    }


type alias Model =
    { answer : Maybe String
    , guesses : List String
    , pendingGuess : String
    }


type alias StrictModel =
    { answer : String
    , guesses : List String
    , pendingGuess : String
    }


init : Flags -> ( Model, Cmd message )
init flags =
    let
        range =
            Random.int 0 (Array.length words)

        seed =
            Random.initialSeed flags.dayOfGame

        ( index, _ ) =
            Random.step range seed

        answer =
            Array.get index words
                |> Maybe.map String.toUpper

        model =
            { answer = answer
            , guesses = []
            , pendingGuess = ""
            }
    in
    ( model
    , Cmd.none
    )
