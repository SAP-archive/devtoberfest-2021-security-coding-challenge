using my.bookshop as my from '../db/data-model';

service CatalogService @(requires : 'authenticated-user') {
    @readonly         
    entity Books @(restrict : [{        
        grant : 'READ',
        to    : 'admin'
    }, {
        grant : 'READ',
        where : 'stock <= 100'
    }    
    ]) as projection on my.Books;
}