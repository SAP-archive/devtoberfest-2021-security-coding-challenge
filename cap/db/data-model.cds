namespace my.bookshop;

entity Books {
  key ID : Integer;
  title  : String;
  stock  : Integer;
  CreatedAt        : Timestamp  @cds.on.insert : $now;
  CreatedBy        : String(255);  
}