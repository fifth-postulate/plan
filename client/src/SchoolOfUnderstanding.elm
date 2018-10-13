module SchoolOfUnderstanding exposing (Dict)

{-| The module defines various functionalities that model the planning problem of the [School of Understanding](https://www.schoolofunderstanding.nl/).
-}

import Dict.Any exposing (AnyDict)
import SchoolOfUnderstanding.Slot exposing (Slot, Slots, TimeOfDay, Weekday)
import SchoolOfUnderstanding.Subject exposing (Subject, SubjectIdentity)
import SchoolOfUnderstanding.Teacher exposing (Teacher, TeacherIdentity)
import SchoolOfUnderstanding.Group exposing (Group, GroupIdentity)
import SchoolOfUnderstanding.Student exposing (Student, StudentIdentity)

type alias Dict k v =
    AnyDict Int k v


