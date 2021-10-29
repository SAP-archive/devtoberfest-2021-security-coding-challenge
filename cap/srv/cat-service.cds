using my.bookshop as my from '../db/data-model';

service CatalogService {

    entity Books @(
        restrict : [
        {
            grant : ['READ'],
            to    : ['DevtoberfestViewer']
        },
        {
            grant : ['*'],
            to    : ['DevtoberfestAdmin']
        }
        ],
        Capabilities : {
            InsertRestrictions.Insertable : true,
            UpdateRestrictions.Updatable  : true,
            DeleteRestrictions.Deletable  : false
        }
    ) as projection on my.Books;
    annotate Books with @odata.draft.enabled;
}

annotate Books with @(
    restrict : [{
        grant : [
            'READ',
            'UPDATE',
            'DELETE'
        ],
        where : 'CreatedBy = $user'
    }],
    UI:{
        LineItem: [
            {
                Value: title
            },{
                Value: stock,
                Label: 'Stock'
            },{
                Value: createdBy
            },{
                Value: createdAt
            }
        ]
    }
);