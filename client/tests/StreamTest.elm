module StreamTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Stream
import Test exposing (..)


suite : Test
suite =
    describe "the Stream module"
        [ describe "constructors"
            [ test "toList of empty stream results in an empty list" <|
                \_ ->
                    let
                        stream =
                            Stream.empty

                        elements =
                            Stream.toList stream
                    in
                    Expect.equal elements []
            , test "toList of a stream created from a list, returns that list" <|
                \_ ->
                    let
                        original =
                            [ 1, 2, 3 ]

                        stream =
                            Stream.fromList original

                        elements =
                            Stream.toList stream
                    in
                    Expect.equal elements original
            ]
        , describe "building Streams"
            [ test "inserting elements creates a correct stream" <|
                \_ ->
                    let
                        stream =
                            Stream.empty
                                |> Stream.insert 1
                                |> Stream.insert 2
                                |> Stream.insert 3

                        elements =
                            Stream.toList stream
                    in
                    Expect.equal elements [ 1, 2, 3 ]
            ]
        , describe "queries"
            [ test "isEmpty of empty stream" <|
                \_ ->
                    let
                        stream =
                            Stream.empty

                        isEmpty =
                            Stream.isEmpty stream
                    in
                    Expect.true "expected an empty stream to be empty" isEmpty
            , fuzz int "isEmpty of non empty stream" <|
                \n ->
                    let
                        stream =
                            Stream.empty
                                |> Stream.insert n

                        isEmpty =
                            Stream.isEmpty stream
                    in
                    Expect.false "expected an non empty stream to be non empty" isEmpty
            ]
        , describe "operation"
            [ test "advance a stream correctly" <|
                \_ ->
                    let
                        actual =
                            [ 1, 2, 3, 4, 5 ]
                                |> Stream.fromList
                                |> Stream.advance
                                |> Stream.advance

                        expected =
                            Stream.fromList [ 3, 4, 5 ]
                                |> Stream.withHistory [ 1, 2 ]
                    in
                    Expect.equal actual expected
            , test "retrograde a stream correctly" <|
                \_ ->
                    let
                        actual =
                            [3, 4, 5]
                                |> Stream.fromList
                                |> Stream.withHistory [ 1, 2 ]
                                |> Stream.retrograde
                                |> Stream.retrograde
                                |> Stream.peek

                        expected =
                            [ 1, 2, 3, 4, 5 ]
                                |> Stream.fromList
                                |> Stream.peek

                    in
                    Expect.equal actual expected
            ]
        , describe "conversions"
            [ fuzz (list int) "fromList and toList are inverse operations" <|
                \original ->
                    let
                        stream =
                            Stream.fromList original

                        elements =
                            Stream.toList stream
                    in
                    Expect.equal elements original
            ]
        ]
