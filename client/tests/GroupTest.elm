module GroupTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode as Encode
import SchoolOfUnderstanding.Group as Group exposing (group, lessons, level)
import SchoolOfUnderstanding.Subject exposing (subject)
import Test exposing (..)


suite : Test
suite =
    describe "encoding & decoding"
        [ describe "encoding"
            [ test "of group should produce correct JSON" <|
                \_ ->
                    let
                        aGroup =
                            group 37 (subject "Grammar") (level 7) (lessons 3)

                        encoding =
                            aGroup
                                |> Group.encode
                                |> Encode.encode 0
                    in
                    Expect.equal encoding """{"identity":{"groupNumber":37},"subject":{"identity":"Grammar"},"level":7,"lessonsNeeded":3}"""
            ]
        ]
