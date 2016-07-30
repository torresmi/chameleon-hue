module Auth.Messages exposing (..)

import Http


type Msg
    = CreateUser String
    | CreateUserSuccess String
    | CreateUserFail Http.Error
    | DeleteUser String
    | DeleteUserSuccess
    | DeleteUserFail Http.Error
