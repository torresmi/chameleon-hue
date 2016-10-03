module Models exposing (..)

import Hue
import Http
import Auth.Models
import Material
import Routing


type alias IpAddress =
    String


type alias Mdl =
    Material.Model


type alias Model =
    { bridgeRef : Maybe Hue.BridgeReference
    , ipAddress : Maybe IpAddress
    , ipAddressError : Maybe Http.Error
    , authStatus : Auth.Models.AuthStatus
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
        Auth.Models.NeedAuth
        Material.model
        0
        route
