module Auth.Update exposing (..)

import Auth.Messages exposing (Msg(..))
import Auth.Types exposing (AuthStatus(..), Response(..), Error, AuthError(..))
import Auth.Commands as Commands
import Routing
import Navigation
import Ports


update : Msg -> AuthStatus -> ( AuthStatus, Cmd Msg )
update msg status =
    case msg of
        CreateUser ipAddress deviceType ->
            ( status, Commands.createUser ipAddress deviceType )

        CreateUserSuccess response ->
            case response of
                ValidResponse userName ->
                    ( AuthSuccess userName
                    , Cmd.batch
                        [ Ports.storage userName
                        , Navigation.newUrl (Routing.fragment Routing.mainNav)
                        ]
                    )

                ErrorsResponse errors ->
                    handleCreateUserErrors errors

        CreateUserFail error ->
            ( NeedAuth, Cmd.none )

        DeleteUser userName ->
            ( status, Cmd.none )

        DeleteUserSuccess response ->
            case response of
                ValidResponse _ ->
                    ( NeedAuth, Cmd.none )

                ErrorsResponse _ ->
                    ( status, Cmd.none )

        DeleteUserFail error ->
            ( status, Cmd.none )


handleCreateUserErrors : List Error -> ( AuthStatus, Cmd Msg )
handleCreateUserErrors errors =
    let
        linkError =
            List.any (\e -> e.type' == 101) errors
    in
        if linkError == True then
            ( AuthFailure NeedPushLink, Cmd.none )
        else
            ( AuthFailure (AuthError errors), Cmd.none )
