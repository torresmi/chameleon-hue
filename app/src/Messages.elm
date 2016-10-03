module Messages exposing (Msg(..))

import Auth.Messages
import Types
import Http
import Material


type Msg
    = AuthMsg Auth.Messages.Msg
    | GetIpAddress
    | IpAddressSuccess (Maybe Types.IpAddress)
    | IpAddressFail Http.Error
    | Mdl (Material.Msg Msg)
    | SelectSettings
    | SelectTab Int
    | StoredUserName (Maybe Types.Username)
