namespace com.logali;

using {
    cuid,
    managed
//User
} from '@sap/cds/common';


define type Name : String(20);

// define type Name1 : String(20);
//  Address {
//     Street     : String;
//    City       : String;
//     State      : String(2);
//     PostalCode : String(5);
//     Country    : String(3);
// };

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

entity Products : cuid, managed {
    // key ID               : UUID;
    Name             : localized String NOT null; // default 'NoName'; Localized es la traducción
    Description      : localized String;
    ImageUrl         : String;
    ReleaseDate      : DateTime default $now;
    //  CreationDate     : Date default CURRENT_DATE;
    DiscontinuedDate : DateTime;
    Price            : Decimal(16, 2);
    Height           : Decimal(16, 2); // type of Price tipo referenciado
    Width            : Decimal(16, 2);
    Depth            : Decimal(16, 2);
    Quantity         : Decimal(16, 2);
    UnitOfMeasure    : Association to UnitOfMeasures;
    //  UnitOfMeasure_Id : String(2); // Association no administrada
    //  ToUnitOfMeasure  : Association to UnitMeasures
    //                          on ToUnitOfMeasure.ID = UnitOfMeasure_Id; // Association no administrada
    Currency         : Association to Currencies; //_Id      : String;
    Category         : Association to Categories; //_Id      : String;
    Supplier         : Association to Suppliers;
    // Supplier_Id      : UUID; // Association no administrada
    // ToSupplier : Association to one Suppliers on ToSupplier.ID = Supplier_Id;  // Association no administrada
    DimensionUnit    : Association to DimensionUnit; //_Id : String;
    ToSaleData       : Association to many SalesData
                           on ToSaleData.Product = $self;
    ToReview         : Association to many ProductReview
                           on ToReview.Product = $self;
//  createdAt        : Timestamp  @cds.on.insert: $now;
//  createdBy        : User       @cds.on.insert: $user;
//  modifiedAt       : Timestamp  @cds.on.insert: $now   @cds.on.update: $now;
//  modifiedBy       : User       @cds.on.insert: $user  @cds.on.update: $user;
};

//Composición - agrega acción para eliminar en cascada los registros que componene a la entidad
entity Orders : cuid {
    //  key ID       : UUID;
    Date     : Date;
    Customer : String;
    Item     : Composition of many OrderItems
                   on Item.Order = $self;
};

entity OrderItems : cuid {
    //  key ID       : UUID;
    Order    : Association to Orders;
    Product  : Association to Products;
    Quantity : Integer

};

entity Suppliers : cuid, managed {
    // key ID         : UUID;
    Name       : String; // type of Products:Name
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
    Email      : String;
    Phonot     : String;
    Fax        : String;
    ToProduct  : Association to many Products
                     on ToProduct.Supplier = $self;

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

entity Categories {

    key ID   : String(1);
        Name : localized String;
};

entity Stock {
    key ID          : Integer;
        Description : localized String;
        Product     : Association to Products;
};

entity Currencies {
    key ID          : String(3);
        Description : localized String;
};

entity UnitOfMeasures {
    key ID          : String(2);
        Description : localized String;
};

entity DimensionUnit {
    key ID          : String(2);
        Description : localized String;
};

entity Months {
    key ID               : String(2);
        Description      : localized String;
        ShortDescription : localized String(3);
};

entity ProductReview : cuid, managed {
    //key ID      : UUID;
    Name    : String;
    Rating  : Integer;
    commnet : String;
    Product : Association to Products;
};

entity SalesData : cuid, managed {
    // key ID            : UUID;
    DeliveriDate  : DateTime;
    Revenue       : Decimal(16, 2);
    Product       : Association to Products;
    Currency      : Association to Currencies;
    DeliveryMonth : Association to Months;
};

entity SelProducts   as select from Products;

entity SelProducts1  as
    select from Products {
        Name,
        Description,
        Price,
        Quantity
    };

entity SelProducts2  as
    select from Products {
        *
    };

entity SelProducts3  as
    select from Products
    left join ProductReview
        on Products.Name = ProductReview.Name
    {
        Products.Name,
        sum(Price) as TotalPrice,


    }
    group by
        Rating,
        Products.Name
    order by
        ProductReview.Rating;

entity ProjProducts1 as projection on Products {};

entity ProjProducts2 as
    projection on Products {
        *
    };

entity ProjProducts3 as
    projection on Products {
        ReleaseDate,
        Name

    };
//Solo se puede tener entidades con parámetros en hana, sqlite no los soporta
// entity ParamProducts(pName : String)     as
//     select
//         Name,
//         Price,
//         Quantity
//     from Products
//     where
//         Name = :pName;


// entity ProjParamProducts(pName : String) as projection on Products
//                                             where
//                                                 Name = :pName;


extend Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3)
};

//Muchos a muchos
entity Course {
    key ID        : UUID;
        ToStudent : Association to many StudenCourse
                        on ToStudent.Course = $self;
};

entity Student {
    key ID       : UUID;
        ToCourse : Association to many StudenCourse
                       on ToCourse.Student = $self;
};

entity StudenCourse {

    key ID      : UUID;
        Student : Association to Student;
        Course  : Association to Course;
}
