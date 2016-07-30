module Auth.Update exposing (..)

import Auth.Messages exposing (Msg(..))
import Auth.Models exposing (AuthInfo)


update : Msg -> AuthInfo -> ( AuthInfo, Cmd Msg )
update msg authInfo =
    case msg of
        CreateUser deviceType ->
            ( { authInfo | deviceType = deviceType }, Cmd.none )

        CreateUserSuccess userName ->
            ( { authInfo | userName = Just userName }, Cmd.none )

        CreateUserFail error ->
            ( { authInfo | userName = Nothing }, Cmd.none )

        DeleteUser userName ->
            ( authInfo, Cmd.none )

        DeleteUserSuccess ->
            ( { authInfo | userName = Nothing }, Cmd.none )

        DeleteUserFail error ->
            ( authInfo, Cmd.none )
