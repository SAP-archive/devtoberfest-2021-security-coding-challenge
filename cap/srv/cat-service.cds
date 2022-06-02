using my.bookshop as my from '../db/data-model';

@requires : 'authenticated-user'
service CatalogService {
    @requires : 'admin'
    @readonly
    entity Books as projection on my.Books;
}

annotate CatalogService with @(restrict : [{
    grant : ['UPDATE'],
    where : 'stock > 0'
}]);
