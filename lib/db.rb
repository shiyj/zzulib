class User
  include DataMapper::Resource
  property :id,     Serial
  property :card_no,    String
  property :name,       String
  property :books_num,  Integer
end
class BooksIndex
  include DataMapper::Resource
  property :id,     Serial
  property :name,     String
  property :ketu,     String
  property :zhongtu,  String
end
