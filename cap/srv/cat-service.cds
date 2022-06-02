using my.bookshop as my from '../db/data-model';

service CatalogService {
    @readonly entity Books @(restrict : [
        {
            grant : [ 'READ' ],
            to : [ 'Reading_role' ]
        },
        {
            grant : [ '*' ],
            to : [ 'Changing_role' ]
        }
    ]) as projection on my.Books;
}