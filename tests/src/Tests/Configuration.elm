module Tests.Configuration exposing (tests)

import Tests.Utils exposing (testDecoder)
import ElmTest exposing (..)
import Resource.Configuration exposing (..)
import Auth.Commands exposing (..)


tests : Test
tests =
    suite "User decoders"
        [ test "Create user success" <|
            testDecoder createUserResponseDecoder createUserSuccess
        , test "Create user failure. Need to push link button" <|
            testDecoder createUserResponseDecoder createUserLinkFailure
        , test "Delete user success" <|
            testDecoder deleteUserResponseDecoder deleteUserSuccess
        , test "Delete user failure. General error" <|
            testDecoder deleteUserResponseDecoder deleteUserFailure
        ]
