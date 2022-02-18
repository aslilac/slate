module App.View exposing (..)

import App.Model exposing (..)
import App.Update exposing (..)
import Friend exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Action
view model =
    let
        word1 =
            "Slate"

        word2 =
            "Howdy"
    in
    div [ class "prose p-5 m-auto" ]
        [ div [ class "flex flex-col grow items-center justify-center" ]
            (List.concat
                [ [ h1 [ class "font-hello text-center" ] [ text "Wordle" ]
                  , hello
                  , helloToFriend model.friendName
                  , button [ onClick Increment ] [ text "+" ]
                  , button [ onClick (IncrementBy 5) ] [ text "+5" ]
                  ]
                , [ friendButton defaultFriendName ]
                , List.map friendButton otherFriendNames
                , [ button [ onClick (SayHiTo "August") ] [ text "August" ]
                  , button [ onClick (SayHiTo "Dot") ] [ text "Dot" ]
                  , button [ onClick (SayHiTo "Toby") ] [ text "Toby" ]
                  , p [ class "color-red" ] [ text (String.fromInt model.count) ]
                  ]
                ]
            )
        ]


friendButton name =
    button [ onClick (SayHiTo name) ] [ text name ]
