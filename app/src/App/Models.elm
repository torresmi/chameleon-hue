module App.Models exposing (Model, newWithRoute, new)

import Hue
import Http
import App.Routing
import Material
import Hue


type alias Model =
    { mdl : Material.Model
    , bridgeRef : Maybe Hue.BridgeReference
    , selectedTab : Int
    , route : App.Routing.Route
    }


newWithRoute : App.Routing.Route -> Model
newWithRoute route =
    { new | route = route }


new : Model
new =
    { mdl = Material.model
    , bridgeRef = Nothing
    , selectedTab = 0
    , route = App.Routing.MainNav
    }
