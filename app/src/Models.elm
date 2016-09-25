module Models exposing (Model, IpAddress, IpStatus(..), new, Mdl, AuthContext, BridgeRefContext)

import App.Models
import Routing
import Http
import Material
import Auth.Models


type alias IpAddress =
    String


type alias Mdl =
    Material.Model


type IpStatus
    = Ip IpAddress
    | IpNotAvailable
    | IpLoading
    | IpError Http.Error


type alias AuthContext =
    { ipStatus : IpStatus
    , authStatus : Auth.Models.AuthStatus
    }


type alias BridgeRefContext =
    { ipStatus : IpStatus
    , userName : String
    }


type alias Model =
    { appModel : App.Models.Model
    , mdl : Material.Model
    , ipStatus : IpStatus
    , authStatus : Auth.Models.AuthStatus
    , route : Routing.Route
    }


new : Routing.Route -> Model
new route =
    let
        appModel =
            case route of
                Routing.App subRoute ->
                    App.Models.newWithRoute subRoute

                _ ->
                    App.Models.new
    in
        { appModel = appModel
        , mdl = Material.model
        , ipStatus = IpLoading
        , authStatus = Auth.Models.NeedAuth
        , route = route
        }
