module App.Update exposing (..)

import App.Model exposing (..)


type Action
    = Increment


update : Action -> Model -> Model
update action model =
    case action of
        Increment ->
            model + 1
