import Controller from '@ember/controller';
import { inject as service } from '@ember/service';

export default Controller.extend({
  can: service('can'),

  actions: {
    deleteBook(book) {
      if(this.get('can').can('delete book', this.get('model'))) {
        book.deleteRecord();
        book.save().then(() => {
          this.transitionToRoute('book.index');
        });
      }
    }
  }
});
