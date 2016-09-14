module Main exposing (..)

import ElmTest exposing (..)
import Tests.Configuration


tests : Test
tests =
    suite "Chameleon-hue Unit Tests"
        [ Tests.Configuration.tests
        ]


main : Program Never
main =
    runSuite tests
