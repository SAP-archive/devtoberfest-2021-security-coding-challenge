using { CatalogService.Books } from './cat-service';

annotate CatalogService.Books with  @(
    UI:{
        LineItem: [
            {
                Value: title,
                Label: 'Title'
            },{
                Value: stock,
                Label: 'Stock'
            }
        ]
    }
);