using my.bookshop as my from '../db/data-model';

@path : 'browse'
service CatalogService @(requires : 'authenticated-user') {
    @readonly
    entity Books @(restrict : [{
        grant : 'READ',
        where : 'stock > 100'
    }]) as projection on my.Books;
}

@path : 'internal'
service BuilderService @(requires : 'seeAll') {
    @Capabilities : {
        InsertRestrictions.Insertable : true,
        UpdateRestrictions.Updatable  : true,
        DeleteRestrictions.Deletable  : false
    }
    entity Books @(restrict : [
        {grant : 'READ'},
        {
            grant : 'WRITE',
            to    : 'seeAll'
        }
    ]) as projection on my.Books;
}
