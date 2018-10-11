module SchoolOfUnderstanding exposing (Dict, Group, GroupIdentity, Level(..), Slot, Slots, Student, StudentIdentity, Subject(..), SubjectIdentity, Teacher, TeacherIdentity, TimeOfDay, Weekday(..))

{-| The module defines various types that module the planning problem of the [School of Understanding](https://www.schoolofunderstanding.nl/).
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


{-| Subjects taught in the School of Understanding.
-}
type Subject
    = Subject { identity : SubjectIdentity }


{-| A means to identify a subject.
-}
type SubjectIdentity
    = SubjectIdentity { name : String }


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
