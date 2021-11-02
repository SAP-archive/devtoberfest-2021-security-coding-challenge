using my.bookshop as my from '../db/data-model';

service CatalogService @(requires : 'authenticated-user') {
    @readonly
    entity Books @(restrict : [
        {
            grant : ['READ'],
            to    : 'User'
        },
        {
            grant : [
                'READ',
                'UPDATE',
                'WRITE'
            ],
            to    : 'Admin'
        }
    ]) as projection on my.Books;
}
