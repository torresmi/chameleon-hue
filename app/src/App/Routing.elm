module App.Routing exposing (Route(..), toHash, parsers)

import Navigation
import UrlParser exposing (format)
import String


type Route
    = Settings
    | MainNav


settings : String
settings =
    "settings"


mainNav : String
mainNav =
    ""


toHash : Route -> String
toHash route =
    "#"
        ++ case route of
            Settings ->
                settings

            MainNav ->
                mainNav


parsers : List ( Route, UrlParser.Parser a a )
parsers =
    [ ( Settings, (UrlParser.s settings) )
    , ( MainNav, (UrlParser.s mainNav) )
    ]
