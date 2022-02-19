module App.Update exposing (..)

import App.Model exposing (..)


type Action
    = UpdateGuess String
    | SubmitGuess


update : Action -> Model -> Model
update action model =
    case action of
        UpdateGuess guess ->
            { model | pendingGuess = guess }

        SubmitGuess ->
            { model | guesses = model.pendingGuess :: model.guesses, pendingGuess = "" }
