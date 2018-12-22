import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    saveAuthor(values) {
      this.model.setProperties(values);
      this.model.save().then(() => {
        this.transitionToRoute('author.detail', this.model.id);
      });
    }
  }
});
