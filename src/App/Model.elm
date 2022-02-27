module App.Model exposing (..)

import Array exposing (Array)
import Random


words : Array String
words =
    Array.fromList
        [ "aimed"
        , "alias"
        , "alibi"
        , "alike"
        , "alive"
        , "aside"
        , "basic"
        , "beast"
        , "begin"
        , "books"
        , "brief"
        , "build"
        , "calls"
        , "cared"
        , "cares"
        , "cents"
        , "chase"
        , "check"
        , "chose"
        , "clear"
        , "clans"
        , "coins"
        , "comic"
        , "count"
        , "crate"
        , "cried"
        , "drink"
        , "eight"
        , "flack"
        , "flags"
        , "flask"
        , "flock"
        , "gleam"
        , "guess"
        , "guest"
        , "hangs"
        , "hatch"
        , "hated"
        , "hates"
        , "haunt"
        , "hazel"
        , "hello"
        , "helps"
        , "hills"
        , "hound"
        , "hurry"
        , "index"
        , "ingot"
        , "joint"
        , "jokes"
        , "jolly"
        , "joust"
        , "judge"
        , "kitty"
        , "knife"
        , "lamps"
        , "liked"
        , "likes"
        , "lists"
        , "lives"
        , "lodge"
        , "loyal"
        , "lucky"
        , "maids"
        , "model"
        , "moist"
        , "moods"
        , "moody"
        , "moves"
        , "muddy"
        , "nails"
        , "nasty"
        , "novel"
        , "ocean"
        , "offer"
        , "order"
        , "other"
        , "paint"
        , "panda"
        , "plant"
        , "plots"
        , "pluck"
        , "plugs"
        , "plumb"
        , "point"
        , "ponds"
        , "print"
        , "puppy"
        , "queen"
        , "quiet"
        , "quote"
        , "range"
        , "roles"
        , "rolls"
        , "salad"
        , "saved"
        , "seals"
        , "shade"
        , "shoes"
        , "slack"
        , "small"
        , "slide"
        , "space"
        , "stand"
        , "stops"
        , "treat"
        , "tries"
        , "tubes"
        , "twins"
        , "twist"
        , "under"
        , "vault"
        , "views"
        , "virus"
        , "waste"
        , "wheat"
        , "woods"
        , "would"
        , "words"
        , "world"
        , "worse"
        , "worst"
        , "worth"
        , "wrote"
        , "yield"
        , "young"
        , "yours"
        , "zebra"
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
