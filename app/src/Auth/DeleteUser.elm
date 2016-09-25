module Auth.DeleteUser exposing (Msg(..), update, view)

import Models exposing (AuthContext, IpStatus(..), IpAddress)
import Auth.Models exposing (AuthStatus(..), AuthError(..), Response(..))
import Auth.Commands
import Html as Html exposing (Html)
import Html.Events exposing (..)
import Http
import Ports
import Navigation
import Routing
import App.Routing
import Task exposing (Task)
import Json.Decode as Decode exposing ((:=))


-- Update


type Msg
    = DeleteUser Models.IpAddress String
    | DeleteUserSuccess (Response String)
    | DeleteUserFail Http.Error


update : AuthContext -> Msg -> ( AuthStatus, Cmd Msg )
update context msg =
    case msg of
        DeleteUser ipAddress userName ->
            ( context.authStatus, deleteUser ipAddress userName )

        DeleteUserSuccess response ->
            case response of
                ValidResponse _ ->
                    ( NeedAuth, Navigation.modifyUrl (Routing.toHash Routing.Login) )

                ErrorsResponse _ ->
                    ( context.authStatus, Cmd.none )

        DeleteUserFail error ->
            ( context.authStatus, Cmd.none )



-- Commands


deleteUser : IpAddress -> String -> Cmd Msg
deleteUser ipAddress userName =
    Http.fromJson deleteUserResponseDecoder
        (Http.send
            Http.defaultSettings
            { verb = "DELETE"
            , headers = [ Auth.Commands.jsonHeaderType ]
            , url = (Auth.Commands.baseUrl ipAddress ++ "/" ++ userName ++ "/config/whitelist/" ++ userName)
            , body = Http.empty
            }
        )
        |> Task.perform DeleteUserFail DeleteUserSuccess


userDeleteSuccess : Decode.Decoder String
userDeleteSuccess =
    Decode.list ("success" := Decode.string)
        `Decode.andThen` Auth.Commands.takeFirst


deleteUserResponseDecoder : Decode.Decoder (Response String)
deleteUserResponseDecoder =
    Auth.Commands.responseDecoder userDeleteSuccess



-- view


view : IpAddress -> Html Msg
view ip =
    Html.div [] [ showDeleteUser ip ]


showDeleteUser : IpAddress -> Html Msg
showDeleteUser ip =
    Html.button
        [ onClick (DeleteUser ip Auth.Models.defaultDeviceType) ]
        [ Html.text "Delete User" ]
