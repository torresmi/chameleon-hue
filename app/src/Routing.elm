module Routing exposing (..)

import Navigation
import UrlParser exposing (format)
import String


type Route
    = SettingsRoute
    | MainNavRoute
    | NotFoundRoute


settings : String
settings =
    "settings"


mainNav : String
mainNav =
    ""


fragment : String -> String
fragment route =
    "#" ++ route


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ format SettingsRoute (UrlParser.s settings)
        , format MainNavRoute (UrlParser.s mainNav)
        ]


hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.hash
        |> String.dropLeft 1
        |> UrlParser.parse identity matchers


parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route
routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            NotFoundRoute
