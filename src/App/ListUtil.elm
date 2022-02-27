module App.ListUtil exposing (..)


foldMap : (( state, t ) -> ( state, t )) -> state -> List t -> List t
foldMap reducer initialState list =
    List.foldl (\( state, t ) -> ( state, t ))
