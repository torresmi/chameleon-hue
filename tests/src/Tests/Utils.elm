module Tests.Utils exposing (..)

import Json.Decode as Decode
import ElmTest exposing (..)


testDecoder : Decode.Decoder a -> String -> Assertion
testDecoder decoder str =
    case Decode.decodeString decoder str of
        Ok _ ->
            pass

        Err e ->
            fail e
