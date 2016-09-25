module Auth.CreateUser exposing (Msg(..), update, view)

import Models exposing (AuthContext, IpStatus(..))
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
    = CreateUser Models.IpAddress String
    | CreateUserSuccess (Response String)
    | CreateUserFail Http.Error


update : AuthContext -> Msg -> ( AuthStatus, Cmd Msg )
update context msg =
    case msg of
        CreateUser ipAddress deviceType ->
            ( context.authStatus, createUser ipAddress deviceType )

        CreateUserSuccess response ->
            case response of
                ValidResponse userName ->
                    ( AuthSuccess userName
                    , Cmd.batch
                        [ Ports.storage userName
                        , Navigation.newUrl (Routing.toHash (Routing.App App.Routing.MainNav))
                        ]
                    )

                ErrorsResponse errors ->
                    handleCreateUserErrors errors

        CreateUserFail error ->
            ( NeedAuth, Cmd.none )


handleCreateUserErrors : List Auth.Models.Error -> ( AuthStatus, Cmd Msg )
handleCreateUserErrors errors =
    let
        linkError =
            List.any (\e -> e.type' == 101) errors
    in
        if linkError == True then
            ( AuthFailure NeedPushLink, Cmd.none )
        else
            ( AuthFailure (AuthError errors), Cmd.none )



-- Commands


createUser : Models.IpAddress -> String -> Cmd Msg
createUser ipAddress deviceType =
    let
        url =
            Auth.Commands.baseUrl ipAddress

        body deviceType =
            Http.string ("{\"devicetype\": \"" ++ deviceType ++ "\"}")
    in
        Http.post createUserResponseDecoder url (body deviceType)
            |> Task.perform CreateUserFail CreateUserSuccess


userSuccessDecoder : Decode.Decoder String
userSuccessDecoder =
    Decode.list (Decode.at [ "success", "username" ] Decode.string)
        `Decode.andThen` Auth.Commands.takeFirst


createUserResponseDecoder : Decode.Decoder (Response String)
createUserResponseDecoder =
    Auth.Commands.responseDecoder userSuccessDecoder



-- View


view : Models.AuthContext -> Html Msg
view model =
    Html.div [] [ showCreateUser model ]


showCreateUser : Models.AuthContext -> Html Msg
showCreateUser context =
    case context.ipStatus of
        Ip address ->
            case context.authStatus of
                NeedAuth ->
                    Html.button
                        [ onClick (CreateUser address Auth.Models.defaultDeviceType) ]
                        [ Html.text "Create User" ]

                AuthSuccess userName ->
                    Html.text ("created user " ++ userName)

                AuthFailure authError ->
                    case authError of
                        NeedPushLink ->
                            Html.text "Please push the link button on the bridge and try again"

                        AuthError errors ->
                            Html.text "Errors creating user. Please try again"

        IpLoading ->
            Html.text "loading ip..."

        _ ->
            Html.text "Failed to get ip address"
