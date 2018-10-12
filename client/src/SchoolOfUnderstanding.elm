module SchoolOfUnderstanding exposing (Dict, Group, GroupIdentity, Level(..), Student, StudentIdentity)

{-| The module defines various types that module the planning problem of the [School of Understanding](https://www.schoolofunderstanding.nl/).
-}

import Dict.Any exposing (AnyDict)
import SchoolOfUnderstanding.Slot exposing (Slot, Slots, TimeOfDay, Weekday)
import SchoolOfUnderstanding.Subject exposing (Subject, SubjectIdentity)
import SchoolOfUnderstanding.Teacher exposing (Teacher, TeacherIdentity)

type alias Dict k v =
    AnyDict Int k v


{-| A `Group` is the collective `Level` of a collection of `Student`s in a certain `Subject`.
-}
type alias Group =
    { identity : GroupIdentity
    , subject : Subject
    , level : Level
    , lessonsNeeded : Int
    }


{-| A means to identify a group.
-}
type GroupIdentity
    = GroupIdentity Int


{-| A way to express the experience of a group.
-}
type Level
    = Level Int


{-| A `Student` is person enrolled in the School of Understanding.
-}
type alias Student =
    { identity : StudentIdentity
    , memberships : Dict Subject GroupIdentity
    }


type StudentIdentity
    = StudentIdentity { studentNumber : Int }
