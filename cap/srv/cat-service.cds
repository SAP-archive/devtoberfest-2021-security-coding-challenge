using my.bookshop as my from '../db/data-model';

/* 
service CatalogService @(requires : 'authenticated-user') {
    entity Books @(restrict : [
        {grant : 'READ'} ,
        { grant: ['UPDATE'], to: 'Vendor',  where: 'stock > 0' }        
    ]) as projection on my.Books;
}
*/ 


@path:'browse'
service CatalogService @(requires: 'authenticated-user') {
  @readonly entity Books  
  as select from my.Books { title, stock };
}

@path:'internal'
service VendorService @(requires: 'Vendor') {
  entity Books @(restrict: [
    { grant: 'READ' },
    { grant: 'WRITE', to: 'vendor', where: 'stock > 0' } ]) 
  as projection on my.Books;
}

@path:'internal'
service AccountantService @(requires: 'Accountant') {
  @readonly entity Books as projection on my.Books;
  action doAccounting();
}
/*...*/

