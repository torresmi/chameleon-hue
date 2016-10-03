module Model exposing (Model, new)

import Hue
import Http
import Auth.Types
import Material
import Routing
import Types


type alias Model =
    { bridgeRef : Maybe Hue.BridgeReference
    , ipAddress : Maybe Types.IpAddress
    , ipAddressError : Maybe Http.Error
    , authStatus : Auth.Types.AuthStatus
    , mdl : Material.Model
    , selectedTab : Int
    , route : Routing.Route
    }


new : Routing.Route -> Model
new route =
    Model
        Nothing
        Nothing
        Nothing
        Auth.Types.NeedAuth
        Material.model
        0
        route
