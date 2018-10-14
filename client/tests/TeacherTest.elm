module TeacherTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode as Encode
import SchoolOfUnderstanding.Slot exposing (Weekday(..))
import SchoolOfUnderstanding.Subject exposing (subject)
import SchoolOfUnderstanding.Teacher as Teacher exposing (teacher, canTeach, isAvailableOn)
import Test exposing (..)


suite : Test
suite =
    describe "encoding & decoding"
        [ describe "encoding"
            [ test "of teacher should produce correct JSON" <|
                \_ ->
                    let
                        aTeacher =
                            teacher "Alice"
                                |> canTeach
                                    [ subject "Math"
                                    ]
                                |> isAvailableOn
                                    [ Monday
                                    , Wednesday
                                    ]

                        encoding =
                            aTeacher
                                |> Teacher.encode
                                |> Encode.encode 0
                    in
                    Expect.equal encoding """{"identity":{"nickname":"Alice"},"capabilities":[{"identity":"Math"}],"availabilities":["monday","wednesday"]}"""
            ]
        ]
