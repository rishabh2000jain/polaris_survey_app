class EntryNotFoundException implements Exception{
  int id;
  EntryNotFoundException(this.id);
  @override
  String toString() {
    return 'Entry for id $id not found';
  }
}