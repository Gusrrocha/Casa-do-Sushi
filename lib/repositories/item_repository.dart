import 'package:casadosushi/database/dao/itemDAO.dart';
import 'package:casadosushi/models/item.dart';


class ItemRepository {
  ItemDAO itemDao = ItemDAO();

  Future<Item> createItem(Item item) => itemDao.createItem(item);

  Future<void> deleteItem(int id) => itemDao.deleteItem(id);

  Future<void> updateItem(Item item, int id) => itemDao.updateItem(item, id);
}