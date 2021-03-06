module StudentTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode as Encode
import SchoolOfUnderstanding.Group exposing (group, lessons, level)
import SchoolOfUnderstanding.Student as Student exposing (memberOf, student)
import SchoolOfUnderstanding.Subject exposing (subject)
import Test exposing (..)


suite : Test
suite =
    describe "encoding & decoding"
        [ describe "encoding"
            [ test "of student should produce correct JSON" <|
                \_ ->
                    let
                        aStudent =
                            student 3435
                                |> memberOf
                                    [ group 37 (subject "Math") (level 3) (lessons 2)
                                    , group 51 (subject "Spelling") (level 5) (lessons 4)
                                    ]

                        encoding =
                            aStudent
                                |> Student.encode
                                |> Encode.encode 0
                    in
                    Expect.equal encoding """{"identity":{"studentNumber":3435},"memberships":[{"groupNumber":37},{"groupNumber":51}]}"""
            ]
        ]
