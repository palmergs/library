import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    searchAuthor(query) {
      return this.store.query('author', { filter: { query } });
    },

    saveBook(values) {
      
      const book = this.store.createRecord('book', values);
      book.save().then(() => {
        this.transitionToRoute('book.detail', book.id)
      });
    }
  }
});
