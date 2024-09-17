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

context materials {

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
        Supplier         : Association to sales.Suppliers;
        // Supplier_Id      : UUID; // Association no administrada
        // ToSupplier : Association to one Suppliers on ToSupplier.ID = Supplier_Id;  // Association no administrada
        DimensionUnit    : Association to DimensionUnits; //_Id : String;
        SaleData         : Association to many sales.SalesData
                               on SaleData.Product = $self;
        Review           : Association to many ProductReview
                               on Review.Product = $self;
    //  createdAt        : Timestamp  @cds.on.insert: $now;
    //  createdBy        : User       @cds.on.insert: $user;
    //  modifiedAt       : Timestamp  @cds.on.insert: $now   @cds.on.update: $now;
    //  modifiedBy       : User       @cds.on.insert: $user  @cds.on.update: $user;
    };

    entity Categories {

        key ID   : String(1);
            Name : localized String;


    };

    entity StockAvailability {
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

    entity DimensionUnits {
        key ID          : String(2);
            Description : localized String;
    };


    entity ProductReview : cuid, managed {
        //key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to materials.Products;

    };

};

context sales {
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
        Product  : Association to materials.Products;
        Quantity : Integer

    };

    entity Suppliers : cuid, managed {
        // key ID         : UUID;
        Name               : String; // type of Products:Name
        address_Street     : String;
        address_City       : String;
        address_State      : String(2);
        address_PostalCode : String(5);
        address_Country    : String(3);
        Email              : String;
        Phone              : String;
        Fax                : String;
        Product            : Association to many materials.Products
                                 on Product.Supplier = $self;

    };


    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(3);
    };

    entity SalesData : cuid, managed {
        // key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to Months;
    // createdAt     : Date;
    // createdBy     : String;
    // modifiedAt    : Date;
    // modifiedBy    : String;
    };

};

context reports {

    entity AverageRating as
        select from logali.materials.ProductReview {
            Product.ID  as ProductId,
            avg(Rating) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;

    entity Products      as
        select from logali.materials.Products
        mixin {
            ToStockAvailability : Association to logali.materials.StockAvailability
                                      on ToStockAvailability.ID = $projection.StockAvailability;
            ToAverageRating     : Association to AverageRating
                                      on ToAverageRating.ProductId = ID
        }
        into {
            *,
            ToAverageRating.AverageRating as Rating,
            case
                when
                    Quantity >= 8
                then
                    3
                when
                    Quantity > 0
                then
                    2
                else
                    1
            end                           as StockAvailability : Integer,
            ToStockAvailability
        }
}


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


entity SelProducts   as select from materials.Products;

entity SelProducts1  as
    select from materials.Products {
        Name,
        Description,
        Price,
        Quantity
    };

entity SelProducts2  as
    select from materials.Products {
        *
    };

entity SelProducts3  as
    select from materials.Products
    left join materials.ProductReview
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

//entity ProjProducts1 as projection on materials.Products {};

entity ProjProducts2 as
    projection on materials.Products {
        *
    };

entity ProjProducts3 as
    projection on materials.Products {
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


extend materials.Products with {
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
