using my.bookshop as my from '../db/data-model';

service CatalogService @(requires : 'authenticated-user') {
    entity Books @(restrict: [{
      grant: [ 'UPDATE' ], 
      where: 'stock < 100', // instance access to low-stock items 
      to: [ 'BookSales' ]
    },
    { 
      grant: ['READ'],
      to: ['BookSales']
    },
    {
      grant: [ '*' ],
      to: [ 'BookManager' ]
    }
    ]) as projection on my.Books;
}