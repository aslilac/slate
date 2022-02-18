module Main exposing (..)

import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)
import Browser


main : Program () Model Action
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
