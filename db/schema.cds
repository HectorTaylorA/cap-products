namespace com.logali;

entity Products {

    key ID               : UUID;
        Name             : String;
        Description      : String;
        ImageUrl         : String;
        ReleaseDate      : DateTime;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        Height           : Decimal(16, 2);
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        UnitOfMeasure_Id : String;
        Currency_Id      : String;
        Category_Id      : String;
        Supplier_Id      : String;
        DimensionUnit_Id : String;
};

entity Supplier {
    key ID         : UUID;
        Name       : String;
        Street     : String;
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
        Email      : String;
        Phonot     : String;
        Fax        : String;

};

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
    key DeliveriDate : DateTime;
        Revenue      : Decimal(16, 2);
}
