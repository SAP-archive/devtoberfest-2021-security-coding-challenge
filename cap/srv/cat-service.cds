using my.bookshop as my from '../db/data-model';

service CatalogService @(requires : 'authenticated-user') {
    @readonly
    entity Books  @(restrict : [{ grant: ['READ'], to: 'StoreClerk',  where: 'stock > 0' }, { grant: ['READ'], to: 'admin',  where: '1=1' }]) as projection on my.Books;
}
