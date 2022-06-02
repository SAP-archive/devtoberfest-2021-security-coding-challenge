using my.bookshop as my from '../db/data-model';

service CatalogService @(requires: 'authenticated-user'){
    entity Books     
        @(restrict : [
                {
                    grant : [ 'READ' ],
                    to : [ 'CatalogViewer' ],
                    where: 'CreatedBy = $user and stock > 0'
                    
                },
                {
                    grant : [ '*' ],
                    to : [ 'CatalogManager' ]
                }
            ])
    as projection on my.Books;
}