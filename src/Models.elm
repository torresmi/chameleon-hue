module Models exposing (..)

import Hue
import Http


type alias IpAddress =
    String


type alias Model =
    { bridgeRef : Maybe Hue.BridgeReference
    , ipAddress : Maybe IpAddress
    , userName : Maybe String
    , ipAddressError : Maybe Http.Error
    }


new : Model
new =
    Model Nothing Nothing Nothing Nothing
