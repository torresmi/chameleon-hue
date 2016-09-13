module Auth.Messages exposing (..)

import Http
import Auth.Models exposing (Response)


type Msg
    = CreateUser String String
    | CreateUserSuccess (Response String)
    | CreateUserFail Http.Error
    | DeleteUser String
    | DeleteUserSuccess (Response String)
    | DeleteUserFail Http.Error
