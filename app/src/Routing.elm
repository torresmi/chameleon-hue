module Routing exposing (Route(..), toHash, routeFromResult, parser)

import Navigation
import UrlParser exposing (format)
import String
import App.Routing as AppRouter


type Route
    = Login
    | App AppRouter.Route
    | NotFound


login : String
login =
    "login"


notFound : String
notFound =
    "notfound"


toHash : Route -> String
toHash route =
    case route of
        Login ->
            "#" ++ login

        App subRoute ->
            AppRouter.toHash subRoute

        NotFound ->
            "#" ++ notFound


matchers : UrlParser.Parser (Route -> a) a
matchers =
    let
        appParsers =
            List.map
                (\( subType, parser ) ->
                    format (App subType) parser
                )
                AppRouter.parsers

        allParsers =
            format Login (UrlParser.s login) :: appParsers
    in
        UrlParser.oneOf allParsers


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
            NotFound
