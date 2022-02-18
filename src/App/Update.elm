module App.Update exposing (..)

import App.Model exposing (..)


type Action
    = Increment
    | IncrementBy Int
    | SayHiTo String


update : Action -> Model -> Model
update action model =
    case action of
        Increment ->
            { model | count = model.count + 1 }

        IncrementBy delta ->
            { model | count = model.count + delta }

        SayHiTo name ->
            { model | friendName = name }
