module SlotTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode as Encode
import SchoolOfUnderstanding.Slot as Slot exposing (Weekday(..), emptySlots, insert, slot, time)
import Test exposing (..)


suite : Test
suite =
    describe "encoding & decoding"
        [ describe "encoding"
            [ test "of slots should produce correct JSON" <|
                \_ ->
                    let
                        slots =
                            emptySlots
                                |> insert Monday
                                    [ slot { start = time 8 30, finish = time 9 15 }
                                    ]

                        encoding =
                            slots
                                |> Slot.encode
                                |> Encode.encode 0
                    in
                    Expect.equal encoding """{"monday":[{"start":{"hour":8,"minutes":30},"finish":{"hour":9,"minutes":15}}]}"""
            ]
        ]
