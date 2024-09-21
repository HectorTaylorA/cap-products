using {com.logali as logali} from '../db/schema';


// service CatalogService {

//     entity Products       as projection on logali.materials.Products;
//     entity Suppliers      as projection on logali.sales.Suppliers;
//     //entity Car            as projection on logali.Car;
//     entity UnitOfMeasures as projection on logali.materials.UnitOfMeasures;
//     entity Currency       as projection on logali.materials.Currencies;
//     entity DimensionUnit  as projection on logali.materials.DimensionUnit;
//     entity Category       as projection on logali.materials.Categories;
//     entity SalesData      as projection on logali.sales.SalesData;
//     entity Review         as projection on logali.materials.ProductReview;
//     entity Months         as projection on logali.sales.Months;
//     entity Order          as projection on logali.sales.Orders;
//     entity OrderItem      as projection on logali.sales.OrderItems;
// //entity Suppliers02 as projection on logali.Suppliers02;


// };

define service CatalogService {
    entity Products          as
        select from logali.materials.Products {
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
            Quantity                         @(
                mandatory,
                assert.range: [
                    0.00,
                    20
                ]
            ),
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency      @mandatory,
            Category      as ToCategory      @mandatory,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit @mandatory,
            SaleData,
            Supplier,
            Review,
        //  Rating,
        //  StockAvailability ,
        //  ToStockAvailability
        };

    @readonly
    entity Supplier          as
        select from logali.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct

        };

    entity Reviews           as
        select from logali.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from logali.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct

        };

    @readonly
    entity StockAvailability as
        select from logali.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct

        };

    @readonly
    entity VH_Categories     as
        select from logali.materials.Categories {
            ID   as Code,
            Name as Text

        };

    @readonly
    entity VH_Currencies     as
        select from logali.materials.Currencies {
            ID          as Code,
            Description as Text

        };

    @readonly
    entity VH_UnitOfMasure   as
        select from logali.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text

        };

    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from logali.materials.DimensionUnits


};

define service MyService {

    entity EntityInfix     as
        select Supplier[Name = 'Exotic Liquids'].Phone from logali.materials.Products
        where
            Products.Name = 'Bread';

    entity SupplierProduct as
        select from logali.materials.Products[Name = 'Bread']{
            *,
            Name,
            Description,
            Supplier.address_Street
        }
        where
            Supplier.address_PostalCode = 98074;


};

define service Reports {


    entity EntityCasting as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as Price2 : Integer
        from logali.materials.Products;

    entity AverageRating as projection on logali.reports.AverageRating;
//  entity Products      as projection on logali.reports.Products;


}
