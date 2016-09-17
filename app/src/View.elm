module View exposing (..)

import Models exposing (Model, IpAddress)
import Html as Html exposing (Html)
import Html.App as App
import Html.Events exposing (..)
import Messages exposing (Msg(..))
import Auth.Views exposing (view)
import Auth.Models


view : Model -> Html Msg
view model =
    Html.div []
        [ showAuthView model ]


showAuthView : Model -> Html Msg
showAuthView model =
    case model.authStatus of
        Auth.Models.AuthSuccess userName ->
            Html.text "ready to change lights"

        _ ->
            App.map AuthMsg (Auth.Views.view model.ipAddress model.authStatus)
