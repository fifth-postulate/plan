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


{-| Teacher, capable of teaching subjects on certain weekdays.
-}
type alias Teacher =
    { identity : TeacherIdentity
    , capabilities : List Subject
    , availabilities : List Weekday
    }


{-| A means to identify a teacher.
-}
type TeacherIdentity
    = TeacherIdentity { nickname : String }
