namespace com.logali;

define type Name : String(20);

define type Name : String(20);
 Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

// type Gender      : String enum {
//     male;
//     female;
// };

// entity Order {
//     ClienteGender : Gender;
//     Status        : Integer enum {
//         submitted = 1;
//         fulfiller = 2;
//         shipped   = 3;
//         cancel    = 4;
//     };
//     priority      : String @assert.range enum {
//         high;
//         medium;
//         low;
//     }
// };

// type EmailAddresses01 : array of {
//     kind  : String;
//     email : String;
// };

// type EmailAddresses02 : array of {
//     kind  : String;
//     email : String;


// };

// entity Email {
//     email_01 :      EmailAddresses01;
//     email_02 : many EmailAddresses02;
//     email_03 : many {
//         kind  : String;
//         email : String;
//     }

entity Car {
    key ID                : UUID;
        Name              : String;
        virtual Discount1 : Decimal; // Elemento virtual que no se guarda en la base de datos
        @Core.Computed: false // Permite enviar datos desde el cliente
        virtual Discount2 : Decimal; // Elemento virtual que no se guarda en la base de datos
};

entity Products {
    key ID               : UUID;
        Name             : String NOT null; // default 'NoName';
        Description      : String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        //  CreationDate     : Date default CURRENT_DATE;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        Height           : Decimal(16, 2); // type of Price tipo referenciado
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        UnitOfMeasure_Id : String;
        Currency_Id      : String;
        Category_Id      : String;
        Supplier_Id      : String;
        DimensionUnit_Id : String;
};

entity Suppliers {
    key ID         : UUID;
        Name       : String; // type of Products:Name
        Street     : String;
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
        Email      : String;
        Phonot     : String;
        Fax        : String;

};

// entity Suppliers01 {
//     key ID      : UUID;
//         Name    : String;
//         Address : Address;
//         Email   : String;
//         Phonot  : String;
//         Fax     : String;

// };

// entity Suppliers02 {
//     key ID      : UUID;
//         Name    : String;
//         Address : {
//             Street     : String;
//             City       : String;
//             State      : String(2);
//             PostalCode : String(5);
//             Country    : String(3);
//         };
//         Email   : String;
//         Phonot  : String;
//         Fax     : String;

// };

entity Categoris {

    key ID   : String(1);
        Name : String;
};

entity Stock {
    key ID          : Integer;
        Description : String;
};

entity Currency {
    key ID          : String(3);
        Description : String;
};

entity UnitMeasures {
    key ID          : String(2);
        Description : String;
};

entity DimensionUnit {
    key ID          : String(2);
        Description : String;
};

entity Months {
    key ID               : String(2);
        Description      : String;
        ShortDescription : String(3);
};

entity ProductReview {
    key Name    : String;
        Reting  : Integer;
        commnet : String;
};

entity SalesData {
    key ID           : UUID;
        DeliveriDate : DateTime;
        Revenue      : Decimal(16, 2);
}
