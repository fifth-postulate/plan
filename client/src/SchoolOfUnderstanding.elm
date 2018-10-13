module SchoolOfUnderstanding exposing (Dict, Student, StudentIdentity)

{-| The module defines various types that module the planning problem of the [School of Understanding](https://www.schoolofunderstanding.nl/).
-}

import Dict.Any exposing (AnyDict)
import SchoolOfUnderstanding.Slot exposing (Slot, Slots, TimeOfDay, Weekday)
import SchoolOfUnderstanding.Subject exposing (Subject, SubjectIdentity)
import SchoolOfUnderstanding.Teacher exposing (Teacher, TeacherIdentity)
import SchoolOfUnderstanding.Group exposing (Group, GroupIdentity)

type alias Dict k v =
    AnyDict Int k v


{-| A `Student` is person enrolled in the School of Understanding.
-}
type alias Student =
    { identity : StudentIdentity
    , memberships : Dict Subject GroupIdentity
    }


type StudentIdentity
    = StudentIdentity { studentNumber : Int }
