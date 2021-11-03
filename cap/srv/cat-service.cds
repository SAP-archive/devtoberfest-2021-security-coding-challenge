using my.bookshop as my from '../db/data-model';

service CatalogService @(requires : 'authenticated-user') {
    entity Books @(restrict : [
        {
            grant : ['READ'],
            to    : 'Employee',
            where : 'stock > 100'
        },
        {
            grant : ['*'],
            to    : 'Admin'
        }
    ]) as projection on my.Books;
}
