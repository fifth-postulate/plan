module Problem exposing (problemDefinition)

import Plan exposing (problem)
import SchoolOfUnderstanding.Group exposing (group, lessons, level)
import SchoolOfUnderstanding.Slot exposing (Weekday(..), emptySlots, insert, slot, time)
import SchoolOfUnderstanding.Student exposing (memberOf, student)
import SchoolOfUnderstanding.Subject exposing (subject)
import SchoolOfUnderstanding.Teacher exposing (canTeach, isAvailableOn, teacher)


problemDefinition =
    problem
        (emptySlots
            |> insert Monday
                [ slot { start = time 8 30, finish = time 9 15 }
                , slot { start = time 9 30, finish = time 10 15 }
                , slot { start = time 10 30, finish = time 11 15 }
                ]
            |> insert Wednesday
                [ slot { start = time 8 30, finish = time 9 15 }
                , slot { start = time 9 30, finish = time 10 15 }
                , slot { start = time 10 30, finish = time 11 15 }
                ]
            |> insert Thursday
                [ slot { start = time 8 30, finish = time 9 15 }
                , slot { start = time 9 30, finish = time 10 15 }
                , slot { start = time 10 30, finish = time 11 15 }
                ]
        )
        [ group 37 (subject "Math") (level 3) (lessons 2)
        , group 51 (subject "Spelling") (level 5) (lessons 4)
        , group 42 (subject "Math") (level 5) (lessons 1)
        , group 51 (subject "Spelling") (level 5) (lessons 4)
        ]
        [ teacher "Alice"
            |> canTeach
                [ subject "Math"
                ]
            |> isAvailableOn
                [ Monday
                , Wednesday
                ]
        , teacher "Babs"
            |> canTeach
                [ subject "Spelling"
                ]
            |> isAvailableOn
                [ Tuesday
                , Wednesday
                , Thursday
                ]
        ]
        [ student 3435
            |> memberOf
                [ group 37 (subject "Math") (level 3) (lessons 2)
                , group 51 (subject "Spelling") (level 5) (lessons 4)
                ]
        , student 1729
            |> memberOf
                [ group 42 (subject "Math") (level 5) (lessons 1)
                , group 51 (subject "Spelling") (level 5) (lessons 4)
                ]
        ]
