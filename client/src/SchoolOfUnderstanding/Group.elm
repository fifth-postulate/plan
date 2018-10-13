module SchoolOfUnderstanding.Group exposing (Group, GroupIdentity, Level)

{-| A `Group` is a collection of `Student`s studying a `Subject` at a certain level.


# Types

@docs Group, GroupIdentity, Level

-}

import SchoolOfUnderstanding.Subject exposing (Subject)

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
