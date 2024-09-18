namespace com.training;

using {
    cuid,
    Country
} from '@sap/cds/common';


entity Course : cuid {
    Student : Association to many StudenCourse
                  on Student.Course = $self;
}

entity Student : cuid {
    Course : Association to many StudenCourse
                 on Course.Stundent = $self;
}

entity StudenCourse : cuid {
    Stundent : Association to Student;
    Course   : Association to Course;
}


entity Orders {
    key ClientEmail : String(65);
        FirstName   : String(30);
        LastName    : String(30);
        CreatedOn   : Date;
        Reviewed    : Boolean;
        Approved    : Boolean;
        Country     : Country;
        Status      : String(1);
}
