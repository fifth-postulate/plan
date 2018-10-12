module SchoolOfUnderstanding.Subject exposing (Subject, SubjectIdentity)

{-| Subject

> a department of knowledge or learning.


# Types

@docs Subject, SubjectIdentity

-}


{-| Subjects taught in the School of Understanding.
-}
type Subject
    = Subject { identity : SubjectIdentity }


{-| A means to identify a subject.
-}
type SubjectIdentity
    = SubjectIdentity { name : String }
