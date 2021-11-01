using my.bookshop as my from '../db/data-model';

service CatalogService {
    @readonly entity Books @(restrict : [
    {
        grant : [ 'READ' ],
        to : [ 'read_role' ]
    },
    {
        grant : [ '*' ],
        to : [ 'update_role' ]
    }
    ]) as projection on my.Books;
}