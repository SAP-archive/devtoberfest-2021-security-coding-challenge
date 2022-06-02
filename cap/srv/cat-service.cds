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
            to    : ['reader']
        },
        {
            grant : ['READ', 'UPDATE', 'WRITE'],
            to    : ['admin']
        }
    ]) as projection on my.Books;
}

annotate Books with @(restrict: [ 
  { grant: ['UPDATE', 'DELETE'], where: 'CreatedBy = $user' } ]); 
  