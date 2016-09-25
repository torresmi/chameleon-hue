module Update exposing (update)

import Messages exposing (Msg(..))
import App.Messages
import Models exposing (IpStatus(..))
import Auth.Models
import App.Update
import Navigation
import Routing
import App.Routing
import Commands
import Material
import Auth.CreateUser
import Auth.DeleteUser


update : Messages.Msg -> Models.Model -> ( Models.Model, Cmd Messages.Msg )
update msg model =
    case msg of
        App subMsg ->
            handleAppMessage subMsg model

        StoredUserName userName ->
            handleSavedUserName userName model

        GetIpAddress ->
            ( model, Commands.nupnpSearch )

        IpAddressSuccess (Just ip) ->
            ( { model | ipStatus = Ip ip }, Cmd.none )

        IpAddressSuccess Nothing ->
            ( { model | ipStatus = IpNotAvailable }, Cmd.none )

        IpAddressFail error ->
            ( { model | ipStatus = IpError error }, Cmd.none )

        Mdl subMsg ->
            Material.update subMsg model

        CreateUser subMsg ->
            handleCreateUser model subMsg

        DeleteUser subMsg ->
            handleDeleteUser model subMsg


handleAppMessage : App.Messages.Msg -> Models.Model -> ( Models.Model, Cmd Messages.Msg )
handleAppMessage msg model =
    case model.authStatus of
        Auth.Models.AuthSuccess userName ->
            let
                context =
                    Models.BridgeRefContext model.ipStatus userName

                ( subModel, subCmd ) =
                    App.Update.update msg context model.appModel
            in
                ( { model | appModel = subModel }
                , Cmd.map App subCmd
                )

        _ ->
            Debug.log ("Message sent to App when not logged in" ++ toString msg)
                ( model, Cmd.none )


handleSavedUserName : Maybe String -> Models.Model -> ( Models.Model, Cmd Messages.Msg )
handleSavedUserName userName model =
    case Debug.log "Username : " userName of
        Just name ->
            ( { model | authStatus = Auth.Models.AuthSuccess name }, Navigation.newUrl (Routing.toHash (Routing.App App.Routing.MainNav)) )

        Nothing ->
            ( { model | authStatus = Auth.Models.NeedAuth }, Cmd.none )


handleCreateUser : Models.Model -> Auth.CreateUser.Msg -> ( Models.Model, Cmd Messages.Msg )
handleCreateUser model msg =
    let
        context =
            Models.AuthContext model.ipStatus model.authStatus

        ( authStatus, cmd ) =
            Auth.CreateUser.update context msg
    in
        ( { model | authStatus = authStatus }
        , Cmd.map Messages.CreateUser cmd
        )


handleDeleteUser : Models.Model -> Auth.DeleteUser.Msg -> ( Models.Model, Cmd Messages.Msg )
handleDeleteUser model msg =
    let
        context =
            Models.AuthContext model.ipStatus model.authStatus

        ( authStatus, cmd ) =
            Auth.DeleteUser.update context msg
    in
        ( { model | authStatus = authStatus }
        , Cmd.map Messages.DeleteUser cmd
        )
