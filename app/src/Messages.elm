module Messages exposing (..)

import Auth.Messages exposing (Msg(..))
import Models exposing (IpAddress)
import Http
import Material


type Msg
    = AuthMsg Auth.Messages.Msg
    | GetIpAddress
    | IpAddressSuccess (Maybe IpAddress)
    | IpAddressFail Http.Error
    | Mdl (Material.Msg Msg)
    | SelectSettings
    | SelectTab Int
