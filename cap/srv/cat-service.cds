using my.bookshop as my from '../db/data-model';

// only authenticated-user can access service
service CatalogService @(requires : 'authenticated-user') {
    @readonly
    entity Books @(restrict : [{
        grant : ['READ'],       // admin can access all entries
        to    : 'admin'
    }, {
        grant : ['READ'],       // all other authenticated-user can aceess entries with stock larger then 500
        where : 'stock > 100' 
    }
    ]) as projection on my.Books;
}
