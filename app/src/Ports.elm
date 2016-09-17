port module Ports exposing (..)


port storage : String -> Cmd msg


port storageInput : (Maybe String -> msg) -> Sub msg
