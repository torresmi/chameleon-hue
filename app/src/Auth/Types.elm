module Auth.Types exposing (..)


defaultDeviceType : String
defaultDeviceType =
    "Chameleon-hue"


type AuthStatus
    = AuthSuccess String
    | NeedAuth
    | AuthFailure AuthError


type AuthError
    = NeedPushLink
    | AuthError (List Error)


type Response a
    = ErrorsResponse (List Error)
    | ValidResponse a


type alias Error =
    { type' : Int
    , address : String
    , description : String
    }
