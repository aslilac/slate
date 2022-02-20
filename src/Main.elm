module Main exposing (..)

import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)
import Browser


main : Program Flags Model Message
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Message
subscriptions _ =
    Sub.none
