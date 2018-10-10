module SchoolOfUnderstanding exposing (Weekday(..))

{-| The module defines various types that module the planning problem of the [School of Understanding](https://www.schoolofunderstanding.nl/).
-}


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


{-| Subjects taught in the School of Understanding.
-}
type Subject
    = Grammar
    | Spelling
    | Math
