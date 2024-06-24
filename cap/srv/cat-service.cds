using my.bookshop as my from '../db/data-model';

service CatalogService @(requires : 'authenticated-user') {
    @readonly
    entity Books @(restrict : [{
        grant : 'READ',
        where : 'stock < 200'
    }]) as projection on my.Books;
}

service Service2 @(requires : 'all_books') {
    @Capabilities : {
        InsertRestrictions.Insertable : true,
        UpdateRestrictions.Updatable  : true,
        DeleteRestrictions.Deletable  : false
    }
    entity Books @(restrict : [
        {
            grant : 'READ',
            to    : 'all_books'
        },
        {
            grant : 'WRITE',
            to    : 'books_with_stock_u200'
        }
    ]) as projection on my.Books;
}

service Service3 @(requires : 'Viewer') {
    entity Books @(restrict : [{
        grant : '*',
        to    : 'Viewer'
    }]) as projection on my.Books;
}
