using my.bookshop as my from '../db/data-model';

service CatalogService {
    entity Books @(restrict : [
        {
            grant : ['READ'],
            to    : ['basic']
        },
        {
            grant : ['READ', 'UPDATE', 'DELETE', 'WRITE'],
            to    : ['admin']
        }
    ]) as projection on my.Books;
}