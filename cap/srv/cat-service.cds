using my.bookshop as my from '../db/data-model';

service CatalogService {
    @readonly entity Books as projection on my.Books;
}

@readonly
    @Capabilities : {
        InsertRestrictions.Insertable : true,
        UpdateRestrictions.Updatable  : true,
        DeleteRestrictions.Deletable  : false
    }
    entity Books @(restrict : [
        {
            grant : ['READ'],
            to    : ['Bookseller']
        },
        {
            grant : ['*'],
            to    : ['BookStoreManager']
        }
    ]) as projection on my.Books;

annotate Books with @(restrict : [{
    grant : [
        'READ',
        'UPDATE',
        'DELETE'
    ],
    where : 'CreatedBy = $user'
}]);