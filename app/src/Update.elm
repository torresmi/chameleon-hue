module Update exposing (..)

import Messages exposing (Msg(..))
import Auth.Update
import Auth.Messages
import Auth.Models
import Models exposing (Model)
import Commands


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthMsg subMsg ->
            handleAuthMessage subMsg model

        GetIpAddress ->
            ( model, Commands.nupnpSearch )

        IpAddressSuccess (Just ip) ->
            ( { model | ipAddress = Just ip }, Cmd.none )

        IpAddressSuccess Nothing ->
            ( { model | ipAddress = Nothing }, Cmd.none )

        IpAddressFail error ->
            ( { model | ipAddress = Nothing, ipAddressError = Just error }, Cmd.none )


handleAuthMessage : Auth.Messages.Msg -> Model -> ( Model, Cmd Msg )
handleAuthMessage msg model =
    let
        ( authStatus, cmd ) =
            Auth.Update.update msg model.authStatus
    in
        ( { model | authStatus = authStatus }
        , Cmd.map AuthMsg cmd
        )