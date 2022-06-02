using my.bookshop as my from '../db/data-model';

service CatalogService {
    @readonly
    @Capabilities : {
        InsertRestrictions.Insertable : true,
        UpdateRestrictions.Updatable  : true,
        DeleteRestrictions.Deletable  : false
    }
    entity Books @(restrict : [
        {
            grant : ['READ'],
            to    : ['DevtoberViewer']
        },
        {
            grant : ['*'],
            to    : ['DevtoberManager']
        }
    ]) as projection on my.Books;
}

annotate Books with @(restrict : [{
    grant : [
        'READ',
        'UPDATE',
        'DELETE'
    ],
    where : 'CreatedBy = $user'
}]);
