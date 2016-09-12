module Auth.Commands exposing (createUser)

import Http
import Json.Decode as Decode exposing ((:=))
import Task exposing (Task)
import Auth.Messages exposing (Msg(..))
import Auth.Models exposing (Error, Response(..))
import Models exposing (IpAddress)


createUser : IpAddress -> String -> Cmd Msg
createUser ipAddress deviceType =
    let
        url =
            "http://" ++ ipAddress ++ "/api"

        body deviceType =
            Http.string ("{\"devicetype\": \"" ++ deviceType ++ "\"}")
    in
        Http.post userResponseDecoder url (body deviceType)
            |> Task.perform CreateUserFail CreateUserSuccess



-- Decoding


responseDecoder : Decode.Decoder a -> Decode.Decoder (Response a)
responseDecoder responseDecoder =
    Decode.oneOf
        [ Decode.map ValidResponse responseDecoder
        , Decode.map ErrorsResponse errorsDecoder
        ]


userDecoder : Decode.Decoder String
userDecoder =
    Decode.at [ "success", "deviceType" ] Decode.string


userResponseDecoder : Decode.Decoder (Response String)
userResponseDecoder =
    responseDecoder userDecoder


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
