using my.bookshop as my from '../db/data-model';

// @requires : 'authenticated-user'
service CatalogService @(requires: 'authenticated-user') {

    // Add authentication to your CAP Service
        entity Books @(
        restrict : [
        {
            grant : ['READ'],
            to    : ['BookViewer']
        },
        {
            grant : ['*'],
            to    : ['BookAdmin']
        }
        ],
        // Add Access Control to your CAP Model/Service
        Capabilities : {
            InsertRestrictions.Insertable : true,
            UpdateRestrictions.Updatable  : true,
            DeleteRestrictions.Deletable  : false
        }
    ) as projection on my.Books;
    annotate Books with @odata.draft.enabled;
    // annotate Books with  @(requires: 'authenticated-user');


}
// Add Instance Based Authorization (Row Level Checks)
annotate Books with @(
    restrict : [{
        grant : [
            'READ',
            'UPDATE',
            'DELETE'
        ],
        where : 'CreatedBy = $user'
    }]
);