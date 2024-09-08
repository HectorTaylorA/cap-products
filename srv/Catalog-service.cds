using {com.logali as logali} from '../db/schema';


service CatalogService {

    entity Products       as projection on logali.Products;
    entity Suppliers      as projection on logali.Suppliers;
    entity Car            as projection on logali.Car;
    entity UnitOfMeasures as projection on logali.UnitOfMeasures;
    entity Currency       as projection on logali.Currencies;
    entity DimensionUnit  as projection on logali.DimensionUnit;
    entity Category       as projection on logali.Categories;
    entity SalesData      as projection on logali.SalesData;
    entity Review         as projection on logali.ProductReview;
    entity Months         as projection on logali.Months;
    entity Order          as projection on logali.Orders;
    entity OrderItem      as projection on logali.OrderItems;
//entity Suppliers02 as projection on logali.Suppliers02;


};


define service CatalogService2 {
    entity Products2 as
        select from logali.Products {
            ID,
            Name          as ProductName     @mandatory,
            Description                      @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                            @mandatory,
            Height,
            Width,
            Depth,
            Quantity,
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency                         @mandatory,
            Category      as toCategory      @mandatory,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit @mandatory,
            ToSaleData,
            Supplier,
            ToReview,


        };

}
