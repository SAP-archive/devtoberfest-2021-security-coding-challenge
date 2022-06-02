namespace my.bookshop;
using {
    managed
} from '@sap/cds/common';

entity Books: managed {
  key ID : Integer;
  title  : String;
  stock  : Integer;
  
}