module Messages exposing (Msg(..))

import App.Messages
import Models exposing (IpAddress)
import Http
import Material
import Auth.CreateUser
import Auth.DeleteUser


type Msg
    = StoredUserName (Maybe String)
    | Mdl (Material.Msg Msg)
    | App App.Messages.Msg
    | CreateUser Auth.CreateUser.Msg
    | DeleteUser Auth.DeleteUser.Msg
    | GetIpAddress
    | IpAddressSuccess (Maybe IpAddress)
    | IpAddressFail Http.Error
