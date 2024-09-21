using CatalogService as service from '../../srv/Catalog-service';

annotate service.Products with {
    ToCategory @title: 'Category';
    ToCurrency @title: 'Currency';
};

annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            /*    {
                    $Type: 'UI.DataField',
                    Label: 'ProductName',
                    Value: ProductName,
                },
                {
                    $Type: 'UI.DataField',
                    Label: 'Description',
                    Value: Description,
                },
                {
                    $Type: 'UI.DataField',
                    Label: 'ImageUrl',
                    Value: ImageUrl,
                },
                */
            {
                $Type: 'UI.DataField',
                Label: 'ReleaseDate',
                Value: ReleaseDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'DiscontinuedDate',
                Value: DiscontinuedDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Price',
                Value: Price,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Height',
                Value: Height,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Width',
                Value: Width,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Depth',
                Value: Depth,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Quantity',
                Value: Quantity,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ToUnitOfMeasure_ID',
                Value: ToUnitOfMeasure_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ToCurrency_ID',
                Value: ToCurrency_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ToCategory_ID',
                Value: ToCategory_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Category',
                Value: Category,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ToDimensionUnit_ID',
                Value: ToDimensionUnit_ID,
            },
        /*   {
               // $Type: 'UI.DataField',
               Label: 'Rating',
               Value: Rating,
                              $Type : 'UI.DataFieldForAnnotation',
              target: '@UI.DataPoint#AverageRating'
           },
           */
        ],
    },
    UI.Facets                    : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet2',
            Label : 'General Information Copia',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    /*    UI.HeaderFacets              : [{
            // Se utiliza desde un data point
            //   $Type : 'UI.ReferenceFacet',
            //  target: //'@UI.DataPoint#AverageRating',
            Label: 'ToCurrency_ID',
            Value: ToCurrency_ID,
        }],
        */
    Capabilities                 : {DeleteRestrictions: {
        $Type    : 'Capabilities.DeleteRestrictionsType',
        Deletable: false

    }, },
    UI.HeaderInfo                : {
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        ImageUrl      : ImageUrl,
        Title         : {Value: ProductName},
        Description   : {Value: Description}
    },
    UI.SelectionFields           : [
        ToCategory_ID,
        ToCurrency_ID

    /*  StockAvailability  */


    ],
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Label: 'ImageUrl',
            Value: ImageUrl,
        },
        {
            $Type: 'UI.DataField',
            Label: 'ProductName',
            Value: ProductName,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Description',
            Value: Description,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : 'Supplier',
            Target: 'Supplier/@Communication.Contact',
        },
        {
            $Type: 'UI.DataField',
            Label: 'ReleaseDate',
            Value: ReleaseDate,
        },
        {
            $Type: 'UI.DataField',
            Label: 'DiscontinuedDate',
            Value: DiscontinuedDate,
        },
        /*   {
                Label: 'Stock',
                Value: StockAvailability,
                Criticality : StockAvailability
            }
              {
                // $Type: 'UI.DataField',
                Label: 'Rating',
               // Value: Rating,
               $Type : 'UI.DataFieldForAnnotation',
               target: '@UI.DataPoint#AverageRating'
            },
            */
        {
            $Type: 'UI.DataField',
            Label: 'Price',
            Value: Price,
        },
    ],
);

annotate service.Products with {
    Supplier @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Supplier',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Supplier_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Email',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Phone',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Fax',
            },
        ],
    }
};

/*
 Anotación para las imagenes
 */
annotate service.Products with {
    ImageUrl @(UI.IsImageURL: true)
};


/**
 * Annotation para las ayuda de busqueda de la entidad producto
 *
 */
annotate service.Products with {
    ToCategory @(Common: {
        Text     : {
            $value                : Category,
            ![@UI.TextArrangement]: #TextOnly,
        },
        ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Categories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCategory_ID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCategory_ID,
                    ValueListProperty: 'Text'
                }
            ]
        },
    });
    ToCurrency @(Common: {
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Currencies',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCurrency_ID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Text'
                }
            ]
        },

    })
};

/**
 * Annotation para las ayuda de busqueda Categories
 *
 */
annotate service.VH_Categories with {
    Code @(
        UI    : {Hidden: true},
        Common: {Text: {
            $value                : Text,
            ![@UI.TextArrangement]: #TextOnly,
        }, }

    );
    Text @(UI: {HiddenFilter: true}, );
};

/**
 * Annotation para las ayuda de busqueda Currencies
 *
 */
annotate service.VH_Currencies with {
    Code @(UI: {HiddenFilter: true}, );
    Text @(UI: {HiddenFilter: true}, );
};

/**
 * Annotation para las ayuda de busqueda Unidades
 *
 */
annotate service.VH_UnitOfMasure with {
    Code @(UI: {HiddenFilter: true}, );
    Text @(UI: {HiddenFilter: true}, );
};

/**
 * Annotation para las ayuda de busqueda DimensionUnits
 *
 */
annotate service.VH_DimensionUnits with {
    Code @(UI: {HiddenFilter: true}, );
    Text @(UI: {HiddenFilter: true}, );
};

/**
 *  Annotation para supplier entityes
 *
 */
annotate service.Supplier with @(Communication: {Contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    role : 'Supplier',
    photo: 'sap-icon://supplier',
    email: [{
        type   : #work,
        address: Email,

    }],
    tel  : [
        {
            type: #work,
            uri : Phone
        },
        {
            type: #work,
            uri : Fax,

        }
    ]
}

});


/**
 * DataPoint for Avarege Rating
 */
//annotate service.Products with @(UI.DataPoint #AverageRating: {
 //   Value        : Rating,
 //   Title        : 'Rating',
//    TargetValue  : 5,
 //   Visualization: #Rating
//});
