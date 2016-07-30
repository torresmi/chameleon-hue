module Auth.Models exposing (..)


defaultDeviceType : String
defaultDeviceType =
    "Chameleon-hue"


type alias AuthInfo =
    { deviceType : String
    , userName : Maybe String
    }


newCustom : String -> AuthInfo
newCustom deviceType =
    AuthInfo deviceType Nothing


newDefault : AuthInfo
newDefault =
    newCustom defaultDeviceType


defaultWithUserName : Maybe String -> AuthInfo
defaultWithUserName userName =
    AuthInfo defaultDeviceType userName
