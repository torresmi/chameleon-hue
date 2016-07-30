module Auth.Views exposing (..)

import Auth.Models
import Html as Html exposing (Html)
import Html.Events exposing (..)
import Auth.Messages exposing (Msg(..))


view : Auth.Models.AuthInfo -> Html Msg
view authInfo =
    Html.div []
        [ Html.button [ onClick (CreateUser Auth.Models.defaultDeviceType) ] [ Html.text "Create User" ]
        ]
