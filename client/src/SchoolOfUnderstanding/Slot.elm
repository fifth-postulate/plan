module SchoolOfUnderstanding.Slot exposing
    ( Weekday(..), Slots, Slot, TimeOfDay
    , encode, encodeWeekday
    , emptySlots, insert, slot, time
    )

{-| This module deals with `Slot`s.


# Types

@docs Weekday, Slots, Slot, TimeOfDay


# Building

@ docs emptySlots, insert, slot, time


# Encoding

@docs encode, encodeWeekday

-}

import Json.Encode as Encode
import SchoolOfUnderstanding as School exposing (Dict)


{-| Days of the week.
-}
type Weekday
    = Monday
    | Tuesday
    | Wednesday
    | Thursday
    | Friday
    | Saturday
    | Sunday


{-| Convert `Weekday` to `Int` for the use with `Dict.Any`.
-}
weekdayToInt : Weekday -> Int
weekdayToInt weekday =
    case weekday of
        Monday ->
            0

        Tuesday ->
            1

        Wednesday ->
            2

        Thursday ->
            3

        Friday ->
            4

        Saturday ->
            5

        Sunday ->
            6


{-| Return a `String` representation of `Weekday`
-}
weekdayToString : Weekday -> String
weekdayToString weekday =
    case weekday of
        Monday ->
            "monday"

        Tuesday ->
            "tuesday"

        Wednesday ->
            "wednesday"

        Thursday ->
            "thursday"

        Friday ->
            "friday"

        Saturday ->
            "saturday"

        Sunday ->
            "sunday"


{-| Available `Slot`s per `Weekday`
-}
type alias Slots =
    Dict Weekday (List Slot)


{-| A `Slot` is a period in which a `Teacher` teaches a `Subject` to a `Group`.
-}
type alias Slot =
    { start : TimeOfDay, finish : TimeOfDay }


{-| A particular moment of time.
-}
type alias TimeOfDay =
    { hour : Int
    , minutes : Int
    }


{-| Create an empty `Slots`.
-}
emptySlots : Slots
emptySlots =
    School.empty weekdayToInt


{-| Insert a `Slot` on a certain `Weekday` into a `Slots`.
-}
insert : Weekday -> List Slot -> Slots -> Slots
insert weekday list slots =
    slots
        |> School.insert weekday list


{-| Returns a `Slot` given start and finish.
-}
slot : { start : TimeOfDay, finish : TimeOfDay } -> Slot
slot { start, finish } =
    Slot start finish


{-| Returns a `TimeOfDay` given hour and minutes.
-}
time : Int -> Int -> TimeOfDay
time hour minutes =
    { hour = hour, minutes = minutes }


{-| Encodes a `Slots` into a `Json.Encode.Value`
-}
encode : Slots -> Encode.Value
encode dictionary =
    let
        key weekday =
            weekday
                |> weekdayToString

        value list =
            list
                |> Encode.list encodeSlot

        collect weekday list accumulator =
            ( key weekday, value list ) :: accumulator
    in
    dictionary
        |> School.foldr collect []
        |> Encode.object


{-| Encodes a `Slot` into a `Json.Encode.Value`.
-}
encodeSlot : Slot -> Encode.Value
encodeSlot { start, finish } =
    [ ( "start", encodeTimeOfDay start )
    , ( "finish", encodeTimeOfDay finish )
    ]
        |> Encode.object


{-| Encode a `TimeOfDay` into a `Json.Encode.Value`.
-}
encodeTimeOfDay : TimeOfDay -> Encode.Value
encodeTimeOfDay { hour, minutes } =
    [ ( "hour", Encode.int hour )
    , ( "minutes", Encode.int minutes )
    ]
        |> Encode.object


{-| Encode a `Weekday` into a `Json.Encode.Value`.
-}
encodeWeekday : Weekday -> Encode.Value
encodeWeekday weekday =
    weekday
        |> weekdayToString
        |> Encode.string
