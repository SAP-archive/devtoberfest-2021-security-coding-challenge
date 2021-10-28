using my.bookshop as my from '../db/data-model';

service CatalogService {
    @Capabilities: { 
        InsertRestrictions.Insertable: true,
        UpdateRestrictions.Updatable: true,
        DeleteRestrictions.Deletable: false  
    }
    entity Books @(restrict : [
        {
            grant : ['READ'],
            to    : ['basic']
        },
        {
            grant : ['READ', 'UPDATE', 'WRITE'],
            to    : ['admin']
        }
    ]) as projection on my.Books;
}