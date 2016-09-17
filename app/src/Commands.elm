module Commands exposing (nupnpSearch)

import Http
import Json.Decode as Decode exposing ((:=))
import Task exposing (Task)
import Messages exposing (Msg(..))
import Models exposing (IpAddress)


nupnpUrl : String
nupnpUrl =
    "https://www.meethue.com/api/nupnp"


nupnpSearch : Cmd Msg
nupnpSearch =
    Http.get nupnpDecoder nupnpUrl
        |> Task.map nupnpIpExtractor
        |> Task.perform IpAddressFail IpAddressSuccess


type alias NupnpConfig =
    { id : String
    , internalIpAddress : IpAddress
    , macAddress : Maybe String
    , name : Maybe String
    }


nupnpIpExtractor : List NupnpConfig -> Maybe IpAddress
nupnpIpExtractor configurations =
    List.map (\c -> c.internalIpAddress) configurations
        |> List.head



-- Decoders


nupnpDecoder : Decode.Decoder (List NupnpConfig)
nupnpDecoder =
    Decode.object4
        NupnpConfig
        ("id" := Decode.string)
        ("internalipaddress" := Decode.string)
        (Decode.maybe ("macaddress" := Decode.string))
        (Decode.maybe ("name" := Decode.string))
        |> Decode.list
