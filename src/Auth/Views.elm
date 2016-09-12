module Auth.Views exposing (view)

import Models exposing (IpAddress)
import Auth.Models exposing (AuthStatus(..), AuthError(..))
import Html as Html exposing (Html)
import Html.Events exposing (..)
import Auth.Messages exposing (Msg(..))


view : Maybe IpAddress -> AuthStatus -> Html Msg
view ipAddress status =
    Html.div [] [ showCreateUser ipAddress status ]


showCreateUser : Maybe IpAddress -> AuthStatus -> Html Msg
showCreateUser ipAddress status =
    case ipAddress of
        Just ip ->
            case status of
                NeedAuth ->
                    Html.button
                        [ onClick (CreateUser ip Auth.Models.defaultDeviceType) ]
                        [ Html.text "Create User" ]

                AuthSuccess userName ->
                    Html.text ("created user " ++ userName)

                AuthFailure authError ->
                    case authError of
                        NeedPushLink ->
                            Html.text "Please push the link button on the bridge and try again"

                        AuthError errors ->
                            Html.text "Errors creating user. Please try again"

        Nothing ->
            Html.text "loading ip..."
