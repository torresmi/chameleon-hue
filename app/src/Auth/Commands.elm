module Auth.Commands exposing (..)

import Http
import Json.Decode as Decode exposing ((:=))
import Task exposing (Task)
import Models exposing (IpAddress)
import Auth.Models exposing (Error, Response(..))


jsonHeaderType : ( String, String )
jsonHeaderType =
    ( "Content-Type", "application/json" )


baseUrl : IpAddress -> String
baseUrl ipAddress =
    "http://" ++ ipAddress ++ "/api"


takeFirst : List a -> Decode.Decoder a
takeFirst values =
    let
        head =
            List.head values
    in
        case head of
            Just value ->
                Decode.succeed value

            Nothing ->
                Decode.fail "List was empty"


responseDecoder : Decode.Decoder a -> Decode.Decoder (Response a)
responseDecoder responseDecoder =
    Decode.oneOf
        [ Decode.map ValidResponse responseDecoder
        , Decode.map ErrorsResponse errorsDecoder
        ]


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.at [ "error" ] <|
        Decode.object3
            Error
            ("type" := Decode.int)
            ("address" := Decode.string)
            ("description" := Decode.string)


errorsDecoder : Decode.Decoder (List Error)
errorsDecoder =
    Decode.list errorDecoder
