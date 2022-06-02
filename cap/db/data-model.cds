namespace my.bookshop;

entity Books {
  key ID : Integer;
  title  : String;
  stock  : Integer;
  createdBy  : String      @cds.on.insert : $user;  
}
