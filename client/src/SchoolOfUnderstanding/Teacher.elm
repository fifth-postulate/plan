module SchoolOfUnderstanding.Teacher exposing (Teacher, TeacherIdentity)

{-| Teacher

> one whose occupation is to instruct.

# Types
@ docs Teacher, TeacherIdentity
-}

import SchoolOfUnderstanding.Slot exposing (Weekday)
import SchoolOfUnderstanding.Subject exposing (Subject)

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

