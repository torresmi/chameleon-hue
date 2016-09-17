module Models exposing (..)

import Hue
import Http
import Auth.Models


type alias IpAddress =
    String


type alias Model =
    { bridgeRef : Maybe Hue.BridgeReference
    , ipAddress : Maybe IpAddress
    , ipAddressError : Maybe Http.Error
    , authStatus : Auth.Models.AuthStatus
    }


new : Model
new =
    Model Nothing Nothing Nothing Auth.Models.NeedAuth
