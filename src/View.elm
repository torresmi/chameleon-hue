module View exposing (..)

import Models exposing (Model)
import Html as Html exposing (Html)
import Html.App as App
import Html.Events exposing (..)
import Messages exposing (Msg(..))
import Auth.Views exposing (view)
import Auth.Models


view : Model -> Html Msg
view model =
    Html.div []
        [ App.map AuthMsg (Auth.Views.view (Auth.Models.defaultWithUserName model.userName)) ]
