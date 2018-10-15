module PlanTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode as Encode
import Plan exposing (problem)
import SchoolOfUnderstanding.Group exposing (group, lessons, level)
import SchoolOfUnderstanding.Slot exposing (Weekday(..), emptySlots, insert, slot, time)
import SchoolOfUnderstanding.Student exposing (memberOf, student)
import SchoolOfUnderstanding.Subject exposing (subject)
import SchoolOfUnderstanding.Teacher exposing (canTeach, isAvailableOn, teacher)
import Test exposing (..)


suite : Test
suite =
    describe "encoding & decoding"
        [ describe "encoding"
            [ test "of student should produce correct JSON" <|
                \_ ->
                    let
                        slots =
                            emptySlots
                                |> insert Monday
                                    [ slot { start = time 8 30, finish = time 9 15 }
                                    , slot { start = time 9 30, finish = time 10 15 }
                                    , slot { start = time 10 30, finish = time 11 15 }
                                    ]
                                |> insert Wednesday
                                    [ slot { start = time 8 30, finish = time 9 15 }
                                    , slot { start = time 9 30, finish = time 10 15 }
                                    , slot { start = time 10 30, finish = time 11 15 }
                                    ]
                                |> insert Thursday
                                    [ slot { start = time 8 30, finish = time 9 15 }
                                    , slot { start = time 9 30, finish = time 10 15 }
                                    , slot { start = time 10 30, finish = time 11 15 }
                                    ]

                        groups =
                            [ group 37 (subject "Math") (level 3) (lessons 2)
                            , group 51 (subject "Spelling") (level 5) (lessons 4)
                            , group 42 (subject "Math") (level 5) (lessons 1)
                            , group 51 (subject "Spelling") (level 5) (lessons 4)
                            ]

                        teachers =
                            [ teacher "Alice"
                                |> canTeach
                                    [ subject "Math"
                                    ]
                                |> isAvailableOn
                                    [ Monday
                                    , Wednesday
                                    ]
                            , teacher "Babs"
                                |> canTeach
                                    [ subject "Spelling"
                                    ]
                                |> isAvailableOn
                                    [ Tuesday
                                    , Wednesday
                                    , Thursday
                                    ]
                            ]

                        students =
                            [ student 3435
                                |> memberOf
                                    [ group 37 (subject "Math") (level 3) (lessons 2)
                                    , group 51 (subject "Spelling") (level 5) (lessons 4)
                                    ]
                            , student 1729
                                |> memberOf
                                    [ group 42 (subject "Math") (level 5) (lessons 1)
                                    , group 51 (subject "Spelling") (level 5) (lessons 4)
                                    ]
                            ]

                        aProblem =
                            problem slots groups teachers students

                        encoding =
                            aProblem
                                |> Plan.encode
                                |> Encode.encode 0
                    in
                    Expect.equal encoding """{"availableSlots":{"monday":[{"start":{"hour":8,"minutes":30},"finish":{"hour":9,"minutes":15}},{"start":{"hour":9,"minutes":30},"finish":{"hour":10,"minutes":15}},{"start":{"hour":10,"minutes":30},"finish":{"hour":11,"minutes":15}}],"wednesday":[{"start":{"hour":8,"minutes":30},"finish":{"hour":9,"minutes":15}},{"start":{"hour":9,"minutes":30},"finish":{"hour":10,"minutes":15}},{"start":{"hour":10,"minutes":30},"finish":{"hour":11,"minutes":15}}],"thursday":[{"start":{"hour":8,"minutes":30},"finish":{"hour":9,"minutes":15}},{"start":{"hour":9,"minutes":30},"finish":{"hour":10,"minutes":15}},{"start":{"hour":10,"minutes":30},"finish":{"hour":11,"minutes":15}}]},"groupsToTeach":[{"identity":{"groupNumber":37},"subject":{"identity":"Math"},"level":3,"lessonsNeeded":2},{"identity":{"groupNumber":51},"subject":{"identity":"Spelling"},"level":5,"lessonsNeeded":4},{"identity":{"groupNumber":42},"subject":{"identity":"Math"},"level":5,"lessonsNeeded":1},{"identity":{"groupNumber":51},"subject":{"identity":"Spelling"},"level":5,"lessonsNeeded":4}],"availableTeachers":[{"identity":{"nickname":"Alice"},"capabilities":[{"identity":"Math"}],"availabilities":["monday","wednesday"]},{"identity":{"nickname":"Babs"},"capabilities":[{"identity":"Spelling"}],"availabilities":["tuesday","wednesday","thursday"]}],"participatingStudents":[{"identity":{"studentNumber":3435},"memberships":{"Math":{"groupNumber":37},"Spelling":{"groupNumber":51}}},{"identity":{"studentNumber":1729},"memberships":{"Math":{"groupNumber":42},"Spelling":{"groupNumber":51}}}]}"""
            ]
        ]
