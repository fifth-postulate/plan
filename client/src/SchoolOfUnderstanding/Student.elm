module SchoolOfUnderstanding.Student exposing (Student, StudentIdentity)

{-| Module provides student related functionality.


# Types

@docs Student, StudentIdentity

-}

import Dict.Any exposing (AnyDict)
import SchoolOfUnderstanding.Group exposing (GroupIdentity)
import SchoolOfUnderstanding.Subject exposing (Subject)

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
