module App.Model exposing (..)

import Array exposing (Array)
import Random


words : Array String
words =
    Array.fromList
        [ "aimed"
        , "basic"
        , "books"
        , "build"
        , "check"
        , "coins"
        , "crate"
        , "drink"
        , "eight"
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
        , "offer"
        , "order"
        , "paint"
        , "panda"
        , "point"
        , "print"
        , "quiet"
        , "quote"
        , "range"
        , "seals"
        , "shade"
        , "stops"
        , "treat"
        , "tubes"
        , "under"
        , "vault"
        , "views"
        , "virus"
        , "waste"
        , "wheat"
        , "woods"
        , "world"
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

        model =
            { answer = answer
            , guesses = []
            , pendingGuess = ""
            }
    in
    ( model
    , Cmd.none
    )
