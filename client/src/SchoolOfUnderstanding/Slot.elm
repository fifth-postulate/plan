module SchoolOfUnderstanding.Slot exposing (Weekday(..), Slots, Slot, TimeOfDay)

{-| This module deals with `Slot`s.


# Types

@docs Weekday, Slots, Slot, TimeOfDay

-}

import Dict.Any exposing (AnyDict)


type alias Dict k v =
    AnyDict Int k v


{-| Days of the week.
-}
type Weekday
    = Monday
    | Tuesday
    | Wednesday
    | Thursday
    | Friday
    | Saterday
    | Sunday


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
