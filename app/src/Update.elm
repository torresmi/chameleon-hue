module Update exposing (..)

import Messages exposing (Msg(..))
import Auth.Update
import Auth.Messages
import Auth.Types
import Model exposing (Model)
import Commands
import Material
import Routing
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthMsg subMsg ->
            updateAuthMessage subMsg model

        GetIpAddress ->
            ( model, Commands.nupnpSearch )

        IpAddressSuccess (Just ip) ->
            ( { model | ipAddress = Just ip }, Cmd.none )

        IpAddressSuccess Nothing ->
            ( { model | ipAddress = Nothing }, Cmd.none )

        IpAddressFail error ->
            ( { model | ipAddress = Nothing, ipAddressError = Just error }, Cmd.none )

        Mdl subMsg ->
            Material.update subMsg model

        SelectSettings ->
            ( { model | route = Routing.SettingsRoute }, Navigation.newUrl (Routing.fragment Routing.settings) )

        SelectTab index ->
            ( { model | selectedTab = index }, Cmd.none )

        StoredUserName userName ->
            case userName of
                Just name ->
                    ( { model | authStatus = Auth.Types.AuthSuccess name, route = Routing.MainNavRoute }, Navigation.newUrl (Routing.fragment Routing.mainNav) )

                Nothing ->
                    Debug.log "stored username not set"
                        ( { model | authStatus = Auth.Types.NeedAuth, route = Routing.SettingsRoute }, Cmd.none )


updateAuthMessage : Auth.Messages.Msg -> Model -> ( Model, Cmd Msg )
updateAuthMessage msg model =
    let
        ( authStatus, cmd ) =
            Auth.Update.update msg model.authStatus
    in
        ( { model | authStatus = authStatus }
        , Cmd.map AuthMsg cmd
        )
