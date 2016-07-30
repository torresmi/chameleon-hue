module Messages exposing (..)

import Auth.Messages exposing (Msg(..))
import Models exposing (IpAddress)
import Http


type Msg
    = AuthMsg Auth.Messages.Msg
    | GetIpAddress
    | IpAddressSuccess (Maybe IpAddress)
    | IpAddressFail Http.Error
