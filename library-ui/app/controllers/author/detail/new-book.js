import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    saveBook(evt) {
      evt.preventDefault();

      const book = this.store.createRecord('book', this.model.book);
      book.save().then(() => {
        this.transitionToRoute('author.detail', this.model.author.id);
      });
    }
  }
});
