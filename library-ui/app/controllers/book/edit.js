import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    saveBook(values) {
      this.model.setProperties(values);
      this.model.save().then(() => {
        this.transitionToRoute('book.detail', this.model.id);
      });
    }
  }
});
