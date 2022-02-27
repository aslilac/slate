module App.HtmlUtil exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)


focus : Attribute msg
focus =
    attribute "focus" "true"
