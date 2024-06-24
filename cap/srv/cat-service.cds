using my.bookshop as my from '../db/data-model';

// coding challenge 
// - add access control
// - add instance based authorization 
service CatalogService @(requires: 'authenticated-user') {
    @readonly entity Books @(restrict: [{ grant: ['READ'], where: 'stock >= 500' }]) as projection on my.Books;
}