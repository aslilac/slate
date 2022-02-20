module App.Update exposing (..)

import App.Model exposing (..)


type Message
    = UpdateGuess String
    | SubmitGuess


update : Message -> Model -> ( Model, Cmd message )
update action model =
    case action of
        UpdateGuess guess ->
            ( { model | pendingGuess = sanitizeGuess guess }
            , Cmd.none
            )

        SubmitGuess ->
            ( { model | guesses = model.pendingGuess :: model.guesses, pendingGuess = "" }
            , Cmd.none
            )


sanitizeGuess : String -> String
sanitizeGuess guess =
    let
        filtered =
            String.filter Char.isAlpha guess

        trimmed =
            String.slice 0 5 filtered

        formatted =
            String.toUpper trimmed
    in
    formatted
