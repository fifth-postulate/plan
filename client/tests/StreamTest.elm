module StreamTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Stream
import Test exposing (..)


suite : Test
suite =
    describe "the Stream module"
        [ describe "constructor"
            [ test "toList of empty stream results in an empty list"
                <| (\_ ->
                        let
                            stream =
                                Stream.empty

                            elements =
                                Stream.toList stream
                        in
                        Expect.equal elements []
                   )
            ]
        ]
