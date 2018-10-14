module SchoolOfUnderstanding.Subject exposing
    ( Subject, SubjectIdentity
    , subject
    , encode
    )

{-| Subject

> a department of knowledge or learning.


# Types

@docs Subject, SubjectIdentity


# Building

@docs subject


# Encoding

@docs encode

-}

import Json.Encode as Encode


{-| Subjects taught in the School of Understanding.
-}
type Subject
    = Subject SubjectIdentity


{-| A means to identify a subject.
-}
type SubjectIdentity
    = SubjectIdentity String


{-| Create a `Subject` from a name.
-}
subject : String -> Subject
subject name =
    let
        identity =
            SubjectIdentity name
    in
    Subject identity


{-| Encodes a `Subject` into a `Json.Encode.Value`.
-}
encode : Subject -> Encode.Value
encode (Subject (SubjectIdentity identity)) =
    Encode.object [ ( "identity", Encode.string identity ) ]
