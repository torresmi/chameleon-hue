module App.Update exposing (update)

import App.Messages exposing (Msg(..))
import App.Models exposing (Model)
import Models exposing (BridgeRefContext, IpStatus(..))
import Commands
import Material
import App.Routing
import Navigation
import Hue


update : Msg -> BridgeRefContext -> Model -> ( Model, Cmd Msg )
update msg context model =
    let
        -- Update for ip status changes
        bridgeUpdateModel =
            case context.ipStatus of
                Ip address ->
                    { model | bridgeRef = Just (Hue.bridgeRef context.userName address) }

                _ ->
                    { model | bridgeRef = Nothing }
    in
        case msg of
            Mdl subMsg ->
                Material.update subMsg bridgeUpdateModel

            SelectSettings ->
                ( { bridgeUpdateModel | route = App.Routing.Settings }, Navigation.newUrl (App.Routing.toHash App.Routing.Settings) )

            SelectTab index ->
                ( { bridgeUpdateModel | selectedTab = index }, Cmd.none )
