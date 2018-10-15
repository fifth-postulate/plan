module SchoolOfUnderstanding.Group exposing
    ( Group, GroupIdentity, Level
    , group, level, lessons
    , encode, encodeGroupIdentity
    )

{-| A `Group` is a collection of `Student`s studying a `Subject` at a certain level.


# Types

@docs Group, GroupIdentity, Level


# Building

@docs group, level, lessons


# Encoding

@docs encode, encodeGroupIdentity

-}

import Json.Encode as Encode
import SchoolOfUnderstanding.Subject as Subject exposing (Subject)


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


{-| Encode a `Group` into a `Json.Encode.Value`.
-}
encode : Group -> Encode.Value
encode aGroup =
    Encode.object
        [ ( "identity", encodeGroupIdentity aGroup.identity )
        , ( "subject", Subject.encode aGroup.subject )
        , ( "level", encodeLevel aGroup.level )
        , ( "lessonsNeeded", Encode.int aGroup.lessonsNeeded )
        ]


{-| Encodes a `GroupIdentity` into a `Json.Encode.Value`.
-}
encodeGroupIdentity : GroupIdentity -> Encode.Value
encodeGroupIdentity (GroupIdentity groupNumber) =
    Encode.object [ ( "groupNumber", Encode.int groupNumber ) ]


{-| Encode a `Level` into a `Json.Encode.Value`.
-}
encodeLevel : Level -> Encode.Value
encodeLevel (Level aLevel) =
    Encode.int aLevel


{-| Create a group, studying `Subject` on a certain `Level` needing a number of lessons.
-}
group : Int -> Subject -> Level -> Int -> Group
group id subject aLevel lessonsNeeded =
    let
        identity =
            GroupIdentity id
    in
    { identity = identity
    , subject = subject
    , level = aLevel
    , lessonsNeeded = lessonsNeeded
    }


{-| Create a `Level`.
-}
level : Int -> Level
level =
    Level


{-| Create a number of needed lessons.
-}
lessons : Int -> Int
lessons =
    identity
